import numpy as np
import matplotlib.pyplot as plt
from sklearn.model_selection import cross_val_score, train_test_split
from sklearn.preprocessing import PolynomialFeatures
from sklearn.linear_model import LinearRegression
from sklearn.pipeline import make_pipeline
from sklearn.metrics import mean_squared_error
from sklearn.linear_model import RidgeCV
import numpy as np
import matplotlib.pyplot as plt
from sklearn.model_selection import cross_val_score, train_test_split
from sklearn.preprocessing import PolynomialFeatures
from sklearn.linear_model import RidgeCV
from sklearn.pipeline import make_pipeline
from sklearn.metrics import mean_squared_error

# Your data here
x = np.array([47, 50, 57, 60, 65, 68, 72, 76, 83, 90, 95, 100, 110])  # shape (13,)
y = np.array([975, 985, 1000, 1005, 1010, 1012, 1020, 1025, 1031, 1080, 1120, 1150, 1200])  # shape (13,)



X = x.reshape(-1, 1)

# Ridge alphas to search over
alphas = np.logspace(-4, 4, 100)

# Train/val split for comparison
X_train, X_val, y_train, y_val = train_test_split(X, y, test_size=0.3, random_state=42)

max_degree = 3  # can go higher now since Ridge regularizes
degrees = range(1, max_degree + 1)

cv_scores = []
val_scores = []
best_alphas = []

for d in degrees:
    model = make_pipeline(PolynomialFeatures(d), RidgeCV(alphas=alphas, store_cv_results=True))
    
    # CV score
    cv_mse = -cross_val_score(model, X, y, cv=5, scoring='neg_mean_squared_error').mean()
    cv_scores.append(cv_mse)
    
    # Single split
    model.fit(X_train, y_train)
    val_scores.append(mean_squared_error(y_val, model.predict(X_val)))
    best_alphas.append(model.named_steps['ridgecv'].alpha_)

print(f'{cv_scores=}')
best_degree = degrees[np.argmin(cv_scores)]
print(f"Best degree by CV: {best_degree}")
print(f"Best alpha at that degree: {best_alphas[best_degree - 1]:.4g}")

# Final model on all data
final_model = make_pipeline(PolynomialFeatures(best_degree), RidgeCV(alphas=alphas))
final_model.fit(X, y)
final_alpha = final_model.named_steps['ridgecv'].alpha_

# Plot
fig, axes = plt.subplots(1, 3, figsize=(14, 4))

# MSE vs degree
axes[0].plot(degrees, cv_scores, 'o-', label='CV MSE')
axes[0].plot(degrees, val_scores, 's--', label='Val MSE')
axes[0].axvline(best_degree, color='r', linestyle=':', alpha=0.5)
axes[0].set_xlabel('Polynomial Degree')
axes[0].set_ylabel('MSE')
axes[0].legend()
axes[0].grid()
axes[0].set_title('Model Selection')

# Best alpha vs degree
axes[1].semilogy(degrees, best_alphas, 'o-')
axes[1].set_xlabel('Polynomial Degree')
axes[1].set_ylabel('Best α (log scale)')
axes[1].set_title('Regularization Strength')
axes[1].grid()

# Fit visualization
x_plot = np.linspace(x.min(), x.max(), 200).reshape(-1, 1)
axes[2].scatter(x, y, c='black', zorder=5, label='Data')
axes[2].plot(x_plot, final_model.predict(x_plot), 'r-', lw=2, 
             label=f'Degree {best_degree}, α={final_alpha:.2g}')
axes[2].set_xlabel('x')
axes[2].set_ylabel('y')
axes[2].legend()
axes[2].grid()
axes[2].set_title('Best Ridge Polynomial Fit')

plt.tight_layout()
plt.show()

# Print coefficients (useful for physics interpretation)
coeffs = final_model.named_steps['ridgecv'].coef_
print(f"\nCoefficients (x^0 to x^{best_degree}):")
print(np.round(coeffs, 4))


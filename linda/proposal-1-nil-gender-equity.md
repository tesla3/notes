# Proposal 1: Predicting the Price of Fame — ML Analysis of NIL Valuation and Gender Equity in College Athletics

## Summary

The NCAA NIL market exploded from $393M (2021) to ~$1.9B (2025). The House v. NCAA $2.8B settlement just reshaped everything. But <3.5% of collective NIL dollars go to women (Opendorse data). What actually determines an athlete's NIL valuation — performance, social media following, school brand, sport, or gender? Can we predict it? And what does the gap tell us about structural inequity?

## Why Anna

She was a D1 Women's Rower at Cornell who retired due to injury and became team manager. She *lived* the invisible-athlete experience — rowing is a non-revenue sport where NIL dollars barely exist. She watched the NIL revolution unfold during her 4 years (2020-2024). This isn't academic to her; it's autobiographical. That authenticity matters for publication and presentation.

## Data Sources (All Publicly Accessible)

| Source | What | Access |
|--------|------|--------|
| **On3 NIL 100 / NIL Rankings** | Per-athlete NIL valuation, sport, school, social media followers | on3.com/nil/rankings — web scraping |
| **NCAA EADA Data** | Athletic dept revenues, expenses, participation by sport & gender per school | ope.ed.gov/athletics — free CSV download |
| **247Sports** | Recruit rankings, commitment data | 247sports.com — web scraping |
| **Social media** | Instagram/TikTok follower counts for athletes | Public profiles, scraping |
| **College sports reference sites** | Team performance (wins/losses), conference, market size | sports-reference.com |

**Sample size:** On3 tracks 10,000+ D1 athletes with NIL valuations. Even scraping the top 500-1,000 gives a rich dataset.

### Key NIL Market Stats (for framing)

- Total NIL market: $917M (2021-22) → $1.67B (2024-25) → projected $2.75B (2025-26)
- Collectives account for ~82% of all NIL compensation
- Football: 49.9% of all compensation; Men's basketball: 17%
- Women's sports: <3.5% of collective dollars, but >15% of commercial dollars
- Top 25 earnings by sport: Football ~$294K, Men's basketball ~$349K, Women's basketball ~$89K, Softball ~$8.5K, Women's volleyball ~$5.9K
- Opendorse data: 150,000+ athlete users, $250M+ in tracked NIL compensation
- Only 4 of On3's Top 100 athletes are women
- When football excluded, women account for ~53% of all NIL activities

## ML Methods (Teachable in 10 Weeks)

### Week 1-3: Web Scraping & Data Collection
- Python: `requests`, `BeautifulSoup`, `selenium`
- Scrape On3 athlete profiles: NIL valuation, sport, school, conference, social media followers
- Scrape NCAA EADA financial data (CSV download)
- Collect social media follower counts from Instagram/TikTok

### Week 3-4: EDA & Feature Engineering
- pandas, matplotlib, seaborn
- Merge athlete-level + school-level + sport-level data
- Feature engineering: followers-per-capita, school revenue rank, conference tier, win%, etc.
- Exploratory visualization of gender gaps, sport distribution, school effects

### Week 5-7: Prediction Models
- Random Forest + XGBoost → predict NIL valuation from features
- Train/test split, cross-validation
- Model comparison (R², MAE, feature importance)
- Baseline: linear regression for comparison

### Week 7-8: Explainability
- SHAP values → "what drives valuation?"
- Partial dependence plots for key features
- Interaction effects (e.g., gender × sport, gender × social media)

### Week 8-9: Gender Equity Analysis
- Oaxaca-Blinder decomposition: how much of the gender gap is explained by observable features vs. unexplained (potential discrimination)?
- Counterfactual: "if this female athlete were male, what would her predicted NIL be?"
- Subsample analysis: within same sport (e.g., basketball M vs W), within same school

### Week 9-10: Paper Writing
- Introduction, lit review, data, methods, results, discussion, conclusion
- Target: 20-30 pages with figures and tables

## Team Task Allocation

- **Student A**: Scrape On3 + social media data, build the athlete-level dataset
- **Student B**: Scrape NCAA EADA financial data, merge with athlete data, EDA + visualization
- **Student C**: ML modeling (with Anna's guidance) — train/test split, model comparison, SHAP analysis
- **Anna**: Overall research design, econometric framing (gender decomposition), paper writing, quality control

## Publication Targets

- *Journal of Sports Economics* (top field journal)
- *International Journal of Sport Finance*
- *ASSA Annual Meeting* student paper sessions
- *Applied Economics Letters* (fast turnaround)
- Pre-print on SSRN or arXiv immediately

## Risks & Mitigations

| Risk | Mitigation |
|------|-----------|
| On3 may rate-limit scraping | Use delays, cache aggressively, or use Wayback Machine snapshots |
| NIL valuations are estimates (not actual deal values) | Acknowledge as limitation; still useful as market signal (standard in literature) |
| Causal claims about gender gap require careful framing | Use Oaxaca-Blinder (well-established in labor economics) |
| Small sample for some sports | Focus on sports with sufficient representation; report sport-specific results |
| Revenue sharing (2025) may change landscape mid-study | Frame as pre-revenue-sharing baseline analysis |

## Key References

- Owens, Rennhoff & Roach (2024). "The impact of NIL contracts on student-athlete college choice." *Applied Economics*, 57(22), 2822-2838.
- "Show Me the Money! The Immediate Impact of NIL" (2024). *Journal of Sport Management*.
- Opendorse "NIL at 3" and "NIL at 4" annual reports (2024, 2025).
- Buffalo Law School (2024). "Data and Demographics Driving NIL Deals."
- Cherullo (2023). Effects of NIL deals on athletic departments' sponsorship revenue.

## Why This Wins

- **Hot topic**: House settlement, revenue sharing launching 2025, gender equity debate
- **Personal story**: Former D1 female athlete in non-revenue sport using ML to expose inequity
- **Novel approach**: Most existing NIL papers use basic regression — ML + SHAP is new
- **Clear narrative**: Conference organizers, journal reviewers, and media will notice
- **High school students will love it**: They follow college sports and understand the stakes

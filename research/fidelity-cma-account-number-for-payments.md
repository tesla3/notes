# Fidelity CMA: Which Account Number to Use for Payments

Source: Reddit r/fidelityinvestments, Bogleheads, Fidelity official docs | Researched 2026-04-01

## Summary

Fidelity CMA accounts have two external account number formats. Neither is universally reliable for payments. The failure modes are complementary — they fail with different institutions for different reasons.

**Decision rule:** Default to 17-digit. If it fails, try 13-digit. Enable checkwriting so you have both.

## The Three Account Numbers

| Format | Example | Where to find |
|---|---|---|
| **Internal** (Fidelity only) | `Z12345678` (letter + 8 digits) | Fidelity.com account list |
| **17-digit** (website/ACH) | `39900000712345678` | Fidelity.com → "Routing Number" link |
| **13-digit** (check/MICR) | `771012345678` | Bottom of Fidelity checks |

- Routing number (all formats): **101205681** (UMB Bank, N.A.)
- Account type when asked: **Checking**
- Bank name when asked: **UMB Bank, N.A.** (changing to "Fidelity Investments partnering with UMB Bank")

### How to construct each from the internal number (Z12345678)

- **17-digit**: `39900000` + replace letter (X→5, Y→6, Z→7) + remaining 8 digits
- **13-digit**: `7710` + replace letter (same mapping) + remaining 8 digits
- Last 9 digits are the same across both formats

## Failure Cases: 17-digit

Fails when the third party's system caps account numbers at fewer than 17 digits (form validation).

| Institution | Failure | Date |
|---|---|---|
| Discover Bank | Can only handle up to 13 digits | May–Aug 2025 |
| Wells Fargo Auto Loan | Won't accept for autopay | Oct 2025 |
| Allstate | Rejected; 13-digit worked immediately | Oct 2025 |
| PenFed | "Doesn't handle 17 digit account numbers correctly" | Multiple 2025 |
| Treasury Direct | Verification error/hold; 13-digit fixed it | Sep–Oct 2025 |
| USAA | Rejected CMA linking for months (later fixed) | 2025 |
| Property tax website | Would not allow 17-digit | Bogleheads 2025 |
| Webull | Stops input at 9 digits | 2024 |

## Failure Cases: 13-digit

Fails when the institution expects the canonical ACH format or when checkwriting is not enabled.

| Institution | Failure | Date |
|---|---|---|
| Poppins Payroll | Direct debit failed; Fidelity phone support said use 17-digit | Feb 2026 |
| Discover | 13-digit direct deposit failed (after 17-digit worked for other things) | Aug 2025 |

Fewer documented failures than 17-digit, but they exist. The 13-digit is not a silver bullet.

## Failures Unrelated to Account Number Format

| Issue | Root cause |
|---|---|
| AMEX declined payment | Funds not yet "available to withdraw" (collection hold, up to 10 business days for EFT pulls) |
| Mortgage "non-transaction account" | Some institutions reject brokerage-based accounts regardless of number |
| Capital One | Rejects UMB intermediary as a matter of policy |

## Fidelity's Own Reps Contradict Each Other

- **FidelityOscar** (2022): Check number "should **only** be used for the checkwriting feature"
- **FidelityMikeS** (2024): "There is **no functional difference** in which one you use"
- **FidelitySamantha** (Feb 2026, most recent): "There is **no functional difference** between the two"

Current official position: both work, no difference. But reality is more complicated.

## Checkwriting Requirement for 7710 Prefix — Contested

- **Fidelity reps**: consistently say checkwriting must be enabled for 13-digit to work
- **Some power users**: claim replacing `39900000` with `7710` works without checkwriting enabled
- **Safe bet**: enable checkwriting (free, just call 800-343-3548; no need to order physical checks)

## Practical Decision Tree

1. **Enable checkwriting** so both numbers are available
2. **Try 17-digit first** — official default, works for the majority of institutions
3. **If 17-digit fails** (usually form too short) → try 13-digit
4. **If both fail** → institution likely rejects UMB/brokerage accounts entirely. Use Fidelity BillPay to push payments instead of letting the biller pull
5. **If payment is declined despite correct number** → check "Available to Withdraw" balance. Pulled-in funds have up to 10 business day hold. Wire or push from external bank settles immediately.

## Key Gotcha: Fund Availability

Many "payment declined" posts are actually fund-hold issues, not account number issues. Funds pulled INTO Fidelity via EFT take up to 10 business days to become "available to withdraw." During this period, debit card purchases, checks, and direct debits will be declined even though the balance appears in the account. Funds received via bank wire or direct deposit (pushed from another institution) are available immediately.

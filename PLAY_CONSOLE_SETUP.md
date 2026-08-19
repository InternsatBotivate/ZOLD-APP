# Play Console Setup Guide — ZOLD (in.zold.app)

Copy-paste reference for the 11 "Finish setting up your app" tasks. Grounded in what the
codebase actually does (see `CLAUDE.md` for architecture) — not a generic template. Re-check
against the code if the app changes materially (new permissions, new KYC flow, analytics added).

Each item below needs an explicit **Save** in its own Play Console page, and some also need a
final submit action — filling the form isn't enough on its own.

---

## 1. Privacy policy
URL: `https://zold-frontend-mzjh.vercel.app/privacy-policy`
Verify it loads before submitting — a dead link is an instant rejection.

## 2. Store listing
Already done. Keep in sync if the icon/screenshots/description change.

## 3. App access
The app requires login (email/password). Provide:
- **"All functionality is restricted"** → Yes
- **Username**: `playreview@zold.in`
- **Password**: `12345678`

KYC is not currently required to use the app (planned for a future release), and
`AuthMiddleware._bypassKyc` is set to `true` for this review build, so the reviewer account
reaches the home screen straight after login/signup — no OTP whitelist or server-side KYC
approval needed. **Note**: `_bypassKyc` is a global flag, not scoped to this one account — it
skips KYC for all users in this build. Flip it back to `false` in
`lib/app/core/middleware/auth_middleware.dart` before a production rollout, unless KYC is
genuinely still optional for real users at that point.

Add a small amount of sample wallet/SIP/transaction data to this account before submitting, so
the reviewer sees populated screens rather than empty states.

## 4. Ads
**No, my app does not contain ads.**
Confirmed: no ad SDK in `pubspec.yaml` (no AdMob, Facebook Audience Network, etc.).

## 5. Content rating
Start the questionnaire. Category: **Reference, News, Or Educational** is wrong — pick the
category that includes financial apps (Play's questionnaire routes this through general
question flow once you select the app isn't a game).
- Violence / sexual content / profanity / drugs / gambling simulation: **No** to all.
- User-generated content / user-to-user communication: **No** (no chat/social features exist).
- **Does the app provide financial services or advice, or facilitate financial transactions?
  Yes** — SIPs, gold/silver purchases, wallet, Razorpay payments.
- Expected result: rated Everyone or Everyone-equivalent, no mature-content flags, but the
  financial-services answer is what matters for the later "Financial features" task.

## 6. Target audience
- **Target age group: 18 and over only.** Do not include under-18 age brackets — this is a
  financial/investment product.
- "Does your app appeal to children?" → **No.**
- Skip the Ads-directed-at-children and COPPA-adjacent sections (not applicable — no under-18
  targeting).

## 7. Data safety
This is the one most likely to have a subtly wrong answer if filled from memory instead of the
code. Declare per the actual data flows below.

### Data collected and/or shared

| Data type | Collected? | Shared with 3rd party? | Purpose | Optional? |
|---|---|---|---|---|
| Name | Yes | No | Account management | Required |
| Email address | Yes | No | Account management, App functionality | Required |
| Phone number | Yes | No | Account management, App functionality | Required |
| Physical address | Yes | No | App functionality (delivery addresses, saved addresses) | Required for delivery, optional otherwise |
| User IDs | Yes | No | Account management, App functionality | Required |
| Approximate location | Yes | No | App functionality (nearby partner/dealer locator via `geolocator`) | Optional (only used on the Partners screen) |
| Precise location | Yes | No | Same as above (fine-location permission also requested) | Optional |
| Photos | Yes | No | App functionality (profile picture; KYC document photo picker) | Optional (profile pic), required for KYC completion |
| Government IDs | Yes | No | Account management (PAN, Aadhaar — see note below) | Required for KYC |
| Purchase history | Yes | No | App functionality, Analytics (wallet transactions, SIP orders, coin purchases) | Required |
| Financial info (other) | Yes | Yes — Razorpay | App functionality, Payment processing | Required to transact |
| App activity / interactions | Yes | No | App functionality (SIP plans, goals, wallet state) | Required |

**Financial info shared with Razorpay**: mark "shared with third party," select **Razorpay** as
the entity if Play Console offers a named-partner field, purpose **Payment processing**. Card
number, CVV, and UPI ID are collected by Razorpay's own SDK/checkout UI, not by ZOLD's own code
— `AppLogger` explicitly redacts these fields (`card_number`, `cvv`, `upi_id`,
`razorpay_secret`) from its own logs, confirming the app treats them as sensitive even though it
doesn't persist them itself.

**Government ID (PAN/Aadhaar) — important nuance**: the in-app KYC screen
(`kyc_controller.dart`) currently only simulates submission locally; it does not transmit PAN/
Aadhaar numbers or document photos to the backend from that screen today. However, the backend
API/data model (`Kyc` in `auth_models.dart`) does define and support these fields, meaning the
system as a whole (app + backend, however KYC data actually reaches it — e.g. an admin-side
flow) processes government ID data. **Declare it as collected** — Play Console asks about what
the app+backend system does with user data, not just what one specific screen's network calls
do today, and under-declaring here is the riskier direction. If you fix the KYC screen to
actually submit data before or after this release, no re-declaration is needed since the answer
doesn't change.

**Not collected**: no analytics/crash-reporting SDK exists (no Firebase, Crashlytics, Sentry,
Mixpanel — confirmed via `pubspec.yaml`/`pubspec.lock`), so do not declare "Analytics" data
usage on general app-activity/device-identifier grounds unless you add such an SDK later.

### Security practices
- **Data encrypted in transit**: Yes (HTTPS via Dio's `baseUrl`).
- **Users can request data deletion**: **Yes.** The app has no in-app account-deletion flow
  (only sub-resource deletes exist — bank account, saved address, payment method, goal, session,
  notifications), but the privacy policy documents an external deletion-request process via
  `privacy@atplusjewellers.com`. Play Console accepts a documented external process in place of
  an in-app flow — point this section at the privacy policy URL:
  `https://zold-frontend-mzjh.vercel.app/privacy-policy`.

## 8. Government apps
**No** — ZOLD is not a government app.

## 9. Financial features
**Do not select "None."** Declare: digital gold/silver purchases and sales, SIPs (systematic
investment plans), wallet/portfolio tracking, gifting, and delivery. Payment processing is via
Razorpay for SIP orders, the coin cart, and metal purchase sessions.

Google's financial-services policy may prompt for supporting documentation (RBI/SEBI
registration, or documentation from whichever licensed partner actually custodies/settles the
gold/silver trades — check with whoever runs ZOLD's backend/compliance on what licensing
framework the business operates under, this is a business/legal question, not a code question).
**Submit this section early** — it's the one most likely to add days of back-and-forth to the
review timeline, so don't leave it for last.

## 10. Health
**No** — no health/wellbeing data is collected (confirmed: no health-related fields in any
model, no health permissions in the manifest). This differs from Botivate's FrogPlanner app,
which does declare health data — don't copy that answer here.

## 11. App category and contact details
- **Category: Finance**
- **Contact email**: `info@botivate.in`
- **Contact website**: `https://zold-frontend-mzjh.vercel.app`

---

## After all 11 are complete
Go to **Publishing overview → Send app for review** (wording may vary). Only after Google
approves this metadata will the real app name, icon, content rating, and description replace
the current "in.zold.app (unreviewed)" / "Unrated" placeholder state — that placeholder is
normal for an internal-testing build with incomplete setup, not a bug in the build or a
Codemagic issue.

## Before any production rollout (separate from the above)
- Swap `RAZORPAY_KEY` in Codemagic's `zold_env` group from the current test key
  (`rzp_test_...`) to Razorpay's live key — test-key payments will fail for real users.
- Revisit `AuthMiddleware._bypassKyc` (`lib/app/core/middleware/auth_middleware.dart:8`) — it's
  set to `true` for this review build so KYC doesn't gate anyone, including the reviewer
  account. Flip back to `false` once KYC is actually built out and required for real users.
- The in-app KYC screen (`kyc_controller.dart`) doesn't call a backend endpoint yet — it's a
  local-only stub. Build out the real submission flow when KYC becomes required.

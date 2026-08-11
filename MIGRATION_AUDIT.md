# Migration Audit - Zold Gold (Next.js to Flutter)

## App Overview
- **Name:** ZOLD
- **Tagline:** Gold for GenZ
- **Core Purpose:** Digital gold investment, SIP, loans against gold, and gifting.
- **Tech Stack (Frontend):** Next.js (App Router), Radix UI, Tailwind CSS v4, Redux Toolkit, Framer Motion, React Hook Form, Razorpay SDK.
- **Tech Stack (Backend):** Node.js, Express, Prisma (ORM), JWT Auth (Cookies/Bearer).

---

## 1. Routes and Features

| Route | Features / Actions | Access |
| :--- | :--- | :--- |
| `/` | Redirects to Home or Login based on auth state. | Public |
| `/login` | Username/Password login, Forgot password flow. | Public |
| `/onboarding` | Sign-up form (Name, Email, Phone, City, Referral), OTP Verification. | Public |
| `/kyc` | KYC document upload/form (inferred from `KYCFlow.tsx`). | Auth |
| `/home` | Dashboard: Metal balances (Gold/Silver), Live Rates, Quick Actions (Buy, Sell, Gift), Portfolio stats. | Auth |
| `/gold` | Detailed gold page: Buying interface, GST calculation, conversion tools. | Auth |
| `/checkout` | Order summary, Address selection, Payment gateway integration (Razorpay). | Auth |
| `/wallet` | Transaction history, Wallet balance, Add funds. | Auth |
| `/profile` | User details, Bank accounts, Payment methods, Security settings, Logout. | Auth |
| `/history` | Full transaction history (Buy, Sell, Gift, Wallet). | Auth |
| `/loans` | Apply for loan against gold, view active loans. | Auth |
| `/manage-sip` | View, Create, Modify, and Top-up Gold SIPs. | Auth |
| `/gold-goals` | Create and track gold saving goals. | Auth |
| `/gift-gold` | Send digital gold to other users. | Auth |
| `/referral` | View referral code, invite friends, view rewards. | Auth |
| `/auspicious-days` | Panchangam-based auspicious days for buying gold. | Auth |
| `/sip-calculator` | Calculate potential SIP returns. | Public |
| `/deliveries` | Manage physical coin deliveries (Partner/Admin roles). | Admin/Partner |
| `/admin-rates` | Manage live rates and GST (Admin). | Admin |
| `/users` | User management (Admin). | Admin |

---

## 2. Reusable Components

- **UI Components:** Accordion, Alert, Avatar, Checkbox, Dropdown, Label, Progress, Select, Slider, Switch, Tabs, Tooltip (Radix-based).
- **ZoldLogo:** Branding component with 'full', 'icon', and 'text' variants.
- **Navigation:** `Sidebar` (desktop) and `BottomNav` (mobile).
- **LumenHeader:** Page header with back button and title.
- **CartDrawer:** Persistent cart for coin purchases.
- **CoinPortfolio:** Summary of owned gold/silver coins.
- **MetalAnimatedBackground:** Thematic background for metal-related screens.
- **FAQPage:** Collapsible list of frequently asked questions.
- **PartnersMap:** Interactive map showing partner locations using Leaflet.

---

## 3. Assets Inventory

### Icons & Logos
- `public/favicon.ico`: App icon.
- `public/02.png`: Main logo/brand image.
- `public/file.svg`, `globe.svg`, `next.svg`, `vercel.svg`, `window.svg`: Utility icons.
- **Lucide React:** Primary source for UI icons (Chevron, History, User, etc.).

### Images (`components/images/`)
- `Zold.webp`, `Zold.jpg`: Brand images.
- `zoldCoin.png`: Generic gold coin image.
- `1gmZold.webp`, `2gmZold.webp`, `5gmZold.webp`, `10gmZold.webp`: Individual gold coins.
- `1gmZoldBox.webp`, `2gmZoldBox.webp`, `5gmZoldBox.webp`, `10gmZoldBox.webp`: Packaged gold coins.
- `buyGoldImage.png`, `sellGoldImage.jpg`, `Sell-Gold.png`, `Sell-Silver.png`: Feature-specific banners.
- `goldSilverCoins.png`, `silver-Zold-Bar.png`, `doubleZoldGold.png`: Decorative assets.
- `ring.webp`, `chain.webp`, `bangle.webp`, `earring.webp`, `necklace.webp`: Jewelry category images.

---

## 4. API Inventory (Backend Contract)

**Base URL:** `/api` (Proxied) or `http://localhost:5001/api`
**Real-time:** Socket.io used for `goldPriceUpdate` and `notification` (joins room by `userId`).

### Auth
- `POST /auth/login`: `{ username, password }` -> `{ success, user }` (Sets cookie).
- `POST /auth/signup`: `{ name, email, username, password, phone, city, referralCode }` -> `{ success, role, message }`.
- `POST /auth/verify-otp`: `{ email, otp }` -> `{ success, message }`.
- `POST /auth/resend-otp`: `{ email }` -> `{ success }`.
- `POST /auth/forgot-password`: `{ email }` -> `{ success }`.
- `POST /auth/reset-password`: `{ enteredOtp, newPassword }` -> `{ success }`.
- `POST /auth/logout`: (Clears cookie).
- `GET /profile`: Current user data.

### Metal / Rates
- `GET /rates/current`: Current Gold/Silver live rates.
- `GET /rates/history`: Historical rate data for charts.
- `GET /meta/gst`: Current GST percentage.
- `GET /rates/live-market`: Fetches current market rates from external APIs.

### Wallet & Transactions
- `GET /wallet/balance`: Available cash and metal balance.
- `GET /wallet/transactions`: List of wallet movements.
- `GET /wallet/stats`: Summary of total invested/earned.

### SIP & Goals
- `POST /sip/create`: Initiate a new SIP.
- `GET /sip/my-sips`: List user's active/past SIPs.
- `POST /gold-goals`: Create a new saving goal.
- `GET /gold-goals`: List user goals.
- `GET /sip/all`: List all SIPs (Admin).

### Coin Purchase Session
- `GET /coin-purchase-session/cart`: Get current cart.
- `POST /coin-purchase-session/cart/item`: Add item.
- `DELETE /coin-purchase-session/cart/item`: Remove item.
- `POST /coin-purchase-session/checkout`: Start checkout flow.
- `POST /coin-purchase-session/create-order`: Create Razorpay order.
- `POST /coin-purchase-session/verify-payment`: Verify payment signature.

### Profile / Settings
- `GET /bank-accounts`: List saved bank accounts.
- `POST /bank-accounts`: Add bank account.
- `PUT /bank-accounts/:id/set-primary`: Set primary account.
- `GET /payment-methods`: List UPI/Card details.
- `PUT /profile/password`: Update user password.
- `GET /sessions`: List active login sessions.
- `DELETE /sessions/:id`: Revoke a session.

---

## 5. Design Tokens

### Colors (Tailwind/CSS Variables)
- **Primary Gold:** `#D4AF37`
- **Light Gold:** `#F5E6A3`
- **Dark Gold:** `#B8960C`
- **Maroon Accent:** `#8B2942`
- **Background:** `#fafafa` (Light) / `#1a1a1a` (Dark)
- **Foreground:** `#1a1a1a` (Light) / `#f5f5f5` (Dark)
- **Text Secondary:** `#6b7280`
- **Gradient Start:** `#3D3066` (Auth screens)
- **Selection:** `bg-[#fff9e8]/90` (from `layout.tsx`)

### Typography
- **Primary Font:** 'Inter', sans-serif.
- **Weights:** 400 (Regular), 500 (Medium), 600 (Semi-bold), 800 (Extra-bold for ZOLD logo).

---

## 6. Forms & Validation

- **Login:** Required fields (Username, Password).
- **Signup:** 
    - Full Name (required)
    - Email (valid email format)
    - Username (required)
    - Password (required)
    - Phone (Exactly 10 digits, +91 prefix)
    - City (required)
- **Bank Account:** 
    - Account Holder Name
    - Account Number
    - IFSC Code
    - Bank Name
- **KYC:** 
    - PAN Number
    - Aadhaar Number
    - Document uploads (Image/PDF)

---

## 7. Handled States

- **Loading:** 'Logging in...', 'Sending OTP...', Skeleton screens (e.g., `HomeTab` skeletons).
- **Empty:** "No transactions found", "No active SIPs".
- **Error:** Red toast/banner for API failures ("Invalid OTP", "Network Error").
- **Auth:** 401 Unauthorized globally handled in `lib/api.ts` to redirect to `/login`.

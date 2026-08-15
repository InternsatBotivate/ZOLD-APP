# ZOLD

ZOLD is a Flutter mobile app for buying and selling digital gold and silver — SIPs (systematic investment plans), gold goals, coin purchases, wallet/portfolio tracking, physical coin delivery, and gifting — plus an admin back-office for user management, sell requests, metal pricing, and GST. Companion web app: https://zold-frontend-mzjh.vercel.app/home

## Getting started

```bash
flutter pub get
```

Copy `.env.example` to `.env` and fill in the real values (backend base URL, Razorpay key, etc.) before running the app — see `CLAUDE.md` for what each key does.

```bash
flutter run
```

## Tech stack

- **Flutter** with **GetX** for state management, dependency injection, and routing
- **Dio** for networking, **Socket.IO** for live rate/notification updates
- **Razorpay** for payments (SIP orders, coin cart checkout, metal purchase sessions)

See [CLAUDE.md](CLAUDE.md) for the full architecture breakdown (module structure, data layer, routing/middleware, release process).

## Releases

Android builds are produced via **Codemagic** (`codemagic.yaml`) and published to the Play Store — there is no local Flutter build step required. See the "Release / Play Store" section in [CLAUDE.md](CLAUDE.md) for details.

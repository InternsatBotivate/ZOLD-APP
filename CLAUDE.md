# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

ZOLD is a Flutter app (package name `zold_gold`) for buying/selling digital gold and silver, SIP (systematic investment plans), gold goals, coin purchases, wallet/portfolio tracking, physical delivery of coins, gifting, and an admin back-office (user management, sell requests, metal pricing, GST). It talks to a REST backend over Dio and a Socket.IO server for live price/notification updates.

## Commands

```bash
flutter pub get                 # install dependencies (run after every pull)
flutter run                     # run on a connected device/simulator
flutter analyze                 # static analysis (flutter_lints ruleset, see analysis_options.yaml)
flutter test                    # run all tests
flutter test test/date_utils_test.dart   # run a single test file
flutter build apk / ipa / web   # platform builds
```

There is no custom lint config beyond the default `flutter_lints` rules — no rules are overridden in `analysis_options.yaml`.

### Environment configuration

The app reads runtime config from a `.env` file at the project root (loaded via `flutter_dotenv` in `lib/main.dart`, declared as a pubspec asset). It is gitignored and **must be created locally** before the app will hit a real backend — without it `ApiConstants.baseUrl` is empty and every network call fails. Expected keys (see `lib/app/core/constants/api_constants.dart`): `BASE_URL`, `CONNECT_TIMEOUT`, `RECEIVE_TIMEOUT`, `RAZORPAY_KEY`, `RISK_DISCLOSURE_PDF_URL`.

## Architecture

The app is built on **GetX** (`package:get`) for state management, dependency injection, and routing — there is no other state-management layer. Every feature module follows the same MVC-ish GetX convention:

```
lib/app/modules/<feature>/
  bindings/    -> Binding classes that wire datasource -> repository -> controller via Get.lazyPut(fenix: true)
  controllers/ -> GetxController subclasses holding .obs state and business logic
  views/       -> Widgets/pages, read state via controller (Get.find() or through Bindings)
  widgets/     -> feature-local widgets (not all modules have this)
```

### Data flow / layering

`lib/app/data/` is a classic repository pattern shared across features:

- `datasources/` — one `XRemoteDataSource` (abstract) + `XRemoteDataSourceImpl` per feature, wraps a single `Dio` call to a REST endpoint.
- `repositories/` — one `XRepository` (abstract) + `XRepositoryImpl` per feature, calls the datasource and maps `Response`/errors into domain models.
- `models/` — plain Dart model classes (`fromJson`/`toJson`) grouped by feature (e.g. `wallet_models.dart`, `sip_models.dart`).

Most datasources/repositories are registered lazily per-module in that module's `Binding` (`Get.lazyPut<X>(() => XImpl(Get.find()), fenix: true)`), **not** globally. A handful of core ones (`AuthRepository`, `ProfileRepository`, `AdminRepository`, `PurchaseRepository` and their datasources) are registered eagerly and `permanent: true` in `lib/main.dart` because they're needed before routing/middleware runs. When adding a new feature, follow the existing module's binding for the wiring pattern — don't assume something is globally available just because `AuthRepository` is.

See `API_COVERAGE.md` for the full endpoint-to-repository mapping (which endpoints are wired up vs. intentionally unused).

### App bootstrap (`lib/main.dart`)

Startup order matters: dotenv loads first (so `ApiConstants.baseUrl` is available), then the shared `Dio` instance and the "always needed" datasources/repositories/services are registered, then `AuthService` and `SocketService` are initialized (with a 5s timeout each, so a slow/failed init doesn't hang the app on a black screen — errors are swallowed and the app still calls `runApp`). Global error handlers (`FlutterError.onError`, `PlatformDispatcher.instance.onError`, `runZonedGuarded`) all funnel into `AppLogger` and still attempt `runApp` on failure — the app is intentionally defensive about never hard-crashing on init.

### Routing & middleware

Routes are centralized in `lib/app/routes/app_routes.dart` (route name constants) and `lib/app/routes/app_pages.dart` (the `GetPage` list with bindings/middlewares). Two `GetMiddleware`s gate navigation:

- `AuthMiddleware` (`lib/app/core/middleware/auth_middleware.dart`) — implements the onboarding → login → KYC → home redirect chain, and restores the last visited route (persisted via `AuthService`/`SharedPreferences`) after login. Read this file before changing anything about auth/onboarding/KYC flow — the redirect logic is order-sensitive (checked as a sequence of `if` guards, not a state machine).
- `AdminMiddleware` — gates the `admin/*` routes on top of `AuthMiddleware`.

`AppPages.initial` is `Routes.onboarding`; almost every route carries `AuthMiddleware()`, so new routes should too unless they're intentionally public (e.g. FAQ, terms, privacy).

### Core services (`lib/app/core/services/`)

- `AuthService` — GetxService, single source of truth for auth/onboarding/KYC state, persisted to `SharedPreferences` + `SecureStorage` (for the token). `AuthService.to` is the standard accessor.
- `SocketService` — Socket.IO client for live updates (rates, notifications).
- `ThemeService` — light/dark theme persistence, initialized before other services so `ZoldApp` always has a valid `themeMode`.

### Networking (`lib/app/core/network/dio_client.dart`)

Single shared `Dio` instance with one `InterceptorsWrapper` handling: bearer token injection from `SecureStorage`, request/response/error logging via `AppLogger` (which filters sensitive fields — see `AppLogger.filterMap`), auto-logout on 401/403 (except for in-flight `/metal-purchase-session/` calls, which are excluded so a purchase in progress doesn't get killed by a stray auth hiccup), and simple retry-with-backoff for idempotent GET requests on connection/timeout errors (max 2 retries).

### Payments

Razorpay (`razorpay_flutter`) is used for SIP orders, coin cart checkout, and metal purchase sessions — each has its own order-create/verify/cancel/record-failure endpoint pair (see `API_COVERAGE.md`). Payment UI state is surfaced via `PaymentProcessingOverlay` (`lib/app/core/widgets/`).

### Admin area

`lib/app/modules/admin/` mirrors the same bindings/controllers/views pattern per sub-feature (`user_management`, `sell_requests`, `metal_price`, `gst_management`), gated by `AdminMiddleware` in addition to `AuthMiddleware`.

## Release / Play Store

Android package name (`applicationId`/`namespace`) is `in.zold.app` (`android/app/build.gradle.kts`, `android/app/src/main/kotlin/in/zold/app/MainActivity.kt`) — this is permanent once published, do not change it after the first Play Store upload.

Builds run on **Codemagic** (`codemagic.yaml`, workflow `android-production`), not locally — this project intentionally has no local Flutter SDK install. Codemagic:
- Reconstructs `.env` from the `zold_env` variable group (see `.env.example` for the required keys).
- Reconstructs the release keystore from `zold_android_signing` (`CM_KEYSTORE` base64, `CM_KEYSTORE_PASSWORD`, `CM_KEY_ALIAS`, `CM_KEY_ALIAS_PASSWORD`) into `android/key.properties` / `android/app/keystore.jks` at build time — neither file is committed (see `.gitignore`).
- Runs `flutter build appbundle --release` and can auto-submit the `.aab` to Play Console via `zold_play_credentials` (Google Play service-account JSON), similar to how FrogPlanner (`FrogPlanner_App`) uses EAS + `google-play-service-account.json` — but Codemagic/Flutter is the equivalent tool here, not EAS, since this is not an Expo/React Native project.
- Triggers on push to `main` and on `v*.*.*` tags; publishes to the `internal` Play Store track as a draft by default — promote to production manually in Play Console until the release process is proven out.

`android/app/build.gradle.kts` currently falls back to debug signing if `android/key.properties` doesn't exist locally, so `flutter build apk/appbundle` still works without the release keystore present.

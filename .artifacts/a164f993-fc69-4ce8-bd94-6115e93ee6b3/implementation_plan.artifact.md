# Phase 5.6 — Dependency Review & Fix

This plan addresses the cleanup of unused dependencies and assets in the `zold_gold` Flutter project, and verifies the compatibility of critical components like Socket.IO.

## User Review Required

> [!IMPORTANT]
> The following packages and assets are identified as **unused** based on a project-wide code analysis. They will be removed to reduce app size and maintenance overhead.
>
> **Packages to be removed:**
> - `flutter_svg`
> - `connectivity_plus`
> - `path_provider`
>
> **Assets to be removed:**
> - Next.js utility icons (e.g., `next.svg`, `vercel.svg`)
> - Unreferenced product images and placeholders (e.g., `01.jpg`, `Zold.webp`, various box images)

## Proposed Changes

### 1. Dependency Cleanup

#### [MODIFY] [pubspec.yaml](file:///C:/Users/PCv/StudioProjects/zold_gold/pubspec.yaml)
- Remove `flutter_svg: ^2.3.0`
- Remove `path_provider: ^2.1.5`
- Remove `connectivity_plus: ^7.2.0`

### 2. Asset Cleanup

#### [DELETE] Unused images and icons in `assets/images/`
The following files will be removed as they are not referenced in the `lib/` directory:
- `01.jpg`
- `file.svg`
- `next.svg`
- `Zold.jpg`
- `globe.svg`
- `ring.webp`
- `Zold.webp`
- `chain.webp`
- `vercel.svg`
- `window.svg`
- `1gmZold.jpg`, `2gmZold.jpg`, `5gmZold.jpg`, `10gmZold.jpg` (WebP versions are used instead)
- `bangle.webp`
- `earring.webp`
- `earring2.jpg`
- `zoldCoin.png`
- `necklace.webp`
- `necklace2.webp`
- `1gmZoldBox.jpg`, `2gmZoldBox.jpg`, `5gmZoldBox.jpg`, `10gmZoldBox.jpg`
- `1gmZoldBox.webp`, `2gmZoldBox.webp`, `5gmZoldBox.webp`, `10gmZoldBox.webp`
- `buyGoldImage.png`
- `sellGoldImage.jpg`
- `doubleZoldGold.png` (Note: `doubleZoldGold2.png` IS used and will be kept)

### 3. Socket.IO Compatibility Verification
- **Current Version:** `socket_io_client` v3.1.6.
- **Backend Version:** `socket.io` v4.8.3.
- **Analysis:** `socket_io_client` v3.x is natively compatible with `socket.io` v4.x servers. The current configuration in `SocketService.dart` correctly uses `websocket` transport and matches the backend's `joinRoom` logic.
- **Action:** No changes or upgrades required.

### 4. fl_chart Compatibility Verification
- **Current Version:** `0.70.2`.
- **Analysis:** `flutter analyze` reports no issues. The existing implementation in `HomeView` and `SipCalculatorView` works as expected.
- **Action:** No changes or upgrades required to avoid breaking changes in major version `1.x`.

## Verification Plan

### Automated Tests
- Run `flutter pub get` to update the lock file and remove unused packages from the cache.
- Run `flutter analyze` to ensure no code relies on the removed packages.

### Manual Verification
- Verify that the app builds and runs correctly on Android.
- Check `HomeView` and `GoldCoinsView` to ensure all expected images still load correctly.
- Verify Socket connection logs in the terminal to ensure real-time price updates still work.

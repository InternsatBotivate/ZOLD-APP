# Fix History Parsing Failure

This plan addresses the `TypeError` occurring during transaction history parsing in the Flutter application. The backend returns `Decimal` values as `String`, while the Flutter models currently attempt to cast them directly to `num`.

## User Review Required

> [!IMPORTANT]
> A reusable parsing utility (`parseDouble` and `parseInt`) will be added to `wallet_models.dart` and used across all data models to ensure consistency and prevent future parsing crashes.

## Proposed Changes

### [Data Models]

#### [MODIFY] [wallet_models.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/data/models/wallet_models.dart)
- Add top-level `parseDouble` and `parseInt` functions.
- Update `WalletBalance`, `Transaction`, and `WalletStats` to use these helpers.
- Ensure `Transaction.fromJson` supports both `camelCase` and `snake_case` keys (e.g., `finalAmount` vs `final_amount`).

#### [MODIFY] [gift_models.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/data/models/gift_models.dart)
- Import `wallet_models.dart`.
- Replace unsafe `as num` cast for `metalGrams`.

#### [MODIFY] [goal_models.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/data/models/goal_models.dart)
- Import `wallet_models.dart`.
- Replace inline `double.parse(...toString())` with `parseDouble`.

#### [MODIFY] [partner_models.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/data/models/partner_models.dart)
- Import `wallet_models.dart`.
- Use `parseDouble` for `rating` and `parseInt` for `reviews`.

#### [MODIFY] [payment_models.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/data/models/payment_models.dart)
- Import `wallet_models.dart`.
- Use `parseInt` for `amount`.

#### [MODIFY] [purchase_models.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/data/models/purchase_models.dart)
- Remove local `parseDouble` helper.
- Import `wallet_models.dart` and use the centralized helper.

#### [MODIFY] [rate_models.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/data/models/rate_models.dart)
- Remove local `_toDouble` helper.
- Import `wallet_models.dart` and use `parseDouble`.

#### [MODIFY] [sip_models.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/data/models/sip_models.dart)
- Remove local `_parseDouble` and `_parseInt` helpers.
- Import `wallet_models.dart` and use the centralized helpers.

#### [MODIFY] [coin_models.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/data/models/coin_models.dart)
- Import `wallet_models.dart`.
- Replace verbose `double.tryParse(...toString())` with `parseDouble`.

#### [MODIFY] [cart_models.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/data/models/cart_models.dart)
- Import `wallet_models.dart`.
- Replace verbose `double.tryParse(...toString())` with `parseDouble`.

### [Data Sources]

#### [MODIFY] [rate_remote_datasource.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/data/datasources/rate_remote_datasource.dart)
- Import `wallet_models.dart`.
- Use `parseDouble` for inline parsing.

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure no type mismatches or missing imports.

### Manual Verification
- Verify that the Transaction History screen now displays data correctly without snackbar errors.
- Verify that both Metal and Coin transactions are parsed correctly.

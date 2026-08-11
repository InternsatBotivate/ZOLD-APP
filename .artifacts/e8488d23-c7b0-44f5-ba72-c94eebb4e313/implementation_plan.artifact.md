# Payment Gateway Failure Fix

Fix the root cause of "Payment gateway unavailable" error by aligning model mapping, datasource nested extraction, and request casing with the backend "Source of Truth".

## User Review Required

> [!IMPORTANT]
> - `MetalPurchaseSession` and `RazorpayOrder` models will be updated to handle both `camelCase` and `snake_case` keys.
> - `createOrder` API call will now correctly extract the nested `order` object from the response.
> - Request payloads for order creation will include both `sessionId` and `session_id` for maximum compatibility.

## Root Cause
1.  **Response Key Mismatch**: `MetalPurchaseSession` was looking for `locked_rate` and `expires_at` but the backend sends `lockedRate` and `expiresAt`.
2.  **Incorrect Data Extraction**: `PurchaseRemoteDataSourceImpl.createOrder` was passing the entire response data to the model factory without drilling down into the `order` object.
3.  **Strict Type Casting**: `RazorpayOrder.fromJson` used `as String` which throws on null values, instead of using safe `toString()` or null-checks.

## Proposed Changes

### [Models]

#### [MODIFY] [purchase_models.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/data/models/purchase_models.dart)
- Update `MetalPurchaseSession.fromJson` to use defensive mapping:
    - `lockedRate`: `json['lockedRate'] ?? json['locked_rate']`
    - `expiresAt`: `json['expiresAt'] ?? json['expires_at']`

#### [MODIFY] [payment_models.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/data/models/payment_models.dart)
- Update `RazorpayOrder.fromJson` to handle `key_id` and use safe string conversion.

---

### [Datasources]

#### [MODIFY] [purchase_remote_datasource.dart](file:///C:/Users/PCv/StudioProjects/zold_gold/lib/app/data/datasources/purchase_remote_datasource.dart)
- Update `createOrder` to extract `order` from `json`.
- Add `session_id` to request body for backward compatibility.

---

### [Verification Plan]

#### Automated Tests
- Run `flutter analyze` to ensure no syntax errors.

#### Manual Verification
- Execute a "Buy" transaction and verify that the Razorpay gateway opens correctly.
- Verify that the timer correctly counts down from `expiresAt`.
- Check logs (if possible) to see the combined `sessionId`/`session_id` request.

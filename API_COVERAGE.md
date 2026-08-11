# API Coverage Summary

| Backend Endpoint | HTTP Method | Flutter Repository | Datasource | Request Model | Response Model | Auth Required | Status |
| :--- | :---: | :--- | :--- | :--- | :--- | :---: | :--- |
| `/auth/login` | POST | AuthRepository | AuthRemoteDataSource | LoginRequest | LoginResponse | No | CONNECTED |
| `/auth/signup` | POST | AuthRepository | AuthRemoteDataSource | SignupRequest | Map<String, dynamic> | No | CONNECTED |
| `/auth/verify-otp` | POST | AuthRepository | AuthRemoteDataSource | VerifyOtpRequest | void | No | CONNECTED |
| `/auth/resend-otp` | POST | AuthRepository | AuthRemoteDataSource | email (String) | void | No | CONNECTED |
| `/auth/forgot-password` | POST | AuthRepository | AuthRemoteDataSource | ForgotPasswordRequest | void | No | CONNECTED |
| `/auth/reset-password` | POST | AuthRepository | AuthRemoteDataSource | ResetPasswordRequest | void | No | CONNECTED |
| `/auth/logout` | POST | AuthRepository | AuthRemoteDataSource | None | void | Yes | CONNECTED |
| `/auth/me` | GET | AuthRepository | AuthRemoteDataSource | None | User | Yes | CONNECTED |
| `/profile` | GET | AuthRepository | AuthRemoteDataSource | None | User | Yes | CONNECTED |
| `/profile` | PUT | ProfileRepository | ProfileRemoteDataSource | UpdateProfileRequest | void | Yes | CONNECTED |
| `/profile/password` | PUT | ProfileRepository | ProfileRemoteDataSource | PasswordRequest | void | Yes | CONNECTED |
| `/users/upload` | POST | ProfileRepository | ProfileRemoteDataSource | MultipartFile | void | Yes | CONNECTED |
| `/rates/current` | GET | RateRepository | RateRemoteDataSource | None | RateResponse | Yes | CONNECTED |
| `/rates/history` | GET | RateRepository | RateRemoteDataSource | None | List<RateHistory> | Yes | CONNECTED |
| `/meta/gst` | GET | RateRepository | RateRemoteDataSource | None | double | Yes | CONNECTED |
| `/wallet/balance` | GET | WalletRepository | WalletRemoteDataSource | None | WalletBalance | Yes | CONNECTED |
| `/wallet/transactions` | GET | WalletRepository | WalletRemoteDataSource | None | List<Transaction> | Yes | CONNECTED |
| `/wallet/stats` | GET | WalletRepository | WalletRemoteDataSource | None | WalletStats | Yes | CONNECTED |
| `/sip/all` | GET | SipRepository | SipRemoteDataSource | None | List<SipPlan> | Yes | CONNECTED |
| `/sip/my-sips` | GET | SipRepository | SipRemoteDataSource | None | List<Sip> | Yes | CONNECTED |
| `/sip/order` | POST | SipRepository | SipRemoteDataSource | SipOrderRequest | RazorpayOrder | Yes | CONNECTED |
| `/sip/verify` | POST | SipRepository | SipRemoteDataSource | SipVerifyRequest | void | Yes | CONNECTED |
| `/sip/topup/order` | POST | SipRepository | SipRemoteDataSource | TopupOrderRequest | RazorpayOrder | Yes | CONNECTED |
| `/sip/topup/verify` | POST | SipRepository | SipRemoteDataSource | SipVerifyRequest | void | Yes | CONNECTED |
| `/sip/modify` | PATCH | SipRepository | SipRemoteDataSource | ModifySipRequest | void | Yes | CONNECTED |
| `/gold-goals` | POST | GoalRepository | GoalRemoteDataSource | CreateGoalRequest | Goal | Yes | CONNECTED |
| `/gold-goals` | GET | GoalRepository | GoalRemoteDataSource | None | List<Goal> | Yes | CONNECTED |
| `/gold-goals/history` | GET | GoalRepository | GoalRemoteDataSource | None | List<Goal> | Yes | CONNECTED |
| `/gold-goals/:id` | PATCH | GoalRepository | GoalRemoteDataSource | UpdateGoalRequest | void | Yes | CONNECTED |
| `/gold-goals/:id` | DELETE | GoalRepository | GoalRemoteDataSource | None | void | Yes | CONNECTED |
| `/coins/types` | GET | CoinRepository | CoinRemoteDataSource | None | List<CoinType> | No | CONNECTED |
| `/coins/inventory` | GET | CoinRepository | CoinRemoteDataSource | None | List<CoinInventory> | Yes | CONNECTED |
| `/coins/buy` | POST | CoinRepository | CoinRemoteDataSource | BuyCoinRequest | void | Yes | CONNECTED |
| `/coins/convert` | POST | CoinRepository | CoinRemoteDataSource | BuyCoinRequest | void | Yes | CONNECTED |
| `/coins/transactions` | GET | CoinRepository | CoinRemoteDataSource | limit | List<CoinTransaction> | Yes | CONNECTED |
| `/coin-purchase-session/cart` | GET | CartRepository | CartRemoteDataSource | None | Cart | Yes | CONNECTED |
| `/coin-purchase-session/cart/item` | POST | CartRepository | CartRemoteDataSource | CartItem | Cart | Yes | CONNECTED |
| `/coin-purchase-session/checkout` | POST | CartRepository | CartRemoteDataSource | None | void | Yes | CONNECTED |
| `/coin-purchase-session/create-order` | POST | CartRepository | CartRemoteDataSource | sessionId | RazorpayOrder | Yes | CONNECTED |
| `/coin-purchase-session/verify-payment` | POST | CartRepository | CartRemoteDataSource | PaymentVerifyRequest | void | Yes | CONNECTED |
| `/coin-purchase-session/record-failure` | POST | CartRepository | CartRemoteDataSource | failureDetails | void | Yes | CONNECTED |
| `/coin-purchase-session/cancel` | POST | CartRepository | CartRemoteDataSource | sessionId | void | Yes | CONNECTED |
| `/metal-purchase-session/initiate` | POST | PurchaseRepository | PurchaseRemoteDataSource | InitiatePurchaseRequest | MetalPurchaseSession | Yes | CONNECTED |
| `/metal-purchase-session/active` | GET | PurchaseRepository | PurchaseRemoteDataSource | None | MetalPurchaseSession | Yes | CONNECTED |
| `/metal-purchase-session/create-order` | POST | PurchaseRepository | PurchaseRemoteDataSource | sessionId | RazorpayOrder | Yes | CONNECTED |
| `/metal-purchase-session/verify-payment` | POST | PurchaseRepository | PurchaseRemoteDataSource | PaymentVerifyRequest | void | Yes | CONNECTED |
| `/metal-purchase-session/checkout` | POST | PurchaseRepository | PurchaseRemoteDataSource | None | void | Yes | CONNECTED |
| `/metal-purchase-session/payment-failed` | POST | PurchaseRepository | PurchaseRemoteDataSource | failureDetails | void | Yes | CONNECTED |
| `/metal-purchase-session/cancel` | POST | PurchaseRepository | PurchaseRemoteDataSource | sessionId | void | Yes | CONNECTED |
| `/metal-gifts/lookup` | GET | GiftRepository | GiftRemoteDataSource | phone | User | Yes | CONNECTED |
| `/metal-gifts/send` | POST | GiftRepository | GiftRemoteDataSource | GiftSendRequest | void | Yes | CONNECTED |
| `/notifications` | GET | NotificationRepository | NotificationRemoteDataSource | None | List<NotificationModel> | Yes | CONNECTED |
| `/notifications/read` | PATCH | NotificationRepository | NotificationRemoteDataSource | None | void | Yes | CONNECTED |
| `/notifications/:id/read` | PATCH | NotificationRepository | NotificationRemoteDataSource | id | void | Yes | CONNECTED |
| `/notifications` | DELETE | NotificationRepository | NotificationRemoteDataSource | None | void | Yes | CONNECTED |
| `/partner` | GET | PartnerRepository | PartnerRemoteDataSource | city | List<Partner> | Yes | CONNECTED |
| `/delivery` | GET | DeliveryRepository | DeliveryRemoteDataSource | None | List<DeliveryModel> | Yes | CONNECTED |
| `/delivery` | POST | DeliveryRepository | DeliveryRemoteDataSource | InitiateDeliveryRequest | void | Yes | CONNECTED |
| `/delivery/:id` | POST | DeliveryRepository | DeliveryRemoteDataSource | id | void | Yes | CONNECTED |

### Intentional Gaps / Unused Endpoints
| Backend Endpoint | HTTP Method | Reason | Status |
| :--- | :---: | :--- | :--- |
| `/delivery/assigned/*` | GET/PATCH | DeliveryRepository | DeliveryRemoteDataSource | tentativeDate | void | Yes | CONNECTED |
| `/delivery/complete/*` | POST | DeliveryRepository | DeliveryRemoteDataSource | id | void | Yes | CONNECTED |
| `/partner/details` | GET/POST | PartnerRepository | PartnerRemoteDataSource | Map | Partner | Yes | CONNECTED |
| `/partner/register` | POST | PartnerRepository | PartnerRemoteDataSource | Map | void | Yes | CONNECTED |
| `/auth/approve-admin/:token` | GET | Admin email flow | NOT YET USED |
| `/users` | ALL | AdminRepository | AdminRemoteDataSource | ALL | User/List<User> | Yes | CONNECTED |
| `/rates/live-market` | GET | RateRepository | RateRemoteDataSource | None | List | Yes | CONNECTED |
| `/rates/update` | POST | RateRepository | RateRemoteDataSource | Map | void | Yes | CONNECTED |
| `/admin/*` | ALL | AdminRepository | AdminRemoteDataSource | ALL | dynamic | Yes | CONNECTED |
| `/bank-accounts` | ALL | ProfileRepository | ProfileRemoteDataSource | BankAccount | BankAccount | Yes | CONNECTED |

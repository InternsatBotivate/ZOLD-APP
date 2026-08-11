import 'package:get/get.dart';
import 'app_routes.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/wallet/views/deliveries_view.dart';
import '../modules/wallet/views/wallet_view.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/signup_view.dart';
import '../modules/auth/views/otp_verification_view.dart';
import '../modules/auth/views/forgot_password_view.dart';
import '../modules/auth/views/reset_password_success_view.dart';
import '../modules/kyc/bindings/kyc_binding.dart';
import '../modules/kyc/views/kyc_view.dart';
import '../modules/kyc/views/kyc_status_view.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/sip/bindings/sip_binding.dart';
import '../modules/sip/views/sip_view.dart';
import '../modules/sip_calculator/bindings/sip_calculator_binding.dart';
import '../modules/sip_calculator/views/sip_calculator_view.dart';
import '../modules/goals/bindings/goals_binding.dart';
import '../modules/goals/views/goals_view.dart';
import '../modules/buy_sell/bindings/buy_sell_binding.dart';
import '../modules/buy_sell/views/buy_sell_view.dart';
import '../modules/gold_coins/bindings/gold_coins_binding.dart';
import '../modules/gold_coins/views/gold_coins_view.dart';
import '../modules/coin_checkout/bindings/coin_checkout_binding.dart';
import '../modules/coin_checkout/views/coin_checkout_view.dart';
import '../modules/coin_checkout/views/payment_success_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/bindings/referral_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile/views/referral_view.dart';
import '../modules/profile/views/saved_addresses_view.dart';
import '../modules/profile/views/bank_accounts_view.dart';
import '../modules/profile/views/security_privacy_view.dart';
import '../modules/profile/views/terms_conditions_view.dart';
import '../modules/profile/views/privacy_policy_view.dart';
import '../modules/profile/views/risk_disclosure_view.dart';
import '../modules/profile/views/notifications_settings_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/profile/views/languages_view.dart';
import '../modules/profile/views/payment_methods_view.dart';
import '../modules/profile/views/personal_information_view.dart';
import '../modules/history/bindings/history_binding.dart';
import '../modules/history/views/history_view.dart';
import '../modules/partners/bindings/partners_binding.dart';
import '../modules/partners/views/partners_view.dart';
import '../modules/home/bindings/auspicious_days_binding.dart';
import '../modules/home/views/auspicious_days_view.dart';
import '../modules/home/views/auspicious_day_detail_view.dart';
import '../modules/wallet/views/gift_gold_view.dart';
import '../modules/wallet/bindings/wallet_binding.dart';
import '../modules/profile/views/faq_view.dart';
import '../modules/admin/user_management/bindings/user_management_binding.dart';
import '../modules/admin/user_management/views/user_management_view.dart';
import '../modules/admin/sell_requests/bindings/sell_requests_binding.dart';
import '../modules/admin/sell_requests/views/sell_requests_view.dart';
import '../modules/admin/metal_price/bindings/metal_price_binding.dart';
import '../modules/admin/metal_price/views/metal_price_view.dart';
import '../modules/admin/gst_management/bindings/gst_management_binding.dart';
import '../modules/admin/gst_management/views/gst_management_view.dart';
import '../core/middleware/auth_middleware.dart';
import '../core/middleware/admin_middleware.dart';

class AppPages {
  static const initial = Routes.onboarding;

  static final pages = [
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.signup,
      page: () => const SignupView(),
      binding: AuthBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.otpVerification,
      page: () => const OTPVerificationView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.forgotPassword,
      page: () => const ForgotPasswordView(),
      binding: AuthBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.resetPassword,
      page: () => const ResetPasswordSuccessView(),
    ),
    GetPage(
      name: Routes.kyc,
      page: () => const KYCView(),
      binding: KYCBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.kycStatus,
      page: () => const KYCStatusView(),
      binding: KYCBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.home,
      page: () => const MainView(),
      binding: MainBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.sip,
      page: () => const SipView(),
      binding: SipBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.sipCalculator,
      page: () => const SipCalculatorView(),
      binding: SipCalculatorBinding(),
    ),
    GetPage(
      name: Routes.buySell,
      page: () => const BuySellView(),
      binding: BuySellBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 250),
    ),
    GetPage(
      name: Routes.goldCoins,
      page: () => const GoldCoinsView(),
      binding: GoldCoinsBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.coinCheckout,
      page: () => const CoinCheckoutView(),
      binding: CoinCheckoutBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.goals,
      page: () => const GoalsView(),
      binding: GoalsBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.history,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.partners,
      page: () => const PartnersView(),
      binding: PartnersBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.deliveries,
      page: () => const DeliveriesView(),
      binding: MainBinding(), // Using MainBinding as it has DeliveryController
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.giftGold,
      page: () => const GiftGoldView(),
      binding: WalletBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.savedAddresses,
      page: () => const SavedAddressesView(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.bankAccounts,
      page: () => const BankAccountsView(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.securitySettings,
      page: () => const SecurityPrivacyView(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.notificationsSettings,
      page: () => const NotificationsSettingsView(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.notifications,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.languages,
      page: () => const LanguagesView(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(name: Routes.faq, page: () => const FAQView()),
    GetPage(name: Routes.terms, page: () => const TermsConditionsView()),
    GetPage(name: Routes.privacy, page: () => const PrivacyPolicyView()),
    GetPage(
      name: Routes.riskDisclosure,
      page: () => const RiskDisclosureView(),
    ),
    GetPage(
      name: Routes.paymentSuccess,
      page: () => const PaymentSuccessView(),
    ),
    GetPage(
      name: Routes.referral,
      page: () => const ReferralView(),
      binding: ReferralBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.walletDetails,
      page: () => const WalletView(),
      binding: WalletBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.portfolio,
      page: () => const WalletView(),
      binding: WalletBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.paymentMethods,
      page: () => const PaymentMethodsView(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.auspiciousDays,
      page: () => const AuspiciousDaysView(),
      binding: AuspiciousDaysBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.auspiciousDayDetail,
      page: () => const AuspiciousDayDetailView(),
      binding: AuspiciousDaysBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.personalInformation,
      page: () => const PersonalInformationView(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),
    // Admin Pages
    GetPage(
      name: Routes.adminUsers,
      page: () => const UserManagementView(),
      binding: UserManagementBinding(),
      middlewares: [AuthMiddleware(), AdminMiddleware()],
    ),
    GetPage(
      name: Routes.adminSellRequests,
      page: () => const SellRequestsView(),
      binding: SellRequestsBinding(),
      middlewares: [AuthMiddleware(), AdminMiddleware()],
    ),
    GetPage(
      name: Routes.adminMetalPrices,
      page: () => const MetalPriceView(),
      binding: MetalPriceBinding(),
      middlewares: [AuthMiddleware(), AdminMiddleware()],
    ),
    GetPage(
      name: Routes.adminManageGst,
      page: () => const GstManagementView(),
      binding: GstManagementBinding(),
      middlewares: [AuthMiddleware(), AdminMiddleware()],
    ),
    GetPage(
      name: Routes.adminDashboard,
      page: () =>
          const UserManagementView(), // Fallback to UserManagement for Dashboard
      binding: UserManagementBinding(),
      middlewares: [AuthMiddleware(), AdminMiddleware()],
    ),
  ];
}

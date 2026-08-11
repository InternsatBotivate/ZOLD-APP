import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../data/models/auth_models.dart';

class ReferralController extends GetxController {
  final totalReferrals = 0.obs;
  final totalEarned = 0.0.obs;
  final pendingReferrals = 0.obs;

  final referralCode = ''.obs;
  final shareLink = ''.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Pre-initialize from existing user if available
    final user = AuthService.to.user.value;
    if (user != null) {
      _updateReferralData(user);
    }

    // Listen to user changes to keep referral code updated
    ever(AuthService.to.user, (user) {
      if (user != null) {
        _updateReferralData(user);
      }
    });

    fetchReferralData();
  }

  void _updateReferralData(User user) {
    referralCode.value = user.referralCode ?? 'N/A';
    shareLink.value = 'https://zold.app/ref/${referralCode.value}';
  }

  Future<void> fetchReferralData() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      // Simulating API call
      await Future.delayed(const Duration(milliseconds: 1000));
      final user = AuthService.to.user.value;
      if (user != null) {
        _updateReferralData(user);
      } else {
        referralCode.value = 'N/A';
        shareLink.value = 'https://zold.app/ref/N/A';
      }

      // Default values for stats as they are not in the user model currently
      totalReferrals.value = 0;
      totalEarned.value = 0.0;
      pendingReferrals.value = 0;
    } catch (e) {
      referralCode.value = 'N/A';
      shareLink.value = 'https://zold.app/ref/N/A';
    } finally {
      isLoading.value = false;
    }
  }

  void copyCode() {
    if (referralCode.value.isEmpty || referralCode.value == 'N/A') return;
    Clipboard.setData(ClipboardData(text: referralCode.value));
    SnackbarUtils.showSuccess('Referral code copied!');
  }

  void copyLink() {
    if (shareLink.value.isEmpty || referralCode.value == 'N/A') return;
    Clipboard.setData(ClipboardData(text: shareLink.value));
    SnackbarUtils.showSuccess('Referral link copied!');
  }

  Future<void> shareToWhatsApp() async {
    if (referralCode.value == 'N/A') return;
    final message =
        "Join ZOLD - India's best digital gold platform! Use my code ${referralCode.value} and get ₹100 bonus. ${shareLink.value}";
    final url = Uri.parse(
      "https://wa.me/?text=${Uri.encodeComponent(message)}",
    );
    await _launchUrl(url, 'WhatsApp');
  }

  Future<void> shareToTwitter() async {
    if (referralCode.value == 'N/A') return;
    final message =
        "Investing in digital gold made easy with @ZoldApp! Use my code ${referralCode.value} to get started. ${shareLink.value}";
    final url = Uri.parse(
      "https://twitter.com/intent/tweet?text=${Uri.encodeComponent(message)}",
    );
    await _launchUrl(url, 'Twitter');
  }

  Future<void> shareMore() async {
    // Since we don't have share_plus, we'll just copy the link as "More"
    copyLink();
  }

  Future<void> _launchUrl(Uri url, String platform) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      copyLink();
      SnackbarUtils.showInfo('$platform not found. Link copied to clipboard.');
    }
  }
}

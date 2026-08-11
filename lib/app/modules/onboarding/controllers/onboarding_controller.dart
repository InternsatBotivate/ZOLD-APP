import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../core/services/auth_service.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;

  final slides = [
    {
      'icon': Icons.monetization_on_outlined,
      'title': 'Save in digital gold from ₹100',
      'description': 'Buy and sell 24K pure gold at live market rates anytime',
    },
    {
      'icon': Icons.store_outlined,
      'title': 'Convert to jewellery at nearby jeweller',
      'description': 'Use your digital gold at our partner stores across India',
    },
    {
      'icon': Icons.local_shipping_outlined,
      'title': 'Secure physical delivery',
      'description':
          'Take physical delivery of your gold coins and bars at your doorstep',
    },
  ];

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void next() {
    if (currentPage.value < slides.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      complete();
    }
  }

  void skip() {
    complete();
  }

  void complete() async {
    await AuthService.to.completeOnboarding();
    Get.offAllNamed(Routes.login);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

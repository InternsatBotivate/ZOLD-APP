import 'dart:math';
import 'package:get/get.dart';

class SipCalculatorController extends GetxController {
  final monthlyInvestment = 5000.0.obs;
  final duration = 12.0.obs; // months
  final expectedReturn = 12.0.obs; // annual %

  double get totalInvestment => monthlyInvestment.value * duration.value;

  double get estimatedReturns {
    final monthlyRate = expectedReturn.value / 12 / 100;
    final dur = duration.value;
    final inv = monthlyInvestment.value;

    if (monthlyRate == 0) return 0;

    // Future Value = P * [((1 + i)^n - 1) / i] * (1 + i)
    final futureValue =
        inv *
        ((pow(1 + monthlyRate, dur) - 1) / monthlyRate) *
        (1 + monthlyRate);
    return futureValue - totalInvestment;
  }

  double get totalValue => totalInvestment + estimatedReturns;

  void setPreset(double amount, double months) {
    monthlyInvestment.value = amount;
    duration.value = months;
  }
}

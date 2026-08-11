import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tithi_engine/tithi_engine.dart';
import 'package:tithi_engine/data/india.dart';
import 'package:tithi_engine/src/astronomy.dart' show moonLongitude;
import 'package:tithi_engine/src/ayanamsha.dart' show toSidereal;
import '../../../data/repositories/rate_repository.dart';
import '../../../core/utils/snackbar_utils.dart';

class AuspiciousDay {
  final int id;
  final String name;
  final DateTime date;
  final String month;
  final int day;
  final String significance;
  final List<String> benefits;
  final String image;
  final List<Color> color;
  final String type; // 'festival' | 'monthly'

  AuspiciousDay({
    required this.id,
    required this.name,
    required this.date,
    required this.month,
    required this.day,
    required this.significance,
    required this.benefits,
    required this.image,
    required this.color,
    required this.type,
  });
}

class TodayPanchang {
  final String tithi;
  final String nakshatra;
  final String sunrise;
  final String masa;

  TodayPanchang({
    required this.tithi,
    required this.nakshatra,
    required this.sunrise,
    required this.masa,
  });
}

class AuspiciousDaysController extends GetxController {
  final RateRepository rateRepository;

  AuspiciousDaysController({required this.rateRepository});

  final isLoading = true.obs;
  final activeTab = 'monthly'.obs;
  final auspiciousDays = <AuspiciousDay>[].obs;
  final todayPanchang = Rxn<TodayPanchang>();
  final nextFestival = Rxn<AuspiciousDay>();
  final goldPrice = 0.0.obs;

  // Detail View State
  final selectedDay = Rxn<AuspiciousDay>();
  final autoBuyController = TextEditingController(text: '5000');
  final autoBuyAmount = 5000.obs;
  final amountError = Rxn<String>();
  final enableAutoBuy = false.obs;
  final isProcessing = false.obs;

  static const int minAmount = 100;
  static const int maxAmount = 1000000;

  static const List<List<Color>> festivalColors = [
    [Color(0xFFEAB308), Color(0xFFF97316)], // yellow to orange
    [Color(0xFFF97316), Color(0xFFEF4444)], // orange to red
    [Color(0xFFA855F7), Color(0xFFEC4899)], // purple to pink
    [Color(0xFF22C55E), Color(0xFF14B8A6)], // green to teal
    [Color(0xFF3B82F6), Color(0xFF06B6D4)], // blue to cyan
    [Color(0xFFEC4899), Color(0xFFF43F5E)], // pink to rose
    [Color(0xFFEF4444), Color(0xFFF97316)], // red to orange
    [Color(0xFF6366F1), Color(0xFFA855F7)], // indigo to purple
  ];

  static const List<String> festivalImages = [
    '🪔',
    '🎆',
    '🕉️',
    '🌸',
    '🎊',
    '⭐',
    '🌟',
    '🪁',
    '🌺',
    '🔱',
  ];

  static const List<String> nakshatraNames = [
    'Ashwini',
    'Bharani',
    'Krittika',
    'Rohini',
    'Mrigashira',
    'Ardra',
    'Punarvasu',
    'Pushya',
    'Ashlesha',
    'Magha',
    'Purva Phalguni',
    'Uttara Phalguni',
    'Hasta',
    'Chitra',
    'Swati',
    'Vishakha',
    'Anuradha',
    'Jyeshtha',
    'Mula',
    'Purva Ashadha',
    'Uttara Ashadha',
    'Shravana',
    'Dhanishta',
    'Shatabhisha',
    'Purva Bhadrapada',
    'Uttara Bhadrapada',
    'Revati',
  ];

  @override
  void onInit() {
    super.onInit();
    // Start fetching gold price immediately as it's a fast network call
    fetchGoldPrice();
  }

  @override
  void onReady() {
    super.onReady();
    // Wait for navigation transition to finish before starting heavy CPU task
    Future.delayed(const Duration(milliseconds: 300), () {
      computeAuspiciousDays();
    });
  }

  Future<void> fetchGoldPrice() async {
    try {
      final response = await rateRepository.getCurrentRates();
      if (response.success && response.data != null) {
        goldPrice.value = response.data!.gold.buyRate;
      }
    } catch (_) {}
  }

  String getFestivalSignificance(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('ekadashi')) {
      return 'Ekadashi is a sacred fasting day observed twice a month. Highly auspicious for gold purchases and new beginnings.';
    }
    if (lower.contains('diwali') || lower.contains('deepavali')) {
      return 'Festival of lights and prosperity. Buying gold on Diwali is considered highly auspicious and brings wealth.';
    }
    if (lower.contains('dhanteras')) {
      return 'Festival of wealth dedicated to Goddess Lakshmi. Buying gold on Dhanteras is one of the most auspicious acts.';
    }
    if (lower.contains('akshaya')) {
      return 'Most auspicious day to buy gold. Any investment made on Akshaya Tritiya is believed to grow endlessly.';
    }
    if (lower.contains('navratri')) {
      return 'Nine-day festival celebrating divine feminine energy. Auspicious for investments and new purchases.';
    }
    if (lower.contains('sankranti')) {
      return 'Harvest festival marking the sun\'s transition. Traditional time for gold buying and new ventures.';
    }
    if (lower.contains('purnima') || lower.contains('poornima')) {
      return 'Full moon day — considered highly auspicious in Hindu tradition for major financial decisions.';
    }
    if (lower.contains('amavasya')) {
      return 'New moon day. Auspicious for ancestral rituals and gold gifting in many traditions.';
    }
    return '$name is an auspicious day in the Hindu calendar. Ideal for gold purchases and new investments.';
  }

  String getNakshatra(DateTime dt) {
    final lon = moonLongitude(dt);
    final siderealLon = toSidereal(lon, dt);
    final index = (siderealLon / (360 / 27)).floor() % 27;
    return nakshatraNames[index];
  }

  Future<void> computeAuspiciousDays() async {
    isLoading.value = true;
    try {
      final panchang = Panchang([registerIndia]);
      final today = DateTime.now();
      final city = City.mumbai;

      // Today's Panchang
      try {
        final tInfo = panchang.tithiOnDate(today, city);
        final sunrise = panchang.sunrise(today, city);
        todayPanchang.value = TodayPanchang(
          tithi: tInfo.tithiName,
          nakshatra: getNakshatra(today),
          sunrise: DateFormat('hh:mm a').format(sunrise.toLocal()),
          masa: tInfo.month.displayName,
        );
      } catch (_) {}

      final List<AuspiciousDay> festivalsList = [];
      final List<AuspiciousDay> monthlyList = [];
      final Set<String> seenFestivals = {};

      // Process for 180 days
      for (int i = 1; i <= 180; i++) {
        // Yield to event loop every 15 iterations to prevent UI jank
        if (i % 15 == 0) {
          await Future.delayed(Duration.zero);
        }

        final date = today.add(Duration(days: i));
        final dateStr = DateFormat('yyyy-MM-dd').format(date);
        final monthName = DateFormat('MMMM').format(date);
        final dayNum = date.day;

        try {
          // Festivals using tithi_engine's built-in festivals
          for (final def in festivals) {
            final fDate = panchang.dateFor(def, date.year, city);
            if (fDate != null &&
                fDate.date.year == date.year &&
                fDate.date.month == date.month &&
                fDate.date.day == date.day) {
              final key = '$dateStr-${def.name}';
              if (!seenFestivals.contains(key)) {
                seenFestivals.add(key);
                final index = festivalsList.length;
                festivalsList.add(
                  AuspiciousDay(
                    id: festivalsList.length + 1,
                    name: def.name,
                    date: date,
                    month: monthName,
                    day: dayNum,
                    significance: getFestivalSignificance(def.name),
                    benefits: [
                      'Exclusive festival gold rates',
                      'Special offers on this day',
                      'Auto-buy available',
                      'Free storage for 3 months',
                    ],
                    image: festivalImages[index % festivalImages.length],
                    color: festivalColors[index % festivalColors.length],
                    type: 'festival',
                  ),
                );
              }
            }
          }

          // Pushya Nakshatra (first 90 days only)
          if (i <= 90 && getNakshatra(date) == 'Pushya') {
            final key = '$dateStr-Pushya';
            if (!seenFestivals.contains(key)) {
              seenFestivals.add(key);
              monthlyList.add(
                AuspiciousDay(
                  id: 100 + monthlyList.length + 1,
                  name: 'Pushya Nakshatra',
                  date: date,
                  month: monthName,
                  day: dayNum,
                  significance:
                      'Pushya is the most auspicious nakshatra for wealth accumulation. Gold bought on this day is believed to multiply in value.',
                  benefits: [
                    'Free storage for 3 months',
                    'Auto-buy available',
                    'Special muhurat timing',
                  ],
                  image: '⭐',
                  color: [const Color(0xFF6366F1), const Color(0xFFA855F7)],
                  type: 'monthly',
                ),
              );
            }
          }
        } catch (_) {}
      }

      auspiciousDays.assignAll([...monthlyList, ...festivalsList]);
      if (festivalsList.isNotEmpty) {
        nextFestival.value = festivalsList.first;
      }
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  int getDaysUntil(DateTime eventDate) {
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    final eventOnly = DateTime(eventDate.year, eventDate.month, eventDate.day);
    return eventOnly.difference(todayOnly).inDays;
  }

  void selectDay(AuspiciousDay day) {
    selectedDay.value = day;
    enableAutoBuy.value = false;
    amountError.value = null;
    isProcessing.value = false;
    autoBuyAmount.value = 5000;
    autoBuyController.text = '5000';
  }

  void updateAmountFromChip(int amount) {
    autoBuyAmount.value = amount;
    autoBuyController.text = amount.toString();
    amountError.value = null;
  }

  void validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      amountError.value = 'Please enter an amount';
      return;
    }
    final amount = int.tryParse(value);
    if (amount == null) {
      amountError.value = 'Invalid amount';
    } else if (amount < minAmount) {
      amountError.value = 'Minimum amount is ₹$minAmount';
    } else if (amount > maxAmount) {
      amountError.value = 'Maximum amount is ₹10 Lakhs';
    } else {
      amountError.value = null;
      autoBuyAmount.value = amount;
    }
  }

  Future<void> handleSetAutoBuy() async {
    if (selectedDay.value == null) return;

    validateAmount(autoBuyAmount.value.toString());
    if (amountError.value != null) return;

    isProcessing.value = true;
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    isProcessing.value = false;

    enableAutoBuy.value = true;
    Get.back(); // Close detail view after success
    SnackbarUtils.showSuccess(
      'Auto-buy scheduled for ${selectedDay.value!.name}! ₹${autoBuyAmount.value} will be auto-invested.',
    );
  }

  List<AuspiciousDay> get filteredDays =>
      auspiciousDays.where((d) => d.type == activeTab.value).toList();
}

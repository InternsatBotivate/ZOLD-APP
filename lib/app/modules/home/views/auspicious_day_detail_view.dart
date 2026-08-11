import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auspicious_days_controller.dart';

class AuspiciousDayDetailView extends GetView<AuspiciousDaysController> {
  const AuspiciousDayDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuspiciousDay day = Get.arguments;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Initialize controller state for this day
    if (controller.selectedDay.value != day) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.selectDay(day);
      });
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: isDark
            ? const Color(0xFF171717)
            : const Color(0xFFF9FAFB),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            _buildSliverAppBar(context, day),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCountdown(day),
                    const SizedBox(height: 28),
                    _buildSectionTitle(
                      context,
                      'Significance',
                      Icons.star_outline,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      day.significance,
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black87,
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildSectionTitle(
                      context,
                      'Special Benefits',
                      Icons.card_giftcard,
                    ),
                    const SizedBox(height: 16),
                    ...day.benefits.map((b) => _buildBenefitItem(b, isDark)),
                    const SizedBox(height: 32),
                    _buildAutoBuyCard(context, day, isDark),
                    const SizedBox(height: 24),
                    _buildReminderBanner(isDark, day),
                    const SizedBox(height: 40),
                    _buildFooterActions(context, day),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, AuspiciousDay day) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      elevation: 0,
      backgroundColor: day.color.last,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: day.color,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                bottom: -20,
                child: Opacity(
                  opacity: 0.2,
                  child: Text(day.image, style: const TextStyle(fontSize: 180)),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Text(day.image, style: const TextStyle(fontSize: 64)),
                    const SizedBox(height: 8),
                    Text(
                      day.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${day.month} ${day.day}, ${DateTime.now().year}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
        ),
        onPressed: () => Get.back(),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFD4AF37), size: 20),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitItem(String text, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2923) : const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF2D3D34) : const Color(0xFFDCFCE7),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Color(0xFF16A34A),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 12),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isDark
                    ? const Color(0xFF86EFAC)
                    : const Color(0xFF166534),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdown(AuspiciousDay day) {
    final daysUntil = controller.getDaysUntil(day.date);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3D3066), Color(0xFF5C4E7F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3D3066).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            daysUntil.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 60,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'DAYS REMAINING',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.timer_outlined, color: Colors.white70, size: 14),
                SizedBox(width: 6),
                Text(
                  'Best time to buy: 06:30 AM - 11:45 AM',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutoBuyCard(
    BuildContext context,
    AuspiciousDay day,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F1F1F) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.grey[200]!,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF3D3066).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.flash_on,
                  color: Color(0xFF3D3066),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Setup Smart Auto-Buy',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'ZOLD will automatically complete your purchase on the auspicious day at the best market rate.',
            style: TextStyle(
              color: isDark ? Colors.white60 : Colors.black54,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'PURCHASE AMOUNT',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() {
            final error = controller.amountError.value;
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF262626)
                    : const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: error != null
                      ? Colors.red.withValues(alpha: 0.5)
                      : (isDark ? Colors.white10 : Colors.grey[300]!),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    '₹',
                    style: TextStyle(
                      color: error != null
                          ? Colors.red
                          : (isDark ? Colors.white70 : Colors.black54),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: controller.autoBuyController,
                      onChanged: (v) => controller.validateAmount(v),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => controller.handleSetAutoBuy(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Amount',
                        hintStyle: TextStyle(
                          color: Colors.grey.withValues(alpha: 0.4),
                          fontSize: 18,
                        ),
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          Obx(
            () => controller.amountError.value != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 8, left: 4),
                    child: Text(
                      controller.amountError.value!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 12),
          Obx(
            () => Text(
              'Estimated Gold: ${controller.goldPrice.value > 0 && controller.amountError.value == null ? (controller.autoBuyAmount.value / controller.goldPrice.value).toStringAsFixed(4) : '...'} gms',
              style: TextStyle(
                color: isDark ? Colors.white38 : Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _amountChip(1000, isDark),
              const SizedBox(width: 8),
              _amountChip(5000, isDark),
              const SizedBox(width: 8),
              _amountChip(10000, isDark),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF3D3066).withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF3D3066).withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enable Auto-Buy',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'One-click schedule',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => Switch.adaptive(
                    value: controller.enableAutoBuy.value,
                    onChanged: (v) => controller.enableAutoBuy.value = v,
                    activeTrackColor: const Color(
                      0xFF3D3066,
                    ).withValues(alpha: 0.5),
                    activeThumbColor: const Color(0xFF3D3066),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _amountChip(int amount, bool isDark) {
    return Expanded(
      child: Obx(() {
        final isSelected = controller.autoBuyAmount.value == amount;
        return InkWell(
          onTap: () => controller.updateAmountFromChip(amount),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF3D3066)
                  : (isDark ? const Color(0xFF262626) : Colors.white),
              border: Border.all(
                color: isSelected ? Colors.transparent : Colors.grey[300]!,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '₹${amount ~/ 1000}k',
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.white60 : Colors.black54),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildReminderBanner(bool isDark, AuspiciousDay day) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2D3D) : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.notifications_active_outlined,
            color: Color(0xFF2563EB),
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'We will notify you 24 hours before ${day.name} starts.',
              style: const TextStyle(
                color: Color(0xFF1E40AF),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterActions(BuildContext context, AuspiciousDay day) {
    return Row(
      children: [
        Expanded(
          child: Obx(() {
            final isValid =
                controller.amountError.value == null &&
                controller.autoBuyAmount.value > 0;
            final isProcessing = controller.isProcessing.value;

            return ElevatedButton(
              onPressed: (isValid && !isProcessing)
                  ? () => controller.handleSetAutoBuy()
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3D3066),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[300],
                padding: const EdgeInsets.symmetric(vertical: 20),
                elevation: isValid ? 4 : 0,
                shadowColor: const Color(0xFF3D3066).withValues(alpha: 0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: isProcessing
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'SCHEDULE NOW',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
            );
          }),
        ),
      ],
    );
  }
}

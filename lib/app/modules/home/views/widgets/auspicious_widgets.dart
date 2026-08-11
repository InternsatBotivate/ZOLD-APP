import 'package:flutter/material.dart';
import '../../controllers/auspicious_days_controller.dart';

class TodayPanchangCard extends StatelessWidget {
  final TodayPanchang panchang;
  final AuspiciousDay? nextFestival;
  final int Function(DateTime) getDaysUntil;

  const TodayPanchangCard({
    super.key,
    required this.panchang,
    this.nextFestival,
    required this.getDaysUntil,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3D3066), Color(0xFF5C4E7F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3D3066).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "TODAY'S PANCHANG",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.white70, size: 10),
                    SizedBox(width: 4),
                    Text(
                      'Mumbai',
                      style: TextStyle(color: Colors.white70, fontSize: 9),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _panchangItem('Tithi', panchang.tithi),
              _panchangItem('Nakshatra', panchang.nakshatra),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _panchangItem('Masa', panchang.masa),
              _panchangItem('Sunrise', panchang.sunrise),
            ],
          ),
          if (nextFestival != null) ...[
            const Divider(color: Colors.white24, height: 24),
            Row(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  color: Color(0xFFD4AF37),
                  size: 14,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: 'Next festival: ',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      children: [
                        TextSpan(
                          text: nextFestival!.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' in ${getDaysUntil(nextFestival!.date)} days',
                          style: const TextStyle(color: Color(0xFFD4AF37)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _panchangItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 11),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class InfoBanner extends StatelessWidget {
  const InfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2E2445) : const Color(0xFFFAF5FF),
        border: Border.all(
          color: isDark ? const Color(0xFF4C3D77) : const Color(0xFFE9D5FF),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.stars, color: Color(0xFF9333EA), size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Exclusive Benefits',
                  style: TextStyle(
                    color: Color(0xFF7E22CE),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Schedule auto-buy on auspicious days and get exclusive discounts + bonuses automatically!',
                  style: TextStyle(color: Color(0xFF9333EA), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AuspiciousDayCard extends StatelessWidget {
  final AuspiciousDay day;
  final bool isDark;
  final int daysLeft;
  final VoidCallback onTap;

  const AuspiciousDayCard({
    super.key,
    required this.day,
    required this.isDark,
    required this.daysLeft,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF262626) : Colors.white,
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.grey[200]!,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 85,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: day.color,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(day.image, style: const TextStyle(fontSize: 22)),
                  const SizedBox(height: 4),
                  Text(
                    day.month.substring(0, 3).toUpperCase(),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    day.day.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          day.name,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: (daysLeft <= 7
                              ? Colors.red.withValues(alpha: 0.1)
                              : Colors.blue.withValues(alpha: 0.1)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$daysLeft d left',
                          style: TextStyle(
                            color: daysLeft <= 7 ? Colors.red : Colors.blue,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    day.significance,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.black54,
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.bolt, color: Colors.amber[700], size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'Special Rewards Available',
                        style: TextStyle(
                          color: Colors.amber[800],
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Details',
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFFD4AF37)
                              : const Color(0xFF3D3066),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: isDark
                            ? const Color(0xFFD4AF37)
                            : const Color(0xFF3D3066),
                        size: 16,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WhyBuySection extends StatelessWidget {
  final bool isDark;

  const WhyBuySection({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F1F1F) : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.transparent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: Color(0xFFD4AF37),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Why Buy Gold on Shubh Muhurat?',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _whyItem(
            Icons.auto_graph,
            const Color(0xFFD4AF37),
            'Prosperity & Luck',
            'Traditionally believed to bring endless wealth and spiritual blessings to the family.',
          ),
          const Divider(height: 32, thickness: 0.5),
          _whyItem(
            Icons.discount_outlined,
            const Color(0xFF16A34A),
            'Exclusive Offers',
            'Access special low rates and bonus gold rewards available only on these specific dates.',
          ),
          const Divider(height: 32, thickness: 0.5),
          _whyItem(
            Icons.settings_suggest_outlined,
            const Color(0xFF3D3066),
            'Smart Automation',
            'Lock in your purchase today with Auto-Buy and never miss an auspicious timing.',
          ),
        ],
      ),
    );
  }

  Widget _whyItem(IconData icon, Color color, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: TextStyle(
                  color: isDark ? Colors.white60 : Colors.black54,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

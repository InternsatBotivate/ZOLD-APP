import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zold_gold/app/core/theme/app_colors.dart';
import '../../../core/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/partners_controller.dart';
import '../../../data/models/partner_models.dart';

class PartnersView extends GetView<PartnersController> {
  const PartnersView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Obx(
            () => CustomScrollView(
              slivers: [
                _buildSliverAppBar(context),
                SliverToBoxAdapter(child: _buildWelcomeHeader(context)),
                SliverToBoxAdapter(child: _buildCompleteProfileCard(context)),
                _buildStickyHeader(context),
                if (controller.isLoading.value)
                  _buildSkeletonLoader(context)
                else if (controller.userRole.value == 'PARTNER')
                  SliverToBoxAdapter(child: _buildPartnerProfile(context))
                else if (controller.viewMode.value == 'map')
                  SliverFillRemaining(child: _buildMapView(context))
                else
                  _buildPartnersList(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return SliverAppBar(
      title: Text(
        'Partners',
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: isDark
          ? theme.colorScheme.surface
          : const Color(0xFFFDF8E8),
      elevation: 0,
      foregroundColor: theme.colorScheme.onSurface,
      pinned: true,
      actions: [
        if (controller.userRole.value == 'ADMIN')
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddPartnerDialog(context),
          ),
      ],
    );
  }

  Widget _buildWelcomeHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      color: isDark ? theme.colorScheme.surface : const Color(0xFFFDF8E8),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Text(
          'Find and visit our trusted partners nearby',
          style: TextStyle(
            color: theme.textTheme.bodySmall?.color,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildStickyHeader(BuildContext context) {
    if (controller.userRole.value == 'PARTNER') {
      return const SliverToBoxAdapter();
    }
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _StickyHeaderDelegate(
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? theme.colorScheme.surface : const Color(0xFFFDF8E8),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(32),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSearchBar(context),
              _buildViewToggle(context),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompleteProfileCard(BuildContext context) {
    if (controller.userRole.value != 'PARTNER' || controller.hasProfile.value) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: isDark
                ? [
                    theme.colorScheme.primary.withValues(alpha: 0.5),
                    theme.colorScheme.secondary.withValues(alpha: 0.5),
                  ]
                : [const Color(0xFFCEBCF1), const Color(0xFFA78BFA)],
          ),
          boxShadow: [
            BoxShadow(
              color:
                  (isDark ? theme.colorScheme.primary : const Color(0xFFCEBCF1))
                      .withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(19),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? theme.colorScheme.primary
                      : const Color(0xFF3D3066),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  color: isDark ? Colors.black : Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Complete Your Profile',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Add your business details to be visible to customers.',
                      style: TextStyle(
                        color: theme.textTheme.bodySmall?.color,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _showCompleteProfileDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark
                      ? theme.colorScheme.primary
                      : const Color(0xFF3D3066),
                  foregroundColor: isDark ? Colors.black : Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          onChanged: (val) => controller.searchQuery.value = val,
          style: TextStyle(color: theme.colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: 'Search by store, city, or area',
            hintStyle: TextStyle(color: theme.textTheme.bodySmall?.color),
            prefixIcon: Icon(
              Icons.search,
              color: theme.textTheme.bodySmall?.color,
            ),
            fillColor: theme.colorScheme.surfaceContainer,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildViewToggle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Obx(
              () => _buildToggleButton(
                context,
                icon: Icons.list,
                label: 'List View',
                isSelected: controller.viewMode.value == 'list',
                onTap: () => controller.viewMode.value = 'list',
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Obx(
              () => _buildToggleButton(
                context,
                icon: Icons.map,
                label: 'Map View',
                isSelected: controller.viewMode.value == 'map',
                onTap: () => controller.viewMode.value = 'map',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.surface
              : theme.colorScheme.surface.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartnerProfile(BuildContext context) {
    final partner = controller.partnerOwnProfile.value;
    if (partner == null || !controller.hasProfile.value) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: _buildPartnerCard(context, partner, isOwn: true),
    );
  }

  Widget _buildMapView(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        FlutterMap(
          mapController: controller.mapController,
          options: MapOptions(
            initialCenter: controller.mapCenter.value,
            initialZoom: controller.mapZoom.value,
            onTap: (_, __) => controller.selectedPartner.value = null,
            onMapReady: () => controller.setMapReady(true),
          ),
          children: [
            TileLayer(
              urlTemplate: isDark
                  ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png'
                  : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.zold_gold',
            ),
            Obx(
              () => MarkerLayer(
                markers: controller.filteredPartners
                    .map((partner) {
                      final lat = double.tryParse(partner.latitude ?? '');
                      final lng = double.tryParse(partner.longitude ?? '');
                      if (lat == null || lng == null) return null;
                      return Marker(
                        point: LatLng(lat, lng),
                        width: 40,
                        height: 40,
                        child: GestureDetector(
                          onTap: () => controller.selectPartner(partner),
                          child: Icon(
                            Icons.location_on,
                            color:
                                controller.selectedPartner.value?.id ==
                                    partner.id
                                ? theme.colorScheme.primary
                                : (isDark
                                      ? theme.colorScheme.secondary
                                      : AppColors.darkGold),
                            size: 40,
                          ),
                        ),
                      );
                    })
                    .whereType<Marker>()
                    .toList(),
              ),
            ),
            if (controller.currentPosition.value != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(
                      controller.currentPosition.value!.latitude,
                      controller.currentPosition.value!.longitude,
                    ),
                    width: 20,
                    height: 20,
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.3,
                            ),
                            blurRadius: 8,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            mini: true,
            backgroundColor: theme.colorScheme.surface,
            onPressed: controller.centerOnCurrentLocation,
            child: Icon(Icons.my_location, color: theme.colorScheme.primary),
          ),
        ),
        Obx(() {
          final selected = controller.selectedPartner.value;
          if (selected == null) return const SizedBox.shrink();
          return Positioned(
            bottom: 80,
            left: 16,
            right: 16,
            child: _buildPartnerCard(context, selected),
          );
        }),
      ],
    );
  }

  Widget _buildPartnersList(BuildContext context) {
    if (controller.filteredPartners.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: Theme.of(context).disabledColor,
              ),
              const SizedBox(height: 16),
              Text(
                'No partners found',
                style: TextStyle(
                  color: Theme.of(context).disabledColor,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      sliver: SliverLayoutBuilder(
        builder: (context, constraints) {
          // Multi-column support for wider screens (tablets/foldables)
          final crossAxisCount = constraints.crossAxisExtent > 800
              ? 3
              : (constraints.crossAxisExtent > 500 ? 2 : 1);

          if (crossAxisCount > 1) {
            return SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.1, // Adjusted for grid view
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildPartnerCard(
                  context,
                  controller.filteredPartners[index],
                ),
                childCount: controller.filteredPartners.length,
              ),
            );
          } else {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildPartnerCard(
                    context,
                    controller.filteredPartners[index],
                  ),
                ),
                childCount: controller.filteredPartners.length,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildPartnerCard(
    BuildContext context,
    Partner partner, {
    bool isOwn = false,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return InkWell(
      onTap: () => _showPartnerDetails(context, partner),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.dividerColor),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        partner.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${partner.area}, ${partner.city} ${partner.distance != null ? "• ${partner.distance} km" : ""}',
                            style: TextStyle(
                              color: theme.textTheme.bodySmall?.color,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: theme.colorScheme.primary,
                                  size: 12,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  partner.rating.toString(),
                                  style: TextStyle(
                                    color: isDark
                                        ? theme.colorScheme.primary
                                        : AppColors.sipTextGold,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${partner.reviews} reviews)',
                            style: TextStyle(
                              color: theme.textTheme.bodySmall?.color,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildTrustBadge(
                      context,
                      'BIS',
                      Colors.orange[700]!,
                      Icons.security,
                    ),
                    const SizedBox(height: 4),
                    _buildTrustBadge(
                      context,
                      'ISO',
                      Colors.blue[700]!,
                      Icons.workspace_premium,
                    ),
                    const SizedBox(height: 4),
                    _buildTrustBadge(
                      context,
                      'Sequoia',
                      Colors.green[700]!,
                      Icons.verified,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: partner.services
                  .map((s) => _buildServiceBadge(context, s))
                  .toList(),
            ),
            const SizedBox(height: 16),
            _buildActionButton(
              context,
              'View Details',
              isPrimary: true,
              onTap: () => _showPartnerDetails(context, partner),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrustBadge(
    BuildContext context,
    String text,
    Color color,
    IconData icon,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.2 : 0.05),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 10,
            color: isDark ? color.withValues(alpha: 0.9) : color,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: isDark ? color.withValues(alpha: 0.9) : color,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceBadge(BuildContext context, String service) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color color;
    IconData icon;
    String label = StringUtils.capitalizeFirst(service);

    switch (service.toLowerCase()) {
      case 'pickup':
        color = Colors.green;
        icon = Icons.local_shipping;
        label = 'Pickup';
        break;
      case 'jewellery':
        color = Colors.blue;
        icon = Icons.shopping_bag;
        label = 'Jewellery';
        break;
      case 'loan':
        color = Colors.purple;
        icon = Icons.repeat;
        label = 'Loan';
        break;
      default:
        color = Colors.grey;
        icon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: isDark ? color.withValues(alpha: 0.9) : color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: isDark ? color.withValues(alpha: 0.9) : color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showPartnerDetails(BuildContext context, Partner partner) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            partner.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: [
                              _buildTrustBadge(
                                context,
                                'BIS Hallmark',
                                Colors.orange[700]!,
                                Icons.security,
                              ),
                              _buildTrustBadge(
                                context,
                                'ISO 9001',
                                Colors.blue[700]!,
                                Icons.workspace_premium,
                              ),
                              _buildTrustBadge(
                                context,
                                'Sequoia',
                                Colors.green[700]!,
                                Icons.verified,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: theme.colorScheme.onSurface,
                      ),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: theme.dividerColor),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: theme.textTheme.bodySmall?.color,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${partner.area}, ${partner.city}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                partner.distance != null
                                    ? '${partner.distance} km away'
                                    : 'Distance unknown',
                                style: TextStyle(
                                  color: theme.textTheme.bodySmall?.color,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => controller.openInMaps(partner),
                        icon: const Icon(Icons.navigation_outlined, size: 18),
                        label: const Text('Get Directions'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark
                              ? theme.colorScheme.primary.withValues(alpha: 0.1)
                              : const Color(0xFFFDF7DE),
                          foregroundColor: theme.colorScheme.primary,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? theme.colorScheme.primary.withValues(
                                    alpha: 0.1,
                                  )
                                : const Color(0xFFFDF7DE),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: theme.colorScheme.primary,
                                size: 24,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                partner.rating.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: isDark
                                      ? theme.colorScheme.primary
                                      : const Color(0xFF5A4A1A),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${partner.reviews} reviews',
                          style: TextStyle(
                            color: theme.textTheme.bodySmall?.color,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Services Available',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...partner.services.map(
                      (s) => _buildDetailServiceItem(context, s),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoBox(
                            context,
                            Icons.access_time,
                            'Timings',
                            partner.timings ?? '10:00 AM - 07:00 PM',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInfoBox(
                            context,
                            Icons.phone,
                            'Contact',
                            partner.phone ?? 'N/A',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _buildActionButton(
                      context,
                      'Convert Gold to Jewellery Here',
                      isPrimary: true,
                    ),
                    const SizedBox(height: 12),
                    _buildActionButton(context, 'Deposit Physical Gold'),
                    const SizedBox(height: 12),
                    _buildActionButton(context, 'Book Visit'),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildInfoBox(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: theme.textTheme.bodySmall?.color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: theme.textTheme.bodySmall?.color,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailServiceItem(BuildContext context, String service) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color color;
    IconData icon;
    String label;

    switch (service.toLowerCase()) {
      case 'pickup':
        color = Colors.green;
        icon = Icons.local_shipping;
        label = 'Gold Pickup Available';
        break;
      case 'jewellery':
        color = Colors.blue;
        icon = Icons.shopping_bag;
        label = 'Jewellery Conversion';
        break;
      case 'loan':
        color = Colors.purple;
        icon = Icons.repeat;
        label = 'Loan Assistance';
        break;
      default:
        color = Colors.grey;
        icon = Icons.info;
        label = service;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.2 : 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isDark ? color.withValues(alpha: 0.9) : color,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: isDark
                  ? color.withValues(alpha: 0.9)
                  : color.withValues(alpha: 0.9),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String text, {
    bool isPrimary = false,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: isPrimary && !isDark
              ? const RadialGradient(
                  center: Alignment.center,
                  radius: 1.5,
                  colors: [
                    Color(0xFFFDF7DE),
                    Color(0xFFF6E7B8),
                    Color(0xFFEDD28D),
                  ],
                  stops: [0.0, 0.4, 0.8],
                )
              : null,
          color: isPrimary
              ? (isDark ? theme.colorScheme.primary : null)
              : theme.colorScheme.surfaceContainer.withValues(alpha: 0.5),
          border: Border.all(
            color: isPrimary
                ? (isDark
                      ? theme.colorScheme.primary
                      : const Color(0xFFE4CD8E).withValues(alpha: 0.7))
                : theme.dividerColor,
          ),
        ),
        child: ElevatedButton(
          onPressed: onTap ?? () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: isPrimary
                ? (isDark ? Colors.black : AppColors.sipTextGold)
                : theme.textTheme.bodyMedium?.color,
            shadowColor: Colors.transparent,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: isPrimary ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  void _showAddPartnerDialog(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: isDark ? theme.colorScheme.surface : const Color(0xFFFDF8E8),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  24,
                  0,
                  24,
                  24 + MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Form(
                  key: controller.addPartnerFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create Partner Account',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? theme.colorScheme.primary
                              : const Color(0xFF3D3066),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enter business details to register a new partner.',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                      const SizedBox(height: 24),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 600) {
                            return Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _buildModernTextField(
                                        context,
                                        controller: controller.nameController,
                                        label: 'Partner Name *',
                                        hint: 'e.g. Golden Jewellers',
                                        icon: Icons.business,
                                        validator: (v) => v!.isEmpty ? 'Required' : null,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildModernTextField(
                                        context,
                                        controller: controller.emailController,
                                        label: 'Email Address *',
                                        hint: 'e.g. partner@example.com',
                                        icon: Icons.email_outlined,
                                        keyboardType: TextInputType.emailAddress,
                                        validator: (v) => GetUtils.isEmail(v ?? '') ? null : 'Invalid email',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _buildModernTextField(
                                        context,
                                        controller: controller.phoneController,
                                        label: 'Phone Number *',
                                        hint: 'e.g. +91 975431****',
                                        icon: Icons.phone_outlined,
                                        keyboardType: TextInputType.phone,
                                        validator: (v) => (v?.length ?? 0) < 10 ? 'Invalid phone' : null,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildModernTextField(
                                        context,
                                        controller: controller.usernameController,
                                        label: 'Username *',
                                        hint: 'e.g. golden_partner',
                                        icon: Icons.person_outline,
                                        validator: (v) => v!.isEmpty ? 'Required' : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }
                          return Column(
                            children: [
                              _buildModernTextField(
                                context,
                                controller: controller.nameController,
                                label: 'Partner Name *',
                                hint: 'e.g. Golden Jewellers',
                                icon: Icons.business,
                                validator: (v) => v!.isEmpty ? 'Required' : null,
                              ),
                              const SizedBox(height: 16),
                              _buildModernTextField(
                                context,
                                controller: controller.emailController,
                                label: 'Email Address *',
                                hint: 'e.g. partner@example.com',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: (v) => GetUtils.isEmail(v ?? '') ? null : 'Invalid email',
                              ),
                              const SizedBox(height: 16),
                              _buildModernTextField(
                                context,
                                controller: controller.phoneController,
                                label: 'Phone Number *',
                                hint: 'e.g. +91 975431****',
                                icon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                                validator: (v) => (v?.length ?? 0) < 10 ? 'Invalid phone' : null,
                              ),
                              const SizedBox(height: 16),
                              _buildModernTextField(
                                context,
                                controller: controller.usernameController,
                                label: 'Username *',
                                hint: 'e.g. golden_partner',
                                icon: Icons.person_outline,
                                validator: (v) => v!.isEmpty ? 'Required' : null,
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildModernTextField(
                        context,
                        controller: controller.passwordController,
                        label: 'Password *',
                        hint: '••••@12•',
                        icon: Icons.lock_outline,
                        obscureText: true,
                        validator: (v) => (v?.length ?? 0) < 6 ? 'Min 6 chars' : null,
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Get.back(),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: BorderSide(color: theme.dividerColor),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: theme.textTheme.bodySmall?.color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Obx(() => _buildActionButton(
                              context,
                              'Create Partner',
                              isPrimary: true,
                              onTap: controller.isLoading.value ? null : () {
                                if (controller.addPartnerFormKey.currentState?.validate() ?? false) {
                                  controller.registerPartner();
                                }
                              },
                            )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildModernTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            validator: validator,
            style: TextStyle(color: theme.colorScheme.onSurface),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: theme.textTheme.bodySmall?.color),
              prefixIcon: Icon(icon, color: theme.colorScheme.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: isDark
                    ? BorderSide(color: theme.dividerColor)
                    : BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: isDark
                    ? BorderSide(color: theme.dividerColor)
                    : BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: theme.colorScheme.primary),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showCompleteProfileDialog(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  24,
                  0,
                  24,
                  24 + MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Form(
                  key: controller.completeProfileFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Complete Your Profile',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? theme.colorScheme.primary
                              : const Color(0xFF3D3066),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Business Details',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                      const SizedBox(height: 24),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 600) {
                            return Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _buildModernTextField(
                                        context,
                                        controller: controller.nameController,
                                        label: 'Business Name',
                                        hint: 'e.g. Golden Jewellers',
                                        icon: Icons.business,
                                        validator: (v) => v!.isEmpty ? 'Required' : null,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildModernTextField(
                                        context,
                                        controller: controller.ownerNameController,
                                        label: 'Owner Name',
                                        hint: 'Full Name',
                                        icon: Icons.person_outline,
                                        validator: (v) => v!.isEmpty ? 'Required' : null,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _buildModernTextField(
                                        context,
                                        controller: controller.areaController,
                                        label: 'Area',
                                        hint: 'e.g. Civil Lines',
                                        icon: Icons.map_outlined,
                                        validator: (v) => v!.isEmpty ? 'Required' : null,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildModernTextField(
                                        context,
                                        controller: controller.cityController,
                                        label: 'City',
                                        hint: 'e.g. Raipur',
                                        icon: Icons.location_city,
                                        validator: (v) => v!.isEmpty ? 'Required' : null,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _buildModernTextField(
                                        context,
                                        controller: controller.pincodeController,
                                        label: 'Pincode',
                                        hint: '492001',
                                        icon: Icons.pin_drop_outlined,
                                        keyboardType: TextInputType.number,
                                        validator: (v) => (v?.length ?? 0) != 6 ? 'Invalid pincode' : null,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildModernTextField(
                                        context,
                                        controller: controller.timingsController,
                                        label: 'Business Timings',
                                        hint: 'e.g. 10:00 AM - 08:00 PM',
                                        icon: Icons.access_time,
                                        validator: (v) => v!.isEmpty ? 'Required' : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }
                          return Column(
                            children: [
                              _buildModernTextField(
                                context,
                                controller: controller.nameController,
                                label: 'Business Name',
                                hint: 'e.g. Golden Jewellers',
                                icon: Icons.business,
                                validator: (v) => v!.isEmpty ? 'Required' : null,
                              ),
                              const SizedBox(height: 16),
                              _buildModernTextField(
                                context,
                                controller: controller.ownerNameController,
                                label: 'Owner Name',
                                hint: 'Full Name',
                                icon: Icons.person_outline,
                                validator: (v) => v!.isEmpty ? 'Required' : null,
                              ),
                              const SizedBox(height: 16),
                              _buildModernTextField(
                                context,
                                controller: controller.areaController,
                                label: 'Area',
                                hint: 'e.g. Civil Lines',
                                icon: Icons.map_outlined,
                                validator: (v) => v!.isEmpty ? 'Required' : null,
                              ),
                              const SizedBox(height: 16),
                              _buildModernTextField(
                                context,
                                controller: controller.cityController,
                                label: 'City',
                                hint: 'e.g. Raipur',
                                icon: Icons.location_city,
                                validator: (v) => v!.isEmpty ? 'Required' : null,
                              ),
                              const SizedBox(height: 16),
                              _buildModernTextField(
                                context,
                                controller: controller.pincodeController,
                                label: 'Pincode',
                                hint: '492001',
                                icon: Icons.pin_drop_outlined,
                                keyboardType: TextInputType.number,
                                validator: (v) => (v?.length ?? 0) != 6 ? 'Invalid pincode' : null,
                              ),
                              const SizedBox(height: 16),
                              _buildModernTextField(
                                context,
                                controller: controller.timingsController,
                                label: 'Business Timings',
                                hint: 'e.g. 10:00 AM - 08:00 PM',
                                icon: Icons.access_time,
                                validator: (v) => v!.isEmpty ? 'Required' : null,
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildModernTextField(
                        context,
                        controller: controller.addressController,
                        label: 'Full Address',
                        hint: 'Shop No., Building, Street',
                        icon: Icons.home_outlined,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Services Offered',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: isDark
                                ? Border.all(color: theme.dividerColor)
                                : null,
                            boxShadow: isDark
                                ? null
                                : [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                          ),
                          child: DropdownButtonFormField<String>(
                            initialValue: controller.servicesOffers.value,
                            dropdownColor: theme.colorScheme.surface,
                            style: TextStyle(color: theme.colorScheme.onSurface),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            items: ['JEWELLERY', 'PICKUP', 'LOAN']
                                .map(
                                  (s) =>
                                      DropdownMenuItem(value: s, child: Text(s)),
                                )
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                controller.servicesOffers.value = val;
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Get.back(),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: BorderSide(color: theme.dividerColor),
                              ),
                              child: Text(
                                'Later',
                                style: TextStyle(
                                  color: theme.textTheme.bodySmall?.color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Obx(() => ElevatedButton(
                              onPressed: controller.isLoading.value ? null : () {
                                if (controller.completeProfileFormKey.currentState?.validate() ?? false) {
                                  controller.updatePartnerDetails();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDark
                                    ? theme.colorScheme.primary
                                    : const Color(0xFF3D3066),
                                foregroundColor: isDark
                                    ? Colors.black
                                    : Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: controller.isLoading.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : const Text(
                                    'Complete Profile',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                            )),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildSkeletonLoader(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildSkeletonCard(context),
          ),
          childCount: 4,
        ),
      ),
    );
  }

  Widget _buildSkeletonCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark
          ? theme.colorScheme.surfaceContainerHighest
          : Colors.grey[300]!,
      highlightColor: isDark ? theme.colorScheme.surface : Colors.grey[100]!,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 150, height: 18, color: Colors.white),
                    const SizedBox(height: 8),
                    Container(width: 100, height: 12, color: Colors.white),
                    const SizedBox(height: 8),
                    Container(width: 60, height: 10, color: Colors.white),
                  ],
                ),
                Column(
                  children: [
                    Container(width: 40, height: 12, color: Colors.white),
                    const SizedBox(height: 4),
                    Container(width: 40, height: 12, color: Colors.white),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 60,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 60,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _StickyHeaderDelegate({required this.child});

  @override
  double get minExtent => 165;
  @override
  double get maxExtent => 165;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) => false;
}

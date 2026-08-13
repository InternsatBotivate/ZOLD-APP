import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../data/repositories/partner_repository.dart';
import '../../../data/models/partner_models.dart';
import '../../../core/services/auth_service.dart';

class PartnersController extends GetxController {
  final PartnerRepository _partnerRepository;

  // Loading and State
  final isLoading = false.obs;
  final partners = <Partner>[].obs;
  final filteredPartners = <Partner>[].obs;
  final searchQuery = ''.obs;
  final viewMode = 'list'.obs; // list, map
  final partnerOwnProfile = Rxn<Partner>();
  final userRole = ''.obs;
  final hasProfile = true.obs;

  // Map state
  final mapController = MapController();
  final currentPosition = Rxn<Position>();
  final selectedPartner = Rxn<Partner>();
  final mapZoom = 12.0.obs;
  final mapCenter = const LatLng(21.2514, 81.6296).obs; // Default: Raipur
  bool _isMapReady = false;

  // Form Keys
  final addPartnerFormKey = GlobalKey<FormState>();
  final completeProfileFormKey = GlobalKey<FormState>();

  // Registration controllers for Admin
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Profile controllers for Partner
  final ownerNameController = TextEditingController();
  final areaController = TextEditingController();
  final cityController = TextEditingController();
  final addressController = TextEditingController();
  final pincodeController = TextEditingController();
  final timingsController = TextEditingController();
  final servicesOffers = 'PICKUP'.obs; // JEWELLERY, PICKUP, LOAN

  late Worker _searchWorker;

  PartnersController({required PartnerRepository partnerRepository})
    : _partnerRepository = partnerRepository;

  void setMapReady(bool ready) => _isMapReady = ready;

  @override
  void onInit() {
    super.onInit();
    userRole.value = AuthService.to.user.value?.role ?? 'USER';
    fetchPartners();
    _searchWorker = debounce(
      searchQuery,
      (_) => applySearch(),
      time: const Duration(milliseconds: 300),
    );
    _getCurrentLocation();
  }

  @override
  void onClose() {
    _searchWorker.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    ownerNameController.dispose();
    areaController.dispose();
    cityController.dispose();
    addressController.dispose();
    pincodeController.dispose();
    timingsController.dispose();
    super.onClose();
  }

  Future<void> fetchPartners() async {
    isLoading.value = true;
    try {
      if (userRole.value == 'PARTNER') {
        final response = await _partnerRepository.getPartnerDetails();
        partnerOwnProfile.value = response.data;
        hasProfile.value = response.data != null;
      } else {
        final response = await _partnerRepository.getPartners();
        partners.value = response.data ?? [];
        applySearch();
      }
    } catch (e) {
      if (userRole.value == 'PARTNER') {
        hasProfile.value = false;
      } else {
        SnackbarUtils.showError('Failed to fetch partners');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      if (permission == LocationPermission.deniedForever) return;

      final position = await Geolocator.getCurrentPosition();
      currentPosition.value = position;
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  void centerOnCurrentLocation() async {
    await _getCurrentLocation();
    if (currentPosition.value != null && _isMapReady) {
      mapCenter.value = LatLng(
        currentPosition.value!.latitude,
        currentPosition.value!.longitude,
      );
      mapController.move(mapCenter.value, 14.0);
    }
  }

  void selectPartner(Partner partner) {
    selectedPartner.value = partner;
    if (partner.latitude != null && partner.longitude != null && _isMapReady) {
      final lat = double.tryParse(partner.latitude!);
      final lng = double.tryParse(partner.longitude!);
      if (lat != null && lng != null) {
        mapCenter.value = LatLng(lat, lng);
        mapController.move(mapCenter.value, 15.0);
      }
    }
  }

  Future<void> openInMaps(Partner partner) async {
    if (partner.latitude == null || partner.longitude == null) return;
    final url =
        'https://www.google.com/maps/dir/?api=1&destination=${partner.latitude},${partner.longitude}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      SnackbarUtils.showError('Could not open maps');
    }
  }

  void applySearch() {
    if (searchQuery.value.isEmpty) {
      filteredPartners.value = partners;
    } else {
      final query = searchQuery.value.toLowerCase();
      filteredPartners.value = partners.where((p) {
        return p.name.toLowerCase().contains(query) ||
            p.city.toLowerCase().contains(query) ||
            p.area.toLowerCase().contains(query);
      }).toList();
    }

    // Update map center to first result if available
    if (filteredPartners.isNotEmpty && viewMode.value == 'map' && _isMapReady) {
      final p = filteredPartners.first;
      if (p.latitude != null && p.longitude != null) {
        final lat = double.tryParse(p.latitude!);
        final lng = double.tryParse(p.longitude!);
        if (lat != null && lng != null) {
          mapController.move(LatLng(lat, lng), mapZoom.value);
        }
      }
    }
  }

  Future<void> registerPartner() async {
    try {
      isLoading.value = true;
      await _partnerRepository.registerPartner({
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'username': usernameController.text,
        'password': passwordController.text,
      });
      Get.back();
      SnackbarUtils.showSuccess('Partner registered successfully');
      fetchPartners();

      // Clear controllers
      nameController.clear();
      emailController.clear();
      phoneController.clear();
      usernameController.clear();
      passwordController.clear();
    } catch (e) {
      SnackbarUtils.showError('Failed to register partner');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePartnerDetails() async {
    try {
      isLoading.value = true;
      await _partnerRepository.updatePartnerDetails({
        'businessName': nameController.text,
        'ownerName': ownerNameController.text,
        'servicesOffers': servicesOffers.value,
        'area': areaController.text,
        'city': cityController.text,
        'fullAddress': addressController.text,
        'pincode': pincodeController.text,
        'timings': timingsController.text,
        'latitude': "21.2514",
        'longitude': "81.6296",
      });
      Get.back();
      SnackbarUtils.showSuccess('Profile updated successfully');
      fetchPartners();
    } catch (e) {
      SnackbarUtils.showError('Failed to update profile');
    } finally {
      isLoading.value = false;
    }
  }
}

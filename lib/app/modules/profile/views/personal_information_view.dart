import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/profile_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/auth_service.dart';

class PersonalInformationView extends GetView<ProfileController> {
  const PersonalInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
          onPressed: () => Get.back(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
            Text(
              'Manage your personal details',
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
        actions: [
          Obx(() {
            if (controller.isEditing.value) {
              return Row(
                children: [
                  IconButton(
                    onPressed: controller.cancelEditing,
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red.withAlpha(204),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.updateProfile,
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: controller.isLoading.value
                            ? Colors.grey
                            : Colors.green.withAlpha(204),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Icon(
                              Icons.save,
                              color: Colors.white,
                              size: 20,
                            ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: TextButton.icon(
                  onPressed: controller.startEditing,
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Edit'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF4A3966),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              );
            }
          }),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          final user = AuthService.to.user.value;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _buildProfilePicture(context, user?.profilePictureUrl),
                const SizedBox(height: 32),
                _buildInfoSection(
                  context,
                  icon: Icons.person_outline,
                  label: 'Full Name',
                  value: user?.name ?? 'Not provided',
                  editingController: controller.nameController,
                  isEditing: controller.isEditing.value,
                ),
                const SizedBox(height: 24),
                _buildInfoSection(
                  context,
                  icon: Icons.mail_outline,
                  label: 'Email Address',
                  value: user?.email ?? 'Not provided',
                  editingController: controller.emailController,
                  isEditing: controller.isEditing.value,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24),
                _buildInfoSection(
                  context,
                  icon: Icons.phone_outlined,
                  label: 'Phone Number',
                  value: user?.phone ?? 'Not provided',
                  editingController: controller.phoneController,
                  isEditing: controller.isEditing.value,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 24),
                _buildInfoSection(
                  context,
                  icon: Icons.calendar_today_outlined,
                  label: 'Date of Birth',
                  value: (user?.dob == null || user!.dob!.isEmpty)
                      ? 'Not provided'
                      : user.dob!,
                  editingController: controller.dobController,
                  isEditing: controller.isEditing.value,
                  hint: 'dd-mm-yyyy',
                  suffixIcon: Icons.calendar_today_outlined,
                  onTap: () => _selectDate(context),
                  readOnly: true,
                ),
                const SizedBox(height: 24),
                _buildAddressSection(context),
                const SizedBox(height: 32),
                _buildInfoBanner(context),
                const SizedBox(height: 40),
              ],
            ),
          );
        }),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    if (!controller.isEditing.value) return;
    DateTime initialDate = DateTime.now();
    if (controller.dobController.text.isNotEmpty) {
      try {
        initialDate = DateFormat(
          'dd-MM-yyyy',
        ).parse(controller.dobController.text);
      } catch (e) {
        debugPrint('Error parsing DOB: $e');
      }
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4A3966),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.dobController.text = DateFormat('dd-MM-yyyy').format(picked);
    }
  }

  Widget _buildProfilePicture(BuildContext context, String? avatarUrl) {
    return Column(
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: () {
                if (avatarUrl != null) {
                  _showImagePreviewDialog(context, avatarUrl);
                } else if (controller.isEditing.value) {
                  _showImagePickerOptions(context);
                }
              },
              child: Hero(
                tag: 'profile_image_personal',
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.deepPurple.withAlpha(77),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[200],
                      child: avatarUrl != null
                          ? CachedNetworkImage(
                              imageUrl: avatarUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            )
                          : const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey,
                            ),
                    ),
                  ),
                ),
              ),
            ),
            if (controller.isLoading.value)
              const Positioned.fill(
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primaryGold,
                  ),
                ),
              ),
            if (controller.isEditing.value && !controller.isLoading.value)
              Positioned(
                bottom: 5,
                right: 5,
                child: GestureDetector(
                  onTap: () => _showImagePickerOptions(context),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF4A3966),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          controller.isLoading.value
              ? 'Uploading...'
              : controller.isEditing.value
              ? 'Tap the camera icon to change photo'
              : 'Profile picture',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildInfoSection(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required TextEditingController editingController,
    required bool isEditing,
    String? hint,
    TextInputType? keyboardType,
    IconData? suffixIcon,
    VoidCallback? onTap,
    bool readOnly = false,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (isEditing)
          TextField(
            controller: editingController,
            keyboardType: keyboardType,
            onTap: onTap,
            readOnly: readOnly,
            style: TextStyle(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
            decoration: InputDecoration(
              hintText: hint ?? 'Enter $label',
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              filled: true,
              fillColor: isDark ? AppColors.bgDarkSecondary : Colors.grey[50],
              suffixIcon: suffixIcon != null
                  ? Icon(suffixIcon, size: 20, color: Colors.black87)
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF4A3966),
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Text(
              value.isEmpty ? 'Not provided' : value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAddressSection(BuildContext context) {
    final isEditing = controller.isEditing.value;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (!isEditing) {
      final user = AuthService.to.user.value;
      List<String> addressParts = [];
      if (user?.address != null && user!.address!.isNotEmpty) {
        addressParts.add(user.address!);
      }
      if (user?.city != null && user!.city!.isNotEmpty) {
        addressParts.add(user.city!);
      }
      if (user?.state != null && user!.state!.isNotEmpty) {
        addressParts.add(user.state!);
      }
      if (user?.pincode != null && user!.pincode!.isNotEmpty) {
        addressParts.add(user.pincode!);
      }
      return _buildInfoSection(
        context,
        icon: Icons.location_on_outlined,
        label: 'Address',
        value: addressParts.isEmpty ? 'Not provided' : addressParts.join(', '),
        editingController: controller.addressController,
        isEditing: false,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 20,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
            const SizedBox(width: 8),
            Text(
              'Address',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller.addressController,
          decoration: _buildInputDecoration(isDark, 'Street address'),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.cityController,
                decoration: _buildInputDecoration(isDark, 'City'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: controller.stateController,
                decoration: _buildInputDecoration(isDark, 'State'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller.pincodeController,
          keyboardType: TextInputType.number,
          decoration: _buildInputDecoration(isDark, 'Pincode'),
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration(bool isDark, String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      filled: true,
      fillColor: isDark ? AppColors.bgDarkSecondary : Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF4A3966), width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _buildInfoBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F1FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: Color(0xFF1E56A0), size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'All changes will be saved automatically. Make sure your information is accurate and up-to-date.',
              style: TextStyle(
                color: Color(0xFF1E56A0),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePickerOptions(BuildContext context) {
    final isDark = Get.isDarkMode;
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.bgDarkSecondary : AppColors.surfaceLight,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Profile Photo',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPickerOption(
                  context,
                  Icons.camera_alt_outlined,
                  'Camera',
                  () {
                    Get.back();
                    controller.uploadProfilePicture(ImageSource.camera);
                  },
                ),
                _buildPickerOption(
                  context,
                  Icons.photo_library_outlined,
                  'Gallery',
                  () {
                    Get.back();
                    controller.uploadProfilePicture(ImageSource.gallery);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPickerOption(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    final isDark = Get.isDarkMode;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withAlpha(13)
                  : Colors.black.withAlpha(13),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primaryGold, size: 32),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _showImagePreviewDialog(BuildContext context, String imageUrl) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Get.to(
      () => Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'Profile photo',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 18,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: isDark ? Colors.white : Colors.black,
              ),
              onPressed: () => _showImagePickerOptions(context),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Expanded(
              flex: 3,
              child: Hero(
                tag: 'profile_image_personal',
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryGold,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.error,
                      color: isDark ? Colors.white : Colors.black,
                      size: 50,
                    ),
                  ),
                ),
              ),
            ),
            const Expanded(flex: 1, child: SizedBox()),
          ],
        ),
      ),
      transition: Transition.fadeIn,
      fullscreenDialog: true,
    );
  }
}

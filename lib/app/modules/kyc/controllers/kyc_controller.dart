import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../core/services/auth_service.dart';
import '../../../data/models/auth_models.dart';
import 'package:image_picker/image_picker.dart';

class KYCController extends GetxController {
  final step = 'intro'.obs;

  final panNumber = ''.obs;
  final panName = ''.obs;
  final panFileName = ''.obs;

  final aadhaarNumber = ''.obs;
  final aadhaarFileName = ''.obs;

  final totalSteps = 2;

  @override
  void onInit() {
    super.onInit();
    _checkInitialStatus();
  }

  void _checkInitialStatus() {
    final user = AuthService.to.user.value;
    if (user?.kyc != null) {
      if (user!.kyc!.status == KycStatus.approved) {
        Get.offAllNamed(Routes.home);
      } else if (user.kyc!.status == KycStatus.pending) {
        step.value = 'complete';
      }
    }
  }

  int get currentStepNumber {
    if (step.value == 'pan') return 1;
    if (step.value == 'aadhaar') return 2;
    return 0;
  }

  Future<void> pickDocument(RxString fileName) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      fileName.value = image.name;
    }
  }

  void startKYC() => step.value = 'pan';

  void goToAadhaar() => step.value = 'aadhaar';

  Future<void> submitKYC() async {
    // Parity with Next.js/Backend:
    // Currently, backend does not have a public submission API.
    // In Next.js it is simulated. We reflect the pending state.
    step.value = 'complete';
  }

  Future<void> completeKYC() async {
    await AuthService.to.setKycStatus(KycStatus.approved);
    Get.offAllNamed(Routes.home);
  }

  Future<void> skipKYC() async {
    await AuthService.to.setKycStatus(KycStatus.approved);
    Get.offAllNamed(Routes.home);
  }

  bool get isPanValid =>
      panNumber.value.length == 10 &&
      panName.value.isNotEmpty &&
      panFileName.value.isNotEmpty;
  bool get isAadhaarValid =>
      aadhaarNumber.value.length == 12 && aadhaarFileName.value.isNotEmpty;
}

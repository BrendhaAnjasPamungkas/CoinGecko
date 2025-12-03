import 'package:blockchain/app/domain/entities/user.dart';
import 'package:blockchain/app/domain/repositories/auth_repository.dart';
import 'package:blockchain/app/presentation/controllers/wallet_controller.dart';
import 'package:blockchain/app/presentation/views/home_view.dart';
import 'package:blockchain/app/presentation/views/login_view.dart';
import 'package:get/get.dart';
import 'package:blockchain/injection.dart' as sl;

class AuthController extends GetxController {
  final AuthRepository _authRepository = sl.sl<AuthRepository>();

  var user = Rxn<UserEntity>();

  // Fungsi login
  Future<void> login(String email, String password) async {
    try {
      user.value = await _authRepository.login(email, password);
      Get.offAll(HomeView()); // Redirect ke Home page setelah login berhasil
    } catch (e) {
      Get.snackbar(
        'Login Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Fungsi register
  Future<void> register(String email, String password, String name) async {
    try {
      user.value = await _authRepository.register(
        email,
        password,
      ); // Registrasi berhasil
      Get.offAll(
        LoginView(),
      ); // Redirect ke Home page setelah registrasi berhasil
    } catch (e) {
      Get.snackbar(
        'Registration Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Fungsi logout
  Future<void> logout() async {
    await _authRepository.logout();
    Get.delete<WalletController>(force: true);
    user.value = null;
    Get.offAll(LoginView()); // Redirect ke Login page setelah logout
  }
}

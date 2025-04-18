import 'package:get/get.dart';

import '../modules/createprofile/bindings/createprofile_binding.dart';
import '../modules/createprofile/views/createprofile_view.dart';
import '../modules/gantipassword/bindings/gantipassword_binding.dart';
import '../modules/gantipassword/views/gantipassword_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/isilogbook/bindings/isilogbook_binding.dart';
import '../modules/isilogbook/views/isilogbook_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/lupapassword/bindings/lupapassword_binding.dart';
import '../modules/lupapassword/views/lupapassword_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/otp/bindings/otp_binding.dart';
import '../modules/otp/views/otp_view.dart';
import '../modules/pendaftaranplp/bindings/pendaftaranplp_binding.dart';
import '../modules/pendaftaranplp/views/pendaftaranplp_view.dart';
import '../modules/selengkapnya/bindings/selengkapnya_binding.dart';
import '../modules/selengkapnya/views/selengkapnya_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ONBOARDING;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.CREATEPROFILE,
      page: () => const CreateprofileView(),
      binding: CreateprofileBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.LUPAPASSWORD,
      page: () => const LupapasswordView(),
      binding: LupapasswordBinding(),
    ),
    GetPage(
      name: _Paths.OTP,
      page: () => const OtpView(),
      binding: OtpBinding(),
    ),
    GetPage(
      name: _Paths.GANTIPASSWORD,
      page: () => const GantipasswordView(),
      binding: GantipasswordBinding(),
    ),
    GetPage(
      name: _Paths.SELENGKAPNYA,
      page: () => const SelengkapnyaView(),
      binding: SelengkapnyaBinding(),
    ),
    GetPage(
      name: _Paths.ISILOGBOOK,
      page: () => const IsilogbookView(),
      binding: IsilogbookBinding(),
    ),
    GetPage(
      name: _Paths.PENDAFTARANPLP,
      page: () => const PendaftaranplpView(),
      binding: PendaftaranplpBinding(),
    ),
  ];
}

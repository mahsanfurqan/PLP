import 'package:get/get.dart';

import '../modules/createprofile/bindings/createprofile_binding.dart';
import '../modules/createprofile/views/createprofile_view.dart';
import '../modules/formlogbook/bindings/formlogbook_binding.dart';
import '../modules/formlogbook/views/formlogbook_view.dart';
import '../modules/gantipassword/bindings/gantipassword_binding.dart';
import '../modules/gantipassword/views/gantipassword_view.dart';
import '../modules/gurupamong/bindings/gurupamong_binding.dart';
import '../modules/gurupamong/views/gurupamong_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/isilogbook/bindings/isilogbook_binding.dart';
import '../modules/isilogbook/views/isilogbook_view.dart';
import '../modules/keminatan/bindings/keminatan_binding.dart';
import '../modules/keminatan/views/keminatan_view.dart';
import '../modules/lihatdataplp/bindings/lihatdataplp_binding.dart';
import '../modules/lihatdataplp/views/lihatdataplp_view.dart';
import '../modules/lihatdataplpall/bindings/lihatdataplpall_binding.dart';
import '../modules/lihatdataplpall/views/lihatdataplpall_view.dart';
import '../modules/lihatlogbookall/bindings/lihatlogbookall_binding.dart';
import '../modules/lihatlogbookall/views/lihatlogbookall_view.dart';
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
import '../modules/smk/bindings/smk_binding.dart';
import '../modules/smk/views/smk_view.dart';
import '../modules/validasilogbook/bindings/validasilogbook_binding.dart';
import '../modules/validasilogbook/views/validasilogbook_view.dart';

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
    GetPage(
      name: _Paths.LIHATDATAPLP,
      page: () => const LihatdataplpView(),
      binding: LihatdataplpBinding(),
    ),
    GetPage(
      name: _Paths.FORMLOGBOOK,
      page: () => const FormlogbookView(),
      binding: FormlogbookBinding(),
    ),
    GetPage(
      name: _Paths.LIHATDATAPLPALL,
      page: () => const LihatdataplpallView(),
      binding: LihatdataplpallBinding(),
    ),
    GetPage(
      name: _Paths.LIHATLOGBOOKALL,
      page: () => const LihatlogbookallView(),
      binding: LihatlogbookallBinding(),
    ),
    GetPage(
      name: _Paths.SMK,
      page: () => const SmkView(),
      binding: SmkBinding(),
    ),
    GetPage(
      name: _Paths.GURUPAMONG,
      page: () => const GurupamongView(),
      binding: GurupamongBinding(),
    ),
    GetPage(
      name: _Paths.KEMINATAN,
      page: () => const KeminatanView(),
      binding: KeminatanBinding(),
    ),
    GetPage(
      name: _Paths.VALIDASILOGBOOK,
      page: () => const ValidasilogbookView(),
      binding: ValidasilogbookBinding(),
    ),
  ];
}

import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:plp/models/pendaftaranplp_model.dart';
import 'package:plp/models/smk_model.dart';
import 'package:plp/service/keminatan_service.dart';
import 'package:plp/service/pendaftaran_plp_service.dart';
import 'package:plp/service/smk_service.dart';

class LihatdataplpController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  final nama = ''.obs;
  final nim = ''.obs;
  final angkatan = ''.obs;
  var dataPendaftaran = <PendaftaranPlpModel>[].obs;
  var daftarKeminatan = <Map<String, dynamic>>[].obs;
  var daftarSmk = <SmkModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserInfo();
    fetchAllData();
  }

  void fetchUserInfo() {
    final user = GetStorage().read('user');
    if (user != null) {
      nama.value = user['name'] ?? '-';
      nim.value = user['nim'] ?? '-';
      angkatan.value = user['angkatan'] ?? '-';
      print(
        "User Info - Nama: ${nama.value}, NIM: ${nim.value}, Angkatan: ${angkatan.value}",
      );
    }
  }

  Future<void> fetchAllData() async {
    isLoading.value = true;
    errorMessage.value = '';
    print("Fetching all data...");

    try {
      final responses = await Future.wait([
        PendaftaranPlpService.getPendaftaranPlpData(),
        KeminatanService.getKeminatan(),
        SmkService.getSmks(),
      ]);

      print("Data Pendaftaran: ${responses[0]}");
      print("Data Keminatan: ${responses[1]}");
      print("Data SMK: ${responses[2]}");

      // Periksa data PendaftaranPlp
      List<PendaftaranPlpModel> pendaftaranData =
          responses[0] as List<PendaftaranPlpModel>;
      if (pendaftaranData.isNotEmpty) {
        print("Data Pendaftaran: ${pendaftaranData[0]}"); // Debug output
        dataPendaftaran.assignAll(pendaftaranData);
      }

      // Periksa data Keminatan
      List<Map<String, dynamic>> keminatanData =
          responses[1] as List<Map<String, dynamic>>;
      if (keminatanData.isNotEmpty) {
        print("Data Keminatan: $keminatanData");
        daftarKeminatan.assignAll(keminatanData);
      }

      // Periksa data SMK
      List<SmkModel> smkData = responses[2] as List<SmkModel>;
      if (smkData.isNotEmpty) {
        print("Data SMK: $smkData");
        daftarSmk.assignAll(smkData);
      }

      // Print status final
      print("Data Pendaftaran setelah assign: $dataPendaftaran");
      print("Data Keminatan setelah assign: $daftarKeminatan");
      print("Data SMK setelah assign: $daftarSmk");
    } catch (e) {
      errorMessage.value = 'Gagal memuat data: $e';
      print("Error while fetching data: $e");
    } finally {
      isLoading.value = false;
      print("Fetching data completed.");
    }
  }

  String getNamaKeminatan(int? id) {
    try {
      final keminatan = daftarKeminatan.firstWhere(
        (e) => e['id'] == id,
        orElse: () => {},
      );
      return keminatan.isNotEmpty ? keminatan['name'] ?? '-' : '-';
    } catch (e) {
      print("Error getting nama keminatan: $e");
      return '-';
    }
  }

  String getNamaSmk(int? id) {
    try {
      final smk = daftarSmk.firstWhere(
        (e) => e.id == id,
        orElse: () => SmkModel(id: 0, nama: '-'),
      );
      return smk.nama ?? '-';
    } catch (e) {
      print("Error getting nama smk: $e");
      return '-';
    }
  }
}

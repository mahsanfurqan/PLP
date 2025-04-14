import 'package:get/get.dart';

class IsilogbookController extends GetxController {
  var logbookList = <Map<String, dynamic>>[].obs;

  var isStartButtonPressed = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLogbookData();
  }

  void goToTambahLogbook() {
    // Navigasi ke halaman tambah logbook
    // Contoh: Get.toNamed('/tambah-logbook');
    print("Navigasi ke halaman tambah logbook");
  }

  Future<void> fetchLogbookData() async {
    logbookList.value = [
      {
        'id': '001',
        'durasi': '8 jam',
        'uraian': 'Forem ipsum dolor sit amet forem ipsum dolor sit amet..',
        'tanggal': '13 - 12 - 2024',
      },
      {
        'id': '002',
        'durasi': '8 jam',
        'uraian': 'Forem ipsum dolor sit amet forem ipsum dolor sit amet..',
        'tanggal': '14 - 12 - 2024',
      },
      {
        'id': '003',
        'durasi': '7 jam',
        'uraian': 'Dolor sit amet consectetuer adipiscing elit..',
        'tanggal': '15 - 12 - 2024',
      },
      {
        'id': '004',
        'durasi': '6 jam',
        'uraian': 'Sed diam nonummy nibh euismod tincidunt ut laoreet dolore..',
        'tanggal': '16 - 12 - 2024',
      },
      {
        'id': '005',
        'durasi': '8 jam',
        'uraian': 'Ut wisi enim ad minim veniam quis nostrud exerci tation..',
        'tanggal': '17 - 12 - 2024',
      },
    ];
  }
}

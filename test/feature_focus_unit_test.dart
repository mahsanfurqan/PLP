import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:plp/app/modules/createprofile/controllers/createprofile_controller.dart';
import 'package:plp/app/modules/formlogbook/controllers/formlogbook_controller.dart';
import 'package:plp/app/modules/isilogbook/controllers/isilogbook_controller.dart';
import 'package:plp/app/modules/laporananonim/controllers/laporananonim_controller.dart';
import 'package:plp/app/modules/lihatlogbookall/controllers/lihatlogbookall_controller.dart';
import 'package:plp/app/modules/login/controllers/login_controller.dart';
import 'package:plp/app/modules/validasilogbook/controllers/validasilogbook_controller.dart';
import 'package:plp/models/logbook_group_model.dart';
import 'package:plp/models/logbook_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    const pathProviderChannel = MethodChannel(
      'plugins.flutter.io/path_provider',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, (methodCall) async {
          if (methodCall.method == 'getApplicationDocumentsDirectory') {
            final directory = Directory.systemTemp.createTempSync('plp_test');
            return directory.path;
          }
          return null;
        });
    await GetStorage.init();
    Get.testMode = true;
  });

  group('Login feature', () {
    test('validates ub.ac.id email correctly', () {
      final controller = LoginController();

      expect(controller.isUbEmail('mahasiswa@ub.ac.id'), isTrue);
      expect(controller.isUbEmail('mahasiswa@notub.ac.id'), isFalse);
      expect(controller.isUbEmail('mahasiswa@gmail.com'), isFalse);
    });

    test('rejects empty login input', () {
      final controller = LoginController();

      final result = controller.validateLoginInput(email: '', password: '');

      expect(result, 'Email dan password wajib diisi!');
    });

    test('rejects non ub email on login', () {
      final controller = LoginController();

      final result = controller.validateLoginInput(
        email: 'mahasiswa@gmail.com',
        password: '123456',
      );

      expect(result, 'Hanya email dengan domain .ub.ac.id yang diperbolehkan!');
    });

    test('accepts valid login input', () {
      final controller = LoginController();

      final result = controller.validateLoginInput(
        email: 'mahasiswa@ub.ac.id',
        password: '123456',
      );

      expect(result, isNull);
    });
  });

  group('Register feature', () {
    test('validates ub.ac.id email correctly', () {
      final controller = CreateprofileController();

      expect(controller.isUbEmail('ahsan@ub.ac.id'), isTrue);
      expect(controller.isUbEmail('ahsan@sub.ac.id'), isFalse);
    });

    test('rejects empty register input', () {
      final controller = CreateprofileController();

      final result = controller.validateRegistrationInput(
        name: '',
        email: '',
        password: '',
        confirmPassword: '',
      );

      expect(result, 'Semua field harus diisi!');
    });

    test('rejects non ub email on register', () {
      final controller = CreateprofileController();

      final result = controller.validateRegistrationInput(
        name: 'Ahsan',
        email: 'ahsan@gmail.com',
        password: '123456',
        confirmPassword: '123456',
      );

      expect(result, 'Hanya email dengan domain ub.ac.id yang diperbolehkan!');
    });

    test('rejects mismatched password confirmation', () {
      final controller = CreateprofileController();

      final result = controller.validateRegistrationInput(
        name: 'Ahsan',
        email: 'ahsan@ub.ac.id',
        password: '123456',
        confirmPassword: '654321',
      );

      expect(result, 'Password dan konfirmasi tidak cocok!');
    });

    test('accepts valid register input', () {
      final controller = CreateprofileController();

      final result = controller.validateRegistrationInput(
        name: 'Ahsan',
        email: 'ahsan@ub.ac.id',
        password: '123456',
        confirmPassword: '123456',
      );

      expect(result, isNull);
    });
  });

  group('Logbook mahasiswa feature', () {
    test('converts date into ISO format', () {
      final controller = FormlogbookController();

      expect(controller.convertTanggalToIso('19/05/2026'), '2026-05-19');
    });

    test('formats time for backend correctly', () {
      final controller = FormlogbookController();

      expect(controller.formatJam('07:05'), '07:05:00');
    });

    test('formats date for field display correctly', () {
      final controller = FormlogbookController();

      expect(controller.formatTanggalForField('2026-05-19'), '19/05/2026');
    });

    test('calculates duration with minutes correctly', () {
      final controller = IsilogbookController();

      expect(controller.calculateDuration('07:00', '10:30'), '3 jam 30 menit');
    });

    test('filters logbook list by content and revision note', () {
      final controller = IsilogbookController();
      controller.logbookList.assignAll([
        _sampleLogbook(
          id: 1,
          keterangan: 'Observasi kelas X',
          note: 'Perbaiki deskripsi kegiatan',
          status: 'rejected',
        ),
        _sampleLogbook(
          id: 2,
          keterangan: 'Membantu guru membuat media pembelajaran',
          note: '',
          status: 'approved',
        ),
      ]);

      controller.searchQuery.value = 'perbaiki';

      expect(controller.filteredLogbookList.map((e) => e.id), [1]);
    });

    test('builds editable logbook when approval is rejected', () {
      final logbook = LogbookModel.fromJson({
        'id': 1,
        'user_id': 10,
        'tanggal': '2026-05-19',
        'keterangan': 'Observasi kelas',
        'mulai': '07:00:00',
        'selesai': '09:00:00',
        'dokumentasi': 'https://example.com/logbook.jpg',
        'status': 'rejected',
        'approvers': [
          {
            'id': 1,
            'approver_id': 2,
            'name': 'Dosen Pembimbing',
            'role': 'Dosen Pembimbing',
            'status': 'rejected',
            'note': 'Tambahkan detail kegiatan',
            'updated_at': '2026-05-19 10:00:00',
          },
        ],
      });

      expect(logbook.canEdit, isTrue);
      expect(logbook.rejectedApproval?.note, 'Tambahkan detail kegiatan');
      expect(logbook.mulai, '07:00');
      expect(logbook.selesai, '09:00');
    });
  });

  group('Validasi logbook feature', () {
    test('counts only pending approvals for current approver', () {
      final controller = ValidasilogbookController();
      controller.logbooks.assignAll([
        _sampleLogbook(id: 1, yourApprovalStatus: 'pending'),
        _sampleLogbook(id: 2, yourApprovalStatus: 'approved'),
        _sampleLogbook(id: 3, yourApprovalStatus: 'pending'),
      ]);

      expect(controller.pendingCount, 2);
    });

    test('filters validation logbooks by student name and note', () {
      final controller = ValidasilogbookController();
      controller.logbooks.assignAll([
        _sampleLogbook(
          id: 1,
          userName: 'Mahasiswa A',
          keterangan: 'Mengajar kelas VII',
          yourNote: 'Lengkapi dokumentasi',
        ),
        _sampleLogbook(
          id: 2,
          userName: 'Mahasiswa B',
          keterangan: 'Membuat administrasi kelas',
          yourNote: '',
        ),
      ]);

      controller.searchQuery.value = 'dokumentasi';

      expect(controller.filteredLogbooks.map((e) => e.id), [1]);
    });
  });

  group('Pelaporan feature', () {
    test('formats report date for display correctly', () {
      final controller = LaporananonimController();

      expect(controller.formatTanggal(DateTime(2026, 5, 19)), '19/05/2026');
    });

    test('converts report date into ISO format', () {
      final controller = LaporananonimController();

      expect(controller.convertTanggalToIso('19/05/2026'), '2026-05-19');
    });
  });

  group('Monitoring logbook semua mahasiswa feature', () {
    test('filters groups by supervisor and student name', () {
      final controller = LihatlogbookallController();
      controller.groups.assignAll([
        _sampleGroup(
          id: 1,
          name: 'Kelompok 1',
          dosenName: 'Dosen Pembimbing 1',
          guruName: 'Guru Pamong 1',
          studentNames: ['Mahasiswa A', 'Mahasiswa B'],
          logbooks: [_sampleLogbook(id: 1, userName: 'Mahasiswa A')],
        ),
        _sampleGroup(
          id: 2,
          name: 'Kelompok 2',
          dosenName: 'Dosen Pembimbing 2',
          guruName: 'Guru Pamong 2',
          studentNames: ['Mahasiswa C'],
          logbooks: [_sampleLogbook(id: 2, userName: 'Mahasiswa C')],
        ),
      ]);

      controller.searchQuery.value = 'Mahasiswa C';

      expect(controller.filteredGroups.map((e) => e.id), [2]);
    });

    test('filters selected group logbooks by activity text', () {
      final controller = LihatlogbookallController();
      final group = _sampleGroup(
        id: 1,
        name: 'Kelompok 1',
        dosenName: 'Dosen Pembimbing 1',
        guruName: 'Guru Pamong 1',
        studentNames: ['Mahasiswa A', 'Mahasiswa B'],
        logbooks: [
          _sampleLogbook(
            id: 1,
            userName: 'Mahasiswa A',
            keterangan: 'Mengajar materi pecahan',
          ),
          _sampleLogbook(
            id: 2,
            userName: 'Mahasiswa B',
            keterangan: 'Menyusun perangkat ajar',
          ),
        ],
      );

      controller.openGroup(group);
      controller.searchQuery.value = 'pecahan';

      expect(controller.filteredSelectedGroupLogbooks.map((e) => e.id), [1]);
    });
  });
}

LogbookModel _sampleLogbook({
  required int id,
  String userName = 'Mahasiswa',
  String keterangan = 'Kegiatan logbook',
  String tanggal = '2026-05-19',
  String mulai = '07:00',
  String selesai = '10:00',
  String dokumentasi = 'https://example.com/logbook.jpg',
  String status = 'pending',
  String yourApprovalStatus = 'pending',
  String yourNote = '',
  String note = '',
}) {
  return LogbookModel(
    id: id,
    userId: 1,
    tanggal: tanggal,
    keterangan: keterangan,
    mulai: mulai,
    selesai: selesai,
    dokumentasi: dokumentasi,
    status: status,
    yourApprovalStatus: yourApprovalStatus,
    yourNote: yourNote,
    canEdit: status == 'rejected',
    userName: userName,
    approvers: [
      LogbookApprovalModel(
        id: 1,
        approverId: 2,
        name: 'Dosen Pembimbing',
        role: 'Dosen Pembimbing',
        status: status,
        note: note,
        updatedAt: '2026-05-19 10:00:00',
      ),
    ],
  );
}

LogbookGroupModel _sampleGroup({
  required int id,
  required String name,
  required String dosenName,
  required String guruName,
  required List<String> studentNames,
  required List<LogbookModel> logbooks,
}) {
  return LogbookGroupModel(
    id: id,
    name: name,
    dosenPembimbing: LogbookGroupSupervisorModel(id: 1, name: dosenName),
    guruPamong: LogbookGroupSupervisorModel(id: 2, name: guruName),
    studentCount: studentNames.length,
    logbookCount: logbooks.length,
    students: [
      for (var i = 0; i < studentNames.length; i++)
        LogbookGroupStudentModel(id: i + 1, name: studentNames[i]),
    ],
    logbooks: logbooks,
  );
}

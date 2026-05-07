class AppConfig {
  // true = backend lokal emulator Android, false = backend server
  static const bool useLocalBackend = true;

  // Untuk Android Emulator gunakan 10.0.2.2 ke host Windows
  static const String localBaseUrl = "http://10.0.2.2:8000/api";
  static const String productionBaseUrl = "http://plp.divisigurutugasduba.com/api";
  static const String baseUrl =
      useLocalBackend ? localBaseUrl : productionBaseUrl;

  // Timeout untuk request (dalam detik)
  static const int requestTimeout = 30;

  // API Endpoints
  static const String loginEndpoint = "$baseUrl/login";
  static const String registerEndpoint = "$baseUrl/register";
  static const String forgotPasswordEndpoint = "$baseUrl/forgot-password";
  static const String logbooksEndpoint = "$baseUrl/logbooks";
  static const String pendaftaranPlpEndpoint = "$baseUrl/pendaftaran-plp";
  static const String smkEndpoint = "$baseUrl/smks";
  static const String keminatanEndpoint = "$baseUrl/keminatan";
  static const String akunEndpoint = "$baseUrl/akun";
  static const String laporanAnonimEndpoint = "$baseUrl/laporan-anonim";
}

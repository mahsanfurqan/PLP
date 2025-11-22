class AppConfig {
  // Base URL untuk API
  static const String baseUrl = "http://plp.divisigurutugasduba.com/api";

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
}

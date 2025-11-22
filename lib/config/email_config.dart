class EmailConfig {
  // Mailtrap SMTP Configuration
  static const String mailHost = 'live.smtp.mailtrap.io';
  static const int mailPort = 587;
  static const String mailUsername = 'smtp@mailtrap.io';
  static const String mailPassword = '8257c0afaee3d2cf649833256a950d3c';
  static const String mailFromAddress = 'no-reply@demomailtrap.co';
  static const String mailFromName = 'PLP App';

  // Email Templates
  static String getPasswordResetEmail(String name, String otp) {
    return '''
    <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
      <h2>Reset Password</h2>
      <p>Halo $name,</p>
      <p>Kami menerima permintaan untuk mereset password akun Anda. Gunakan kode OTP berikut untuk melanjutkan:</p>
      
      <div style="background-color: #f5f5f5; padding: 15px; text-align: center; margin: 20px 0;">
        <h1 style="margin: 0; font-size: 32px; letter-spacing: 5px;">$otp</h1>
      </div>
      
      <p>Kode ini akan kedaluwarsa dalam 10 menit.</p>
      <p>Jika Anda tidak meminta reset password, abaikan email ini.</p>
      
      <p>Salam,<br>Tim PLP</p>
      
      <hr>
      <p style="font-size: 12px; color: #777;">
        Email ini dikirim secara otomatis, mohon tidak membalas email ini.
      </p>
    </div>
    ''';
  }
}

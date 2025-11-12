// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'TaskHo';

  @override
  String get appSubtitle => 'İşini organize et, zamanına sahip çık';

  @override
  String get login => 'Giriş Yap';

  @override
  String get register => 'Kayıt Ol';

  @override
  String get logout => 'Çıkış Yap';

  @override
  String get email => 'E-posta';

  @override
  String get password => 'Şifre';

  @override
  String get name => 'Ad Soyad';

  @override
  String get rememberMe => 'Beni hatırla';

  @override
  String get forgotPassword => 'Şifremi unuttum';

  @override
  String get dontHaveAccount => 'Hesabınız yok mu? ';

  @override
  String get alreadyHaveAccount => 'Zaten hesabınız var mı? ';

  @override
  String get signUp => 'Kayıt olun';

  @override
  String get signIn => 'Giriş yapın';

  @override
  String get settings => 'Ayarlar';

  @override
  String get editProfile => 'Profili Düzenle';

  @override
  String get changePassword => 'Şifre Değiştir';

  @override
  String get confirmLogout => 'Çıkış yapmak istediğinize emin misiniz?';

  @override
  String get cancel => 'İptal';

  @override
  String get save => 'Kaydet';

  @override
  String get update => 'Güncelle';

  @override
  String get delete => 'Sil';

  @override
  String get change => 'Değiştir';

  @override
  String get currentPassword => 'Mevcut Şifre';

  @override
  String get newPassword => 'Yeni Şifre';

  @override
  String get confirmPassword => 'Şifre Tekrar';

  @override
  String get passwordChanged => 'Şifre değiştirildi';

  @override
  String get profileUpdated => 'Profil güncellendi';

  @override
  String get resetPassword => 'Şifre Sıfırla';

  @override
  String get sendResetCode => 'Sıfırlama Kodu Gönder';

  @override
  String get resetCode => 'Sıfırlama Kodu';

  @override
  String get resetCodeSent => 'Sıfırlama kodu e-postanıza gönderildi';

  @override
  String get passwordResetSuccess => 'Şifre başarıyla sıfırlandı';

  @override
  String get tasks => 'Görevler';

  @override
  String get fees => 'Muhasebe Ücretleri';

  @override
  String get customers => 'Müşteriler';

  @override
  String get newTask => 'Yeni Görev';

  @override
  String get newFee => 'Yeni Ücret';

  @override
  String get newCustomer => 'Yeni Müşteri';

  @override
  String get editTask => 'Görev Düzenle';

  @override
  String get editFee => 'Ücret Düzenle';

  @override
  String get editCustomer => 'Müşteri Düzenle';

  @override
  String get customer => 'Müşteri';

  @override
  String get task => 'Görev';

  @override
  String get title => 'Başlık';

  @override
  String get due => 'Vade';

  @override
  String get priority => 'Öncelik';

  @override
  String get status => 'Durum';

  @override
  String get notes => 'Notlar';

  @override
  String get amount => 'Ücret';

  @override
  String get month => 'Ay';

  @override
  String get priorityHigh => 'Yüksek';

  @override
  String get priorityMedium => 'Orta';

  @override
  String get priorityLow => 'Düşük';

  @override
  String get statusIdle => 'Beklemede';

  @override
  String get statusInProgress => 'Devam Ediyor';

  @override
  String get statusLater => 'Sonra';

  @override
  String get statusWaiting => 'Bekliyor';

  @override
  String get statusDone => 'Tamamlandı';

  @override
  String get tabInbox => 'Tümü';

  @override
  String get tabToday => 'Bugün';

  @override
  String get tabWeek => 'Bu Hafta';

  @override
  String get tabMonth => 'Bu Ay';

  @override
  String get tabLater => 'Sonra';

  @override
  String get tabWaiting => 'Bekliyor';

  @override
  String get tabDone => 'Tamamlandı';

  @override
  String get filterCustomer => 'Müşteri';

  @override
  String get filterMonth => 'Ay (YYYY-MM)';

  @override
  String get filterStatus => 'Durum (Açık/Ödendi)';

  @override
  String get clearFilter => 'Filtreyi Temizle';

  @override
  String get isPaid => 'Ücretli';

  @override
  String get isFree => 'Ücretsiz';

  @override
  String get monthlyFee => 'Aylık Ücret';

  @override
  String get feeAmount => 'Ücret (€)';

  @override
  String get errorRequired => 'Bu alan zorunlu';

  @override
  String get errorEmail => 'Geçerli bir e-posta girin';

  @override
  String get errorPasswordLength => 'Şifre en az 6 karakter olmalı';

  @override
  String get errorPasswordMismatch => 'Şifreler eşleşmiyor';

  @override
  String get errorTaskRequired => 'Görev adı zorunlu';

  @override
  String get loginFailed => 'Giriş başarısız';

  @override
  String get registerFailed => 'Kayıt başarısız';

  @override
  String get error => 'Hata';

  @override
  String get feeSaved => 'Ücret kaydedildi';

  @override
  String get taskSaved => 'Görev kaydedildi';

  @override
  String get customerSaved => 'Müşteri kaydedildi';

  @override
  String get back => 'Geri';

  @override
  String get language => 'Dil';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get languageAlbanian => 'Shqip';

  @override
  String get languageSerbian => 'Српски';

  @override
  String get all => 'Tümü';

  @override
  String get filterTaskType => 'Görev tipi';

  @override
  String get taskTypeInvoice => 'Fatura';

  @override
  String get taskTypeReport => 'Rapor';

  @override
  String get taskTypePayment => 'Ödeme';

  @override
  String recordsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# Kayıt',
      one: '# Kayıt',
    );
    return '$_temp0';
  }

  @override
  String get addTask => 'Görev Ekle';

  @override
  String get addEditCustomer => 'Müşteri Ekle/Düzenle';

  @override
  String get columnNumber => '#';

  @override
  String get columnCustomer => 'Müşteri';

  @override
  String get columnTask => 'Görev';

  @override
  String get columnDue => 'Vade';

  @override
  String get columnPriority => 'Öncelik';

  @override
  String get languageSelection => 'Dil Seçin / Select Language';

  @override
  String get errorPasswordRequired => 'Şifre gerekli';

  @override
  String get errorCurrentPasswordRequired => 'Mevcut şifre gerekli';

  @override
  String get errorNewPasswordRequired => 'Yeni şifre gerekli';

  @override
  String get confirmPasswordRequired => 'Şifre tekrar gerekli';
}

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
    return '$count Kayıt';
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

  @override
  String get addRecord => 'Kayıt Ekle';

  @override
  String get feeRecord => 'Ücret Kaydı';

  @override
  String get autoCreateMonthly => 'Otomatik aylık oluştur';

  @override
  String get thisMonthOnly => 'Bu ay için oluştur';

  @override
  String get columnMonth => 'Ay';

  @override
  String get columnAmount => 'Ücret (€)';

  @override
  String get columnStatus => 'Durum';

  @override
  String get columnNote => 'Not';

  @override
  String get columnActions => 'İşlem';

  @override
  String get statusOpen => 'Açık';

  @override
  String get statusPaid => 'Ödendi';

  @override
  String get markAsPaid => 'Ödendi İşaretle';

  @override
  String get undoPayment => 'Geri Al';

  @override
  String get requiredFields => 'Zorunlu alanları doldurun';

  @override
  String get ok => 'Tamam';

  @override
  String get monthYearPickerTitle => 'Ay ve Yıl Seçin';

  @override
  String get invalidNumber => 'Geçersiz sayı';

  @override
  String get noRecordsFound => 'Kayıt bulunamadı';

  @override
  String get calendar => 'Takvim';

  @override
  String get calendarView => 'Takvim';

  @override
  String get listView => 'Liste';

  @override
  String get addNote => 'Not Ekle';

  @override
  String get customerAndDateRequired => 'Müşteri ve tarih zorunludur';

  @override
  String get noteAdded => 'Not eklendi';

  @override
  String get noteUpdated => 'Not güncellendi';

  @override
  String get previousWeek => 'Önceki hafta';

  @override
  String get nextWeek => 'Sonraki hafta';

  @override
  String get thisWeek => 'Bu hafta';

  @override
  String get selectDate => 'Tarih seçmek için tıklayın';

  @override
  String get selectWeek => 'Hafta seçin';

  @override
  String get noCustomersFound => 'Müşteri bulunamadı';

  @override
  String get customersLoadFailed => 'Müşteriler yüklenemedi';

  @override
  String get newNote => 'Yeni Not';

  @override
  String get editNote => 'Not Düzenle';

  @override
  String get customerRequired => 'Müşteri seçmelisiniz';

  @override
  String get titleRequired => 'Başlık zorunludur';

  @override
  String get dateRequired => 'Tarih seçmelisiniz';

  @override
  String get selectCustomer => 'Müşteri seçin';

  @override
  String get noteTitle => 'Not başlığı';

  @override
  String get date => 'Tarih';

  @override
  String get selectDatePrompt => 'Tarih seçin';

  @override
  String get notesOptional => 'Notlar (Opsiyonel)';

  @override
  String get additionalNotes => 'Ek notlar...';

  @override
  String get completed => 'Tamamlandı';

  @override
  String get close => 'Kapat';

  @override
  String get startDate => 'Başlangıç Tarihi';

  @override
  String get endDate => 'Bitiş Tarihi';

  @override
  String get filter => 'Filtrele';

  @override
  String get clickToViewNotes =>
      'Notları görüntülemek için tarih aralığı seçip filtreleyin';

  @override
  String get noNotesInRange => 'Seçilen tarih aralığında not bulunamadı';

  @override
  String get updateCustomer => 'Müşteri Güncelle';

  @override
  String get searchHint => 'Ara (en az 1 harf)';

  @override
  String get clear => 'Temizle';

  @override
  String get newBtn => 'Yeni';

  @override
  String get customerListLoadFailed => 'Müşteri listesi yüklenemedi';

  @override
  String get noCustomersInSearch => 'Arama sonucu bulunamadı';

  @override
  String get saveChanges => 'Değişiklikleri Kaydet';

  @override
  String get deleteCustomer => 'Müşteri Sil';

  @override
  String deleteCustomerConfirm(String name) {
    return '$name müşterisini silmek istediğinize emin misiniz?';
  }

  @override
  String get customerName => 'Müşteri Adı';

  @override
  String get customerNameHint => 'Örn. ACME LLC';

  @override
  String get paidCustomer => 'Ücretli Müşteri';

  @override
  String get monthlyFeeAmount => 'Aylık Ücret (€)';

  @override
  String get customerNameRequired => 'Müşteri adı boş olamaz';

  @override
  String get customerLoadError => 'Müşteri yükleme hatası';

  @override
  String get customersColumn => 'Müşteriler';
}

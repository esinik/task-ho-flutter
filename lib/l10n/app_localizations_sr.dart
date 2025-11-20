// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Serbian (`sr`).
class AppLocalizationsSr extends AppLocalizations {
  AppLocalizationsSr([String locale = 'sr']) : super(locale);

  @override
  String get appTitle => 'TaskHo';

  @override
  String get appSubtitle => 'Организујте свој посао, владајте својим временом';

  @override
  String get login => 'Пријави се';

  @override
  String get register => 'Региструј се';

  @override
  String get logout => 'Одјави се';

  @override
  String get email => 'Имејл';

  @override
  String get password => 'Лозинка';

  @override
  String get name => 'Пуно име';

  @override
  String get rememberMe => 'Запамти ме';

  @override
  String get forgotPassword => 'Заборавио сам лозинку';

  @override
  String get dontHaveAccount => 'Немате налог? ';

  @override
  String get alreadyHaveAccount => 'Већ имате налог? ';

  @override
  String get signUp => 'Региструј се';

  @override
  String get signIn => 'Пријави се';

  @override
  String get settings => 'Подешавања';

  @override
  String get editProfile => 'Измени профил';

  @override
  String get changePassword => 'Промени лозинку';

  @override
  String get confirmLogout => 'Да ли сте сигурни да желите да се одјавите?';

  @override
  String get cancel => 'Откажи';

  @override
  String get save => 'Сачувај';

  @override
  String get update => 'Ажурирај';

  @override
  String get delete => 'Обриши';

  @override
  String get change => 'Промени';

  @override
  String get currentPassword => 'Тренутна лозинка';

  @override
  String get newPassword => 'Нова лозинка';

  @override
  String get confirmPassword => 'Потврди лозинку';

  @override
  String get passwordChanged => 'Лозинка је промењена';

  @override
  String get profileUpdated => 'Профил је ажуриран';

  @override
  String get resetPassword => 'Ресетуј лозинку';

  @override
  String get sendResetCode => 'Пошаљи код за ресетовање';

  @override
  String get resetCode => 'Код за ресетовање';

  @override
  String get resetCodeSent => 'Код за ресетовање је послат на ваш имејл';

  @override
  String get passwordResetSuccess => 'Лозинка је успешно ресетована';

  @override
  String get tasks => 'Задаци';

  @override
  String get fees => 'Рачуноводствене накнаде';

  @override
  String get customers => 'Клијенти';

  @override
  String get newTask => 'Нови задатак';

  @override
  String get newFee => 'Нова накнада';

  @override
  String get newCustomer => 'Нови клијент';

  @override
  String get editTask => 'Измени задатак';

  @override
  String get editFee => 'Измени накнаду';

  @override
  String get editCustomer => 'Измени клијента';

  @override
  String get customer => 'Клијент';

  @override
  String get task => 'Задатак';

  @override
  String get title => 'Наслов';

  @override
  String get due => 'Рок';

  @override
  String get priority => 'Приоритет';

  @override
  String get status => 'Статус';

  @override
  String get notes => 'Белешке';

  @override
  String get amount => 'Износ';

  @override
  String get month => 'Месец';

  @override
  String get priorityHigh => 'Висок';

  @override
  String get priorityMedium => 'Средњи';

  @override
  String get priorityLow => 'Низак';

  @override
  String get statusIdle => 'На чекању';

  @override
  String get statusInProgress => 'У току';

  @override
  String get statusLater => 'Касније';

  @override
  String get statusWaiting => 'Чека';

  @override
  String get statusDone => 'Завршено';

  @override
  String get tabInbox => 'Све';

  @override
  String get tabToday => 'Данас';

  @override
  String get tabWeek => 'Ове недеље';

  @override
  String get tabMonth => 'Овог месеца';

  @override
  String get tabLater => 'Касније';

  @override
  String get tabWaiting => 'Чека';

  @override
  String get tabDone => 'Завршено';

  @override
  String get filterCustomer => 'Клијент';

  @override
  String get filterMonth => 'Месец (YYYY-MM)';

  @override
  String get filterStatus => 'Статус (Отворено/Плаћено)';

  @override
  String get clearFilter => 'Обриши филтер';

  @override
  String get isPaid => 'Плаћено';

  @override
  String get isFree => 'Бесплатно';

  @override
  String get monthlyFee => 'Месечна накнада';

  @override
  String get feeAmount => 'Накнада (€)';

  @override
  String get errorRequired => 'Ово поље је обавезно';

  @override
  String get errorEmail => 'Унесите важећу имејл адресу';

  @override
  String get errorPasswordLength => 'Лозинка мора имати најмање 6 карактера';

  @override
  String get errorPasswordMismatch => 'Лозинке се не подударају';

  @override
  String get errorTaskRequired => 'Име задатка је обавезно';

  @override
  String get loginFailed => 'Пријављивање није успело';

  @override
  String get registerFailed => 'Регистрација није успела';

  @override
  String get error => 'Грешка';

  @override
  String get feeSaved => 'Накнада је сачувана';

  @override
  String get taskSaved => 'Задатак је сачуван';

  @override
  String get customerSaved => 'Клијент је сачуван';

  @override
  String get back => 'Назад';

  @override
  String get language => 'Језик';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get languageAlbanian => 'Shqip';

  @override
  String get languageSerbian => 'Српски';

  @override
  String get all => 'Све';

  @override
  String get filterTaskType => 'Тип задатка';

  @override
  String get taskTypeInvoice => 'Фактура';

  @override
  String get taskTypeReport => 'Извештај';

  @override
  String get taskTypePayment => 'Плаћање';

  @override
  String recordsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Записа',
      one: 'Запис',
    );
    return '$count $_temp0';
  }

  @override
  String get addTask => 'Додај задатак';

  @override
  String get addEditCustomer => 'Додај/Измени клијента';

  @override
  String get columnNumber => '#';

  @override
  String get columnCustomer => 'Клијент';

  @override
  String get columnTask => 'Задатак';

  @override
  String get columnDue => 'Рок';

  @override
  String get columnPriority => 'Приоритет';

  @override
  String get languageSelection => 'Изаберите језик / Select Language';

  @override
  String get errorPasswordRequired => 'Лозинка је обавезна';

  @override
  String get errorCurrentPasswordRequired => 'Тренутна лозинка је обавезна';

  @override
  String get errorNewPasswordRequired => 'Нова лозинка је обавезна';

  @override
  String get confirmPasswordRequired => 'Потврда лозинке је обавезна';

  @override
  String get addRecord => 'Додај запис';

  @override
  String get feeRecord => 'Запис накнаде';

  @override
  String get autoCreateMonthly => 'Аутоматски креирај месечно';

  @override
  String get thisMonthOnly => 'Само за овај месец';

  @override
  String get columnMonth => 'Месец';

  @override
  String get columnAmount => 'Накнада (€)';

  @override
  String get columnStatus => 'Статус';

  @override
  String get columnNote => 'Белешка';

  @override
  String get columnActions => 'Радње';

  @override
  String get statusOpen => 'Отворено';

  @override
  String get statusPaid => 'Плаћено';

  @override
  String get markAsPaid => 'Означи као плаћено';

  @override
  String get undoPayment => 'Поништи плаћање';

  @override
  String get requiredFields => 'Молимо попуните обавезна поља';

  @override
  String get ok => 'У реду';

  @override
  String get monthYearPickerTitle => 'Изаберите месец и годину';

  @override
  String get invalidNumber => 'Неважећи број';

  @override
  String get noRecordsFound => 'Нема записа';

  @override
  String get calendar => 'Календар';

  @override
  String get calendarView => 'Календар';

  @override
  String get listView => 'Листа';

  @override
  String get addNote => 'Додај белешку';

  @override
  String get customerAndDateRequired => 'Клијент и датум су обавезни';

  @override
  String get noteAdded => 'Белешка је додата';

  @override
  String get noteUpdated => 'Белешка је ажурирана';

  @override
  String get previousWeek => 'Прошла недеља';

  @override
  String get nextWeek => 'Следећа недеља';

  @override
  String get thisWeek => 'Ове недеље';

  @override
  String get selectDate => 'Изаберите датум';

  @override
  String get selectWeek => 'Изаберите недељу';

  @override
  String get noCustomersFound => 'Нема клијената';

  @override
  String get customersLoadFailed => 'Неуспело учитавање клијената';

  @override
  String get newNote => 'Нова белешка';

  @override
  String get editNote => 'Измени белешку';

  @override
  String get customerRequired => 'Клијент је обавезан';

  @override
  String get titleRequired => 'Наслов је обавезан';

  @override
  String get dateRequired => 'Датум је обавезан';

  @override
  String get selectCustomer => 'Изаберите клијента';

  @override
  String get noteTitle => 'Наслов белешке';

  @override
  String get date => 'Датум';

  @override
  String get selectDatePrompt => 'Изаберите датум';

  @override
  String get notesOptional => 'Белешке (опционо)';

  @override
  String get additionalNotes => 'Додатне белешке';

  @override
  String get completed => 'Завршено';

  @override
  String get close => 'Затвори';

  @override
  String get startDate => 'Почетни датум';

  @override
  String get endDate => 'Крајњи датум';

  @override
  String get filter => 'Филтрирај';

  @override
  String get clickToViewNotes => 'Кликните да видите белешке';

  @override
  String get noNotesInRange => 'Нема белешки у овом периоду';
}

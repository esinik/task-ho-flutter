import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_sq.dart';
import 'app_localizations_sr.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('sq'),
    Locale('sr'),
    Locale('tr')
  ];

  /// Localization for appTitle
  ///
  /// In en, this message translates to:
  /// **'TaskHo'**
  String get appTitle;

  /// Localization for appSubtitle
  ///
  /// In en, this message translates to:
  /// **'Organize your work, own your time'**
  String get appSubtitle;

  /// Localization for login
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Localization for register
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Localization for logout
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Localization for email
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Localization for password
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Localization for name
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get name;

  /// Localization for rememberMe
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// Localization for forgotPassword
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get forgotPassword;

  /// Localization for dontHaveAccount
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// Localization for alreadyHaveAccount
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// Localization for signUp
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// Localization for signIn
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// Localization for settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Localization for editProfile
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Localization for changePassword
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// Localization for confirmLogout
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get confirmLogout;

  /// Localization for cancel
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Localization for save
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Localization for update
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// Localization for delete
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Localization for change
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// Localization for currentPassword
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// Localization for newPassword
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// Localization for confirmPassword
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Localization for passwordChanged
  ///
  /// In en, this message translates to:
  /// **'Password changed'**
  String get passwordChanged;

  /// Localization for profileUpdated
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdated;

  /// Localization for resetPassword
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// Localization for sendResetCode
  ///
  /// In en, this message translates to:
  /// **'Send Reset Code'**
  String get sendResetCode;

  /// Localization for resetCode
  ///
  /// In en, this message translates to:
  /// **'Reset Code'**
  String get resetCode;

  /// Localization for resetCodeSent
  ///
  /// In en, this message translates to:
  /// **'Reset code sent to your email'**
  String get resetCodeSent;

  /// Localization for passwordResetSuccess
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully'**
  String get passwordResetSuccess;

  /// Localization for tasks
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// Localization for fees
  ///
  /// In en, this message translates to:
  /// **'Accounting Fees'**
  String get fees;

  /// Localization for customers
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customers;

  /// Localization for newTask
  ///
  /// In en, this message translates to:
  /// **'New Task'**
  String get newTask;

  /// Localization for newFee
  ///
  /// In en, this message translates to:
  /// **'New Fee'**
  String get newFee;

  /// Localization for newCustomer
  ///
  /// In en, this message translates to:
  /// **'New Customer'**
  String get newCustomer;

  /// Localization for editTask
  ///
  /// In en, this message translates to:
  /// **'Edit Task'**
  String get editTask;

  /// Localization for editFee
  ///
  /// In en, this message translates to:
  /// **'Edit Fee'**
  String get editFee;

  /// Localization for editCustomer
  ///
  /// In en, this message translates to:
  /// **'Edit Customer'**
  String get editCustomer;

  /// Localization for customer
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// Localization for task
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get task;

  /// Localization for title
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// Localization for due
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get due;

  /// Localization for priority
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// Localization for status
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// Localization for notes
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// Localization for amount
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// Localization for month
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// Localization for priorityHigh
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get priorityHigh;

  /// Localization for priorityMedium
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get priorityMedium;

  /// Localization for priorityLow
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get priorityLow;

  /// Localization for statusIdle
  ///
  /// In en, this message translates to:
  /// **'Idle'**
  String get statusIdle;

  /// Localization for statusInProgress
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get statusInProgress;

  /// Localization for statusLater
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get statusLater;

  /// Localization for statusWaiting
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get statusWaiting;

  /// Localization for statusDone
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get statusDone;

  /// Localization for tabInbox
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get tabInbox;

  /// Localization for tabToday
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get tabToday;

  /// Localization for tabWeek
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get tabWeek;

  /// Localization for tabMonth
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get tabMonth;

  /// Localization for tabLater
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get tabLater;

  /// Localization for tabWaiting
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get tabWaiting;

  /// Localization for tabDone
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get tabDone;

  /// Localization for filterCustomer
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get filterCustomer;

  /// Localization for filterMonth
  ///
  /// In en, this message translates to:
  /// **'Month (YYYY-MM)'**
  String get filterMonth;

  /// Localization for filterStatus
  ///
  /// In en, this message translates to:
  /// **'Status (Open/Paid)'**
  String get filterStatus;

  /// Localization for clearFilter
  ///
  /// In en, this message translates to:
  /// **'Clear Filter'**
  String get clearFilter;

  /// Localization for isPaid
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get isPaid;

  /// Localization for isFree
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get isFree;

  /// Localization for monthlyFee
  ///
  /// In en, this message translates to:
  /// **'Monthly Fee'**
  String get monthlyFee;

  /// Localization for feeAmount
  ///
  /// In en, this message translates to:
  /// **'Fee (€)'**
  String get feeAmount;

  /// Localization for errorRequired
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get errorRequired;

  /// Localization for errorEmail
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get errorEmail;

  /// Localization for errorPasswordLength
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get errorPasswordLength;

  /// Localization for errorPasswordMismatch
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get errorPasswordMismatch;

  /// Localization for errorTaskRequired
  ///
  /// In en, this message translates to:
  /// **'Task name is required'**
  String get errorTaskRequired;

  /// Localization for loginFailed
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// Localization for registerFailed
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registerFailed;

  /// Localization for error
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Localization for feeSaved
  ///
  /// In en, this message translates to:
  /// **'Fee saved'**
  String get feeSaved;

  /// Localization for taskSaved
  ///
  /// In en, this message translates to:
  /// **'Task saved'**
  String get taskSaved;

  /// Localization for customerSaved
  ///
  /// In en, this message translates to:
  /// **'Customer saved'**
  String get customerSaved;

  /// Localization for back
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Localization for language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Localization for languageEnglish
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Localization for languageTurkish
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  String get languageTurkish;

  /// Localization for languageAlbanian
  ///
  /// In en, this message translates to:
  /// **'Shqip'**
  String get languageAlbanian;

  /// Localization for languageSerbian
  ///
  /// In en, this message translates to:
  /// **'Српски'**
  String get languageSerbian;

  /// Generic label meaning all items
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// Filter label for task type
  ///
  /// In en, this message translates to:
  /// **'Task type'**
  String get filterTaskType;

  /// Task type: Invoice
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get taskTypeInvoice;

  /// Task type: Report
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get taskTypeReport;

  /// Task type: Payment
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get taskTypePayment;

  /// Label showing number of records
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {# Records} one {# Record} other {# Records}}'**
  String recordsCount(int count);

  /// Button label for adding a new task
  ///
  /// In en, this message translates to:
  /// **'Add Task'**
  String get addTask;

  /// Button label for adding or editing a customer
  ///
  /// In en, this message translates to:
  /// **'Add/Edit Customer'**
  String get addEditCustomer;

  /// Column header for row number
  ///
  /// In en, this message translates to:
  /// **'#'**
  String get columnNumber;

  /// Column header for customer name
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get columnCustomer;

  /// Column header for task title
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get columnTask;

  /// Column header for due date
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get columnDue;

  /// Column header for priority
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get columnPriority;

  /// Title for language selection dialog
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get languageSelection;

  /// Error message for required password field
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get errorPasswordRequired;

  /// Error message for required current password
  ///
  /// In en, this message translates to:
  /// **'Current password is required'**
  String get errorCurrentPasswordRequired;

  /// Error message for required new password
  ///
  /// In en, this message translates to:
  /// **'New password is required'**
  String get errorNewPasswordRequired;

  /// Error message for required password confirmation
  ///
  /// In en, this message translates to:
  /// **'Password confirmation is required'**
  String get confirmPasswordRequired;

  /// Button label for adding a new record
  ///
  /// In en, this message translates to:
  /// **'Add Record'**
  String get addRecord;

  /// Title for fee record dialog
  ///
  /// In en, this message translates to:
  /// **'Fee Record'**
  String get feeRecord;

  /// Checkbox label for auto-creating monthly fees
  ///
  /// In en, this message translates to:
  /// **'Auto-create monthly'**
  String get autoCreateMonthly;

  /// Checkbox label for creating fee for this month only
  ///
  /// In en, this message translates to:
  /// **'This month only'**
  String get thisMonthOnly;

  /// Column header for month
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get columnMonth;

  /// Column header for amount
  ///
  /// In en, this message translates to:
  /// **'Amount (€)'**
  String get columnAmount;

  /// Column header for status
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get columnStatus;

  /// Column header for note
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get columnNote;

  /// Column header for actions
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get columnActions;

  /// Status label for open/unpaid
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get statusOpen;

  /// Status label for paid
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get statusPaid;

  /// Button label to mark as paid
  ///
  /// In en, this message translates to:
  /// **'Mark as Paid'**
  String get markAsPaid;

  /// Button label to undo payment
  ///
  /// In en, this message translates to:
  /// **'Undo Payment'**
  String get undoPayment;

  /// Error message for required fields
  ///
  /// In en, this message translates to:
  /// **'Please fill in required fields'**
  String get requiredFields;

  /// Generic OK button
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Title for month/year picker dialog
  ///
  /// In en, this message translates to:
  /// **'Select month and year'**
  String get monthYearPickerTitle;

  /// Error for invalid numeric input
  ///
  /// In en, this message translates to:
  /// **'Invalid number'**
  String get invalidNumber;

  /// Shown when there are no records
  ///
  /// In en, this message translates to:
  /// **'No records found'**
  String get noRecordsFound;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'sq', 'sr', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'sq':
      return AppLocalizationsSq();
    case 'sr':
      return AppLocalizationsSr();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

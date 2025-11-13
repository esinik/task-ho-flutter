// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'TaskHo';

  @override
  String get appSubtitle => 'Organize your work, own your time';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get logout => 'Logout';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get name => 'Full Name';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get forgotPassword => 'Forgot password';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get signUp => 'Sign up';

  @override
  String get signIn => 'Sign in';

  @override
  String get settings => 'Settings';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get changePassword => 'Change Password';

  @override
  String get confirmLogout => 'Are you sure you want to logout?';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get update => 'Update';

  @override
  String get delete => 'Delete';

  @override
  String get change => 'Change';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get passwordChanged => 'Password changed';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get sendResetCode => 'Send Reset Code';

  @override
  String get resetCode => 'Reset Code';

  @override
  String get resetCodeSent => 'Reset code sent to your email';

  @override
  String get passwordResetSuccess => 'Password reset successfully';

  @override
  String get tasks => 'Tasks';

  @override
  String get fees => 'Accounting Fees';

  @override
  String get customers => 'Customers';

  @override
  String get newTask => 'New Task';

  @override
  String get newFee => 'New Fee';

  @override
  String get newCustomer => 'New Customer';

  @override
  String get editTask => 'Edit Task';

  @override
  String get editFee => 'Edit Fee';

  @override
  String get editCustomer => 'Edit Customer';

  @override
  String get customer => 'Customer';

  @override
  String get task => 'Task';

  @override
  String get title => 'Title';

  @override
  String get due => 'Due Date';

  @override
  String get priority => 'Priority';

  @override
  String get status => 'Status';

  @override
  String get notes => 'Notes';

  @override
  String get amount => 'Amount';

  @override
  String get month => 'Month';

  @override
  String get priorityHigh => 'High';

  @override
  String get priorityMedium => 'Medium';

  @override
  String get priorityLow => 'Low';

  @override
  String get statusIdle => 'Idle';

  @override
  String get statusInProgress => 'In Progress';

  @override
  String get statusLater => 'Later';

  @override
  String get statusWaiting => 'Waiting';

  @override
  String get statusDone => 'Done';

  @override
  String get tabInbox => 'All';

  @override
  String get tabToday => 'Today';

  @override
  String get tabWeek => 'This Week';

  @override
  String get tabMonth => 'This Month';

  @override
  String get tabLater => 'Later';

  @override
  String get tabWaiting => 'Waiting';

  @override
  String get tabDone => 'Done';

  @override
  String get filterCustomer => 'Customer';

  @override
  String get filterMonth => 'Month (YYYY-MM)';

  @override
  String get filterStatus => 'Status (Open/Paid)';

  @override
  String get clearFilter => 'Clear Filter';

  @override
  String get isPaid => 'Paid';

  @override
  String get isFree => 'Free';

  @override
  String get monthlyFee => 'Monthly Fee';

  @override
  String get feeAmount => 'Fee (€)';

  @override
  String get errorRequired => 'This field is required';

  @override
  String get errorEmail => 'Enter a valid email';

  @override
  String get errorPasswordLength => 'Password must be at least 6 characters';

  @override
  String get errorPasswordMismatch => 'Passwords do not match';

  @override
  String get errorTaskRequired => 'Task name is required';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get registerFailed => 'Registration failed';

  @override
  String get error => 'Error';

  @override
  String get feeSaved => 'Fee saved';

  @override
  String get taskSaved => 'Task saved';

  @override
  String get customerSaved => 'Customer saved';

  @override
  String get back => 'Back';

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get languageAlbanian => 'Shqip';

  @override
  String get languageSerbian => 'Српски';

  @override
  String get all => 'All';

  @override
  String get filterTaskType => 'Task type';

  @override
  String get taskTypeInvoice => 'Invoice';

  @override
  String get taskTypeReport => 'Report';

  @override
  String get taskTypePayment => 'Payment';

  @override
  String recordsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Records',
      one: 'Record',
      zero: 'Records',
    );
    return '$count $_temp0';
  }

  @override
  String get addTask => 'Add Task';

  @override
  String get addEditCustomer => 'Add/Edit Customer';

  @override
  String get columnNumber => '#';

  @override
  String get columnCustomer => 'Customer';

  @override
  String get columnTask => 'Task';

  @override
  String get columnDue => 'Due';

  @override
  String get columnPriority => 'Priority';

  @override
  String get languageSelection => 'Select Language';

  @override
  String get errorPasswordRequired => 'Password is required';

  @override
  String get errorCurrentPasswordRequired => 'Current password is required';

  @override
  String get errorNewPasswordRequired => 'New password is required';

  @override
  String get confirmPasswordRequired => 'Password confirmation is required';

  @override
  String get addRecord => 'Add Record';

  @override
  String get feeRecord => 'Fee Record';

  @override
  String get autoCreateMonthly => 'Auto-create monthly';

  @override
  String get thisMonthOnly => 'This month only';

  @override
  String get columnMonth => 'Month';

  @override
  String get columnAmount => 'Amount (€)';

  @override
  String get columnStatus => 'Status';

  @override
  String get columnNote => 'Note';

  @override
  String get columnActions => 'Actions';

  @override
  String get statusOpen => 'Open';

  @override
  String get statusPaid => 'Paid';

  @override
  String get markAsPaid => 'Mark as Paid';

  @override
  String get undoPayment => 'Undo Payment';

  @override
  String get requiredFields => 'Please fill in required fields';

  @override
  String get ok => 'OK';

  @override
  String get monthYearPickerTitle => 'Select month and year';

  @override
  String get invalidNumber => 'Invalid number';

  @override
  String get noRecordsFound => 'No records found';
}

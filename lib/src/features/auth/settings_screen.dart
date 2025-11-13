import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/app_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/providers/log_provider.dart';
import '../../core/services/log_export_service.dart';
import '../../core/services/remote_config_service.dart';
import '../../core/logging/app_logger.dart';
import '../../core/logging/log_database.dart';
import '../../core/enums/router_enums.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    // Log screen view
    AppLogger().logScreenView('Settings');
    final user = ref.watch(currentUserProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.tasks);
            }
          },
          tooltip: l10n.back,
        ),
        title: Text(l10n.settings),
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // User info card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: theme.colorScheme.primaryContainer,
                          child: Text(
                            user.name[0].toUpperCase(),
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: () => _showEditProfileDialog(context, user),
                          icon: const Icon(Icons.edit_outlined),
                          label: Text(l10n.editProfile),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Settings section
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.language),
                        title: Text(l10n.language),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _showLanguageDialog(context),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.lock_outline),
                        title: Text(l10n.changePassword),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _showChangePasswordDialog(context),
                      ),
                      // Show log export button only for allowed users
                      FutureBuilder<bool>(
                        future: ref.read(logExportEnabledProvider(user.email).future),
                        builder: (context, snapshot) {
                          if (snapshot.data == true) {
                            return Column(
                              children: [
                                const Divider(height: 1),
                                ListTile(
                                  leading: const Icon(Icons.bug_report_outlined),
                                  title: const Text('Send Device Logs'),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: () => _showExportLogsDialog(context),
                                ),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      // Show maintenance button only when maintain_db is enabled
                      FutureBuilder<bool>(
                        future: ref.read(maintenanceEnabledProvider(user.email).future),
                        builder: (context, snapshot) {
                          if (snapshot.data == true) {
                            return Column(
                              children: [
                                const Divider(height: 1),
                                ListTile(
                                  leading: const Icon(Icons.cleaning_services_outlined),
                                  title: const Text('Maintenance'),
                                  subtitle: const Text('Delete all logs and optimize storage'),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: () => _showMaintenanceDialog(context),
                                ),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.logout, color: theme.colorScheme.error),
                        title: Text(
                          l10n.logout,
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _showLogoutDialog(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void _showExportLogsDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final logger = AppLogger();

    // Get log statistics
    final logExportService = LogExportService();
    final stats = await logExportService.getLogStats();

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.bug_report_outlined),
            SizedBox(width: 8),
            Text('Device Logs'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This will export all device logs to a file that you can share for debugging purposes.',
              style: Theme.of(dialogContext).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(dialogContext).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Log Statistics:',
                    style: Theme.of(dialogContext).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Text('Total Events: ${stats['totalLogs'] ?? 0}'),
                  if (stats['oldestLog'] != null)
                    Text('Oldest Log: ${_formatDateTime(DateTime.parse(stats['oldestLog']))}'),
                  if (stats['newestLog'] != null)
                    Text('Newest Log: ${_formatDateTime(DateTime.parse(stats['newestLog']))}'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'The exported file will not contain any passwords or sensitive data.',
              style: Theme.of(dialogContext).textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton.icon(
            onPressed: () async {
              Navigator.of(dialogContext).pop();

              try {
                // Show loading indicator
                if (!context.mounted) return;
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Preparing logs...'),
                          ],
                        ),
                      ),
                    ),
                  ),
                );

                // Export logs
                final outputPath = await logExportService.exportLogs();

                if (!context.mounted) return;
                Navigator.of(context).pop(); // Close loading dialog

                if (outputPath != null) {
                  await logger.logInfo('Device logs exported successfully');

                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Logs exported successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                await logger.logError('Failed to export logs: $e');

                if (!context.mounted) return;
                Navigator.of(context).pop(); // Close loading dialog if open

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to export logs: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            icon: const Icon(Icons.file_download_outlined),
            label: const Text('Export Logs'),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _showMaintenanceDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final logger = AppLogger();

    // Get current log count and retention setting
    final logCount = await LogDatabase().getLogCount();
    final retentionDays = RemoteConfigService().getLogRetentionDays();

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.cleaning_services_outlined),
            SizedBox(width: 8),
            Text('Maintenance'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This will delete ALL log events (not just older than $retentionDays days) and optimize the database to free up disk space.',
              style: Theme.of(dialogContext).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(dialogContext).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Log Database:',
                    style: Theme.of(dialogContext).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Text('Total Log Events: $logCount'),
                  Text('Configured Retention (for automatic cleanup): $retentionDays days'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'All logs will be permanently deleted. This action cannot be undone.',
              style: Theme.of(dialogContext).textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(dialogContext).colorScheme.error,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton.icon(
            onPressed: () async {
              Navigator.of(dialogContext).pop();

              try {
                // Show loading indicator
                if (!context.mounted) return;
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Deleting logs & optimizing...'),
                          ],
                        ),
                      ),
                    ),
                  ),
                );

                // Run full maintenance: delete ALL logs then vacuum
                final db = LogDatabase();
                await db.clearAllLogs();
                await db.vacuum();
                final newCount = await db.getLogCount();

                await logger.logInfo('Full maintenance completed: $logCount → $newCount events (all logs deleted)');

                if (!context.mounted) return;
                Navigator.of(context).pop(); // Close loading dialog

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Maintenance complete. Deleted $logCount logs.'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                await logger.logError('Maintenance failed: $e');

                if (!context.mounted) return;
                Navigator.of(context).pop(); // Close loading dialog if open

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Maintenance failed: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            icon: const Icon(Icons.cleaning_services),
            label: const Text('Run Maintenance'),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, user) {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editProfile),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: l10n.name,
                prefixIcon: const Icon(Icons.person_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: l10n.email,
                prefixIcon: const Icon(Icons.email_outlined),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              try {
                await ref.read(authNotifierProvider.notifier).updateProfile(
                      name: nameController.text.trim(),
                      email: emailController.text.trim(),
                    );
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.profileUpdated)),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${l10n.error}: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final formKey = GlobalKey<FormState>();
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.changePassword),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: l10n.currentPassword,
                  prefixIcon: const Icon(Icons.lock_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.errorCurrentPasswordRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: l10n.newPassword,
                  prefixIcon: const Icon(Icons.lock_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.errorNewPasswordRequired;
                  }
                  if (value.length < 6) {
                    return l10n.errorPasswordLength;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: l10n.confirmPassword,
                  prefixIcon: const Icon(Icons.lock_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.confirmPasswordRequired;
                  }
                  if (value != newPasswordController.text) {
                    return l10n.errorPasswordMismatch;
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;

              try {
                await ref.read(authNotifierProvider.notifier).changePassword(
                      currentPasswordController.text,
                      newPasswordController.text,
                    );
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.passwordChanged)),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${l10n.error}: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text(l10n.change),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.read(localeProvider);

    showDialog(
      context: context,
      builder: (dialogContext) => Consumer(
        builder: (context, ref, child) {
          return AlertDialog(
            title: Text(l10n.languageSelection),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('English'),
                  trailing: currentLocale.languageCode == 'en' ? const Icon(Icons.check, color: Colors.blue) : null,
                  onTap: () async {
                    await AppLogger().logButtonClick('Language', 'Settings', metadata: {'lang': 'en'});
                    await ref.read(localeProvider.notifier).setLocale(const Locale('en'));
                    if (dialogContext.mounted) Phoenix.rebirth(dialogContext);
                  },
                ),
                ListTile(
                  title: const Text('Türkçe'),
                  trailing: currentLocale.languageCode == 'tr' ? const Icon(Icons.check, color: Colors.blue) : null,
                  onTap: () async {
                    await AppLogger().logButtonClick('Language', 'Settings', metadata: {'lang': 'tr'});
                    await ref.read(localeProvider.notifier).setLocale(const Locale('tr'));
                    if (dialogContext.mounted) Phoenix.rebirth(dialogContext);
                  },
                ),
                ListTile(
                  title: const Text('Shqip'),
                  trailing: currentLocale.languageCode == 'sq' ? const Icon(Icons.check, color: Colors.blue) : null,
                  onTap: () async {
                    await AppLogger().logButtonClick('Language', 'Settings', metadata: {'lang': 'sq'});
                    await ref.read(localeProvider.notifier).setLocale(const Locale('sq'));
                    if (dialogContext.mounted) Phoenix.rebirth(dialogContext);
                  },
                ),
                ListTile(
                  title: const Text('Српски'),
                  trailing: currentLocale.languageCode == 'sr' ? const Icon(Icons.check, color: Colors.blue) : null,
                  onTap: () async {
                    await AppLogger().logButtonClick('Language', 'Settings', metadata: {'lang': 'sr'});
                    await ref.read(localeProvider.notifier).setLocale(const Locale('sr'));
                    if (dialogContext.mounted) Phoenix.rebirth(dialogContext);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logout),
        content: Text(l10n.confirmLogout),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              await AppLogger().logButtonClick('Logout', 'Settings');
              await ref.read(authNotifierProvider.notifier).logout();
              if (context.mounted) {
                context.go(AppRoutes.login);
              }
            },
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
  }
}

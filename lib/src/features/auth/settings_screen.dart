import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/app_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/enums/router_enums.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
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
                      const Divider(height: 1),
                      /* 
                      ListTile(
                        leading: const Icon(Icons.lock_reset),
                        title: const Text('Şifre Sıfırla'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push('/reset-password'),
                      ),
                      const Divider(height: 1), 
                      */
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
                    await ref.read(localeProvider.notifier).setLocale(const Locale('en'));
                    if (dialogContext.mounted) Phoenix.rebirth(dialogContext);
                  },
                ),
                ListTile(
                  title: const Text('Türkçe'),
                  trailing: currentLocale.languageCode == 'tr' ? const Icon(Icons.check, color: Colors.blue) : null,
                  onTap: () async {
                    await ref.read(localeProvider.notifier).setLocale(const Locale('tr'));
                    if (dialogContext.mounted) Phoenix.rebirth(dialogContext);
                  },
                ),
                ListTile(
                  title: const Text('Shqip'),
                  trailing: currentLocale.languageCode == 'sq' ? const Icon(Icons.check, color: Colors.blue) : null,
                  onTap: () async {
                    await ref.read(localeProvider.notifier).setLocale(const Locale('sq'));
                    if (dialogContext.mounted) Phoenix.rebirth(dialogContext);
                  },
                ),
                ListTile(
                  title: const Text('Српски'),
                  trailing: currentLocale.languageCode == 'sr' ? const Icon(Icons.check, color: Colors.blue) : null,
                  onTap: () async {
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

import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../repo/auth.dart';
import '../repo/common.dart';
import '../services/auth_storage_service.dart';

// Storage providers
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized in main()');
});

final authStorageProvider = Provider<AuthStorageService>((ref) {
  return AuthStorageService(
    ref.watch(secureStorageProvider),
    ref.watch(sharedPreferencesProvider),
  );
});

// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(apiClientProvider));
});

// Current user provider
final currentUserProvider = StateProvider<User?>((ref) => null);

// Auth state notifier
class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  AuthNotifier(this.ref) : super(const AsyncValue.loading()) {
    _init();
  }

  final Ref ref;

  Future<void> _init() async {
    try {
      final storage = ref.read(authStorageProvider);
      final token = await storage.getToken();
      final rememberMe = await storage.getRememberMe();

      if (token != null && rememberMe) {
        // Set token in API client
        ref.read(apiClientProvider).setToken(token);

        // Try to get current user
        try {
          final repo = ref.read(authRepositoryProvider);
          final user = await repo.getCurrentUser();
          ref.read(currentUserProvider.notifier).state = user;
          state = AsyncValue.data(user);
        } catch (e) {
          // Token might be expired, clear it
          await storage.deleteToken();
          ref.read(apiClientProvider).setToken(null);
          state = const AsyncValue.data(null);
        }
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> login(String email, String password, bool rememberMe) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final response = await repo.login(LoginRequest(email: email, password: password));

      log('✅ Login successful, token: ${response.token.substring(0, 20)}...');

      // Save token
      final storage = ref.read(authStorageProvider);
      await storage.saveToken(response.token);
      await storage.setRememberMe(rememberMe);

      // Set token in API client
      final apiClient = ref.read(apiClientProvider);
      log('📡 Setting token in API client...');
      apiClient.setToken(response.token);

      // Update state
      ref.read(currentUserProvider.notifier).state = response.user;
      state = AsyncValue.data(response.user);
      log('✅ User state updated: ${response.user.email}');
    } catch (e, stack) {
      log('❌ Login error: $e', stackTrace: stack);
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> register(String email, String password, String name, bool rememberMe) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final response = await repo.register(
        RegisterRequest(email: email, password: password, name: name),
      );

      // Save token
      final storage = ref.read(authStorageProvider);
      await storage.saveToken(response.token);
      await storage.setRememberMe(rememberMe);

      // Set token in API client
      ref.read(apiClientProvider).setToken(response.token);

      // Update state
      ref.read(currentUserProvider.notifier).state = response.user;
      state = AsyncValue.data(response.user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      final storage = ref.read(authStorageProvider);
      await storage.deleteToken();

      // Clear token from API client
      ref.read(apiClientProvider).setToken(null);

      // Clear user
      ref.read(currentUserProvider.notifier).state = null;
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.changePassword(
        ChangePasswordRequest(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProfile({String? name, String? email}) async {
    try {
      final repo = ref.read(authRepositoryProvider);
      final updatedUser = await repo.updateProfile(name: name, email: email);

      // Update state
      ref.read(currentUserProvider.notifier).state = updatedUser;
      state = AsyncValue.data(updatedUser);
    } catch (e) {
      rethrow;
    }
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  return AuthNotifier(ref);
});

// Convenience provider to check if user is logged in
final isLoggedInProvider = Provider<bool>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.when(
    data: (user) => user != null,
    loading: () => false,
    error: (_, __) => false,
  );
});

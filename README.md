# TaskHo (Flutter Desktop)

Flutter desktop uygulaması. Çalıştırmak için:

```bash
flutter pub get
dart run build_runner build -d
flutter run -d macos  # veya windows/linux
```

Backend varsayılan base URL: `http://localhost:4000/api` (lib/src/core/providers/env.dart). İsterseniz şu şekilde de override edebilirsiniz:

```bash
flutter run -d macos --dart-define=TASKHO_BASE_URL=http://192.168.1.20:4000/api
```

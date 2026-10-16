
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'data/datasources/local_notification.dart';
import 'firebase_options.dart';
import 'package:finwise/presentation/pages/splash/splash.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
    ) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  await LocalNotificationService.instance.initialize();

  await AppTheme.initialize();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    final title = message.notification?.title ?? 'FinWise Update';
    final body = message.notification?.body ?? '';
    final type = message.data['type']?.toString() ?? 'update';

    await LocalNotificationService.instance.createNotification(
      title: title,
      message: body,
      type: type,
    );

    if (body.isNotEmpty || message.notification?.title != null) {
      await LocalNotificationService.instance.showNotification(
        id: DateTime.now()
            .millisecondsSinceEpoch
            .remainder(2147483647),
        title: title,
        body: body,
        type: type,
        payload: message.data.toString(),
      );
    }
  });

  runApp(const FinWiseApp());
}

class FinWiseApp extends StatelessWidget {
  const FinWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeMode,
      builder: (context, currentMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FinWise',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentMode,
          home: const SplashScreen(),
        );
      },
    );
  }
}

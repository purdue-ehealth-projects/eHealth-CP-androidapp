import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'home_page.dart';
import 'database.dart';
import 'tts_toggle_provider.dart';

/// Main imports environmental variables, connect to MongoDB, set up
/// Notifications, and runs MyApp.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();

  // Initialize TTS engine
  TtsToggleProvider ttsToggleProvider = TtsToggleProvider();
  await ttsToggleProvider.flutterTts.setLanguage("en-US");
  await ttsToggleProvider.flutterTts.setSpeechRate(0.5);
  await ttsToggleProvider.flutterTts.setVolume(ttsToggleProvider.isTtsEnabled ? 1.0 : 0.0);

  AwesomeNotifications().initialize(
      null, //icon is null right now
      [
        NotificationChannel(
          channelGroupKey: 'notificatinos',
          channelKey: 'reminders',
          channelName: 'Survey Reminders',
          channelDescription: 'Survey Reminder Notifications',
          channelShowBadge: true,
          defaultColor: Colors.blueAccent,
          ledColor: Colors.white,
          importance: NotificationImportance.High,
        ),
      ],
      debug: true);
  // we need to connect in main as homepage won't initalize again on app restart
  await MongoDB.connect();
  runApp(
    ChangeNotifierProvider(
      create: (context) => TtsToggleProvider(), // Provide the TtsToggleProvider
      child: const MyApp(),
    ),
  );
}

/// Main app screen that is called first by default. Redirects to homepage.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.teal,
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.tealAccent),
      ),
      title: 'EMS Health',
      home: const HomePage(),
    );
  }
}

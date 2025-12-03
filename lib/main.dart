import 'package:blockchain/app/presentation/views/login_view.dart';
import 'package:blockchain/firebase_options.dart';
import 'package:blockchain/injection.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/get_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setup(); // Dependency injection setup
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginView(), // Halaman login sebagai halaman utama
    );
  }
}

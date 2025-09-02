import 'package:flutter/material.dart';
import 'screens/user_type_selection_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Perpustakaan',
      home: UserTypeSelectionScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

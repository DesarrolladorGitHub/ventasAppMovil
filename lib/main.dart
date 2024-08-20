import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ventas_app/api/firebase_ap.dart';

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotification();
  runApp(const MyApp());
}

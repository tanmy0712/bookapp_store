import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:libercopia_bookstore_app/utils/local_storage/storage_utility.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'data/repositories/authentication/authentication_repository.dart';
import 'firebase_options.dart';

Future<void> main() async {
  /// Widgets Binding
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  /// Await Native Splash
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  /// InitLocal Storage
  await GetStorage.init();
  await LLocalStorage.init('myBucket');

  /// Initialize Supabase
  await Supabase.initialize(
    url: "https://mlqnzpkbjllgsdvqyvph.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1scW56cGtiamxsZ3NkdnF5dnBoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDY2OTY5MDcsImV4cCI6MjA2MjI3MjkwN30.Ngxi1ZUrELA8HKezFskwte9MppU9wJ301l7vQ33631s",
  );

  /// Initialize Authentication
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((FirebaseApp value) => Get.put(AuthenticationRepository()));

  runApp(const MyApp());
}

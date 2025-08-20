import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:testfirebase/firebase_options.dart';
import 'package:testfirebase/services/alert_services.dart';
import 'package:testfirebase/services/auth_service.dart';
import 'package:testfirebase/services/media_service.dart';
import 'package:testfirebase/services/navigation_service.dart';

Future<void> setupFirebase() async{
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> registerServices() async {
  final GetIt getIt = GetIt.instance;
  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<NavigationService>(NavigationService());
  getIt.registerSingleton<AlertServices>(AlertServices());
  getIt.registerSingleton<MediaService>(MediaService());
}
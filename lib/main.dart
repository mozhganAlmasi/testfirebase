import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:testfirebase/pages/chat_page.dart';
import 'package:testfirebase/pages/home.dart';
import 'package:testfirebase/pages/login_page.dart';
import 'package:testfirebase/pages/register_page.dart';
import 'package:testfirebase/services/auth_service.dart';
import 'package:testfirebase/services/navigation_service.dart';
import 'package:testfirebase/utils.dart';
import 'models/chat_user.dart' ;

void main() async {

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setup();
  runApp(MyApp());
}

Future<void> setup() async{
  WidgetsFlutterBinding.ensureInitialized();
   await setupFirebase();
   await registerServices();
}
class MyApp extends StatelessWidget {
  MyApp({super.key}){ }

  final AuthService _authService = GetIt.instance<AuthService>();
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey ,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple) ,
      ),
      initialRoute:(_authService.user != null) ?'/home' : '/login' ,
      routes: {
        '/login': (BuildContext _context) => LoginPage() ,
       '/register': (BuildContext _context) => RegisterPage() ,
        '/home': (BuildContext _context) => HomePage() ,
        },
      onGenerateRoute: (settings) {
        if (settings.name == '/chat') {
          final chatUser = settings.arguments as MyChatUser;
          return MaterialPageRoute(
            builder: (context) => ChatPage(chatUser: chatUser),
          );
        }
        return null;
      },
    );
  }
}

class AuthExampleApp extends StatefulWidget {
  const AuthExampleApp({super.key});

  @override
  State<AuthExampleApp> createState() => _AuthExampleAppState();
}

class _AuthExampleAppState extends State<AuthExampleApp> {
  String current_statuse ="not login";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)
                      )
                  ),
                  child: Text(("Sign up")),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)
                      )
                  ),
                  child: Text(("Login")),
                ),
              ),
              Text(current_statuse , style: TextStyle(fontSize: 30),),
            ],
          ),
        ),
      ),
    );
  }
}


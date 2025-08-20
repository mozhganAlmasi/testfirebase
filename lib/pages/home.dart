import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:testfirebase/pages/login_page.dart';
import 'package:testfirebase/services/auth_service.dart';
import 'package:testfirebase/services/navigation_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key}) ;

  @override
  State<HomePage> createState() => _HomePageState() ;
}

class _HomePageState extends State<HomePage> {
  AuthService _authService = GetIt.instance<AuthService>() ;
  NavigationService _navigationService = GetIt.instance<NavigationService>();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          actions: [IconButton(onPressed: () async{
            bool result = await _authService.logout();
            if(result)
              {
                _navigationService.navigateToRoute('/login');
              }
          }, icon: Icon(Icons.logout))] ,
        ),
        body: Center(child: Text("Hi"),),
      );

  }
}

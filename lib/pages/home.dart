import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:testfirebase/pages/chat_page.dart';
import 'package:testfirebase/services/auth_service.dart';
import 'package:testfirebase/services/navigation_service.dart';
import 'package:testfirebase/utils.dart';
import '../models/chat_user.dart';
import '../services/database_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key}) ;

  @override
  State<HomePage> createState() => _HomePageState() ;
}

class _HomePageState extends State<HomePage> {
  AuthService _authService = GetIt.instance<AuthService>() ;
  NavigationService _navigationService = GetIt.instance<NavigationService>();
  final DatabaseService _databaseService = GetIt.instance<DatabaseService>();
  late String chatID ;
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
        body: _buildUI(),
      );
  }
  Widget _buildUI(){
   return SafeArea(
     child: Padding(padding: EdgeInsets.symmetric(horizontal: 15 , vertical: 20),
     child: StreamBuilder<QuerySnapshot>(
     stream: _databaseService.getUsersAll(),
     builder: (context, snapshot) {
       if(snapshot.hasError){
         return const Center(child: Text("دریافت اطلاعات انجام نشد"));
       }
       if (snapshot.connectionState == ConnectionState.waiting) {
         return CircularProgressIndicator();
       }
       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
         return Text("No users found");
       }
       final users = snapshot.data!.docs;
       return ListView.builder(
           itemCount: users.length,
           itemBuilder: (context , index){
             MyChatUser user = MyChatUser.fromJSON(users[index].data() as Map<String, dynamic>);

             return Padding(
           padding: EdgeInsets.all(5),
           child: GestureDetector(
             onTap: ()async {
               chatID = generateChatID(uid1: _authService.user!.uid, uid2: user.uid);
           final chatExist = await _databaseService.checkChatExists(chatID );
           if(!chatExist){
             _databaseService.createChat(chatID);
           }
           _navigationService.navigateToRouteWithArgument('/chat', user: user);


         },child: Text(user.name),
           ),
         );

       });

     },
   )
     ,));
  }
}

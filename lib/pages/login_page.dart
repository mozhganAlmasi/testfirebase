import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:testfirebase/services/alert_services.dart';
import 'package:testfirebase/services/auth_service.dart';
import 'package:testfirebase/services/navigation_service.dart';
import 'package:testfirebase/widgets/custom_input_fields.dart';
import 'package:testfirebase/widgets/rounded_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final GlobalKey<FormState> _loginFormKey = GlobalKey();

  final AuthService authService = GetIt.instance<AuthService>();
  final NavigationService navigationService= GetIt.instance<NavigationService>();
  final AlertServices alertServices = GetIt.instance<AlertServices>();

  String? _email;
  String? _password;
  late double _deviceHeight;
  late double _deviceWidth;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: true ,
        body: _buildUI());
  }

  Widget _buildUI() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth * 0.03,
          vertical: _deviceHeight * 0.02,
        ),

        width: _deviceWidth * 0.97,
        height: _deviceHeight * 0.98,

        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
              _headerText(),
              _loginForm(),
             _loginButton(),
             SizedBox(height: 20,),
             _registerAccountLink(),

          ],
        ),
      ),
    );
  }
  Widget _headerText(){
    return SizedBox(
      width: _deviceWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min ,
        mainAxisAlignment: MainAxisAlignment.start ,
        crossAxisAlignment: CrossAxisAlignment.start ,
        children: [
          Text("Hi Welcome Back" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w800),)

        ],
      ),
    );
  }
  Widget _loginForm() {
    return Container(
      height: _deviceHeight * 0.25,
      margin: EdgeInsets.symmetric(vertical: _deviceHeight*0.05),
      child: Form(
        key: _loginFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextFormField(
                onSaved: (_value) {
                  setState(() {
                    _email = _value;
                  });
                },
                regEx:
                RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"),
                hintText: "Email",
                obscureText: false),

            CustomTextFormField(
                onSaved: (_value) {
                  setState(() {
                    _password = _value;
                  });
                },
                regEx: RegExp(r".{8,}"),
                hintText: "Password",
                obscureText: true),
          ],
        ),
      ),
    );
  }
  Widget _loginButton() {
    return RoundedButton(
      name: "Login",
      height: _deviceHeight * 0.065,
      width: _deviceWidth * 0.65,
      onPressed: () async{
        if (_loginFormKey.currentState!.validate() ?? false) {
          _loginFormKey.currentState!.save();
           bool result =await authService.login(_email!, _password!);
           if(result){
             navigationService.navigateToRoute('/home');
             print("success");
           }else{
             alertServices.showToast(text: 'Fail To Login' , icon: Icons.error);
             print("unsuccess");
           }
        }
      },
    );
  }
  Widget _registerAccountLink() {
    return GestureDetector(
      onTap: () {} ,//=> _navigation.navigateToRoute('/register'),
      child: Container(
        child: GestureDetector(
          child: Text(
            'Don\'t have an account?' ,
             style: TextStyle(
              color: Colors.blueAccent ,
            ),
          ),
          onTap: (){
            navigationService.navigateToRoute('/register');
          },
        ),
      ),
    );
  }
}

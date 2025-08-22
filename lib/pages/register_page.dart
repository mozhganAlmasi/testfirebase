import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:testfirebase/services/media_service.dart';

import '../const.dart';
import '../services/alert_services.dart';
import '../services/auth_service.dart';
import '../services/navigation_service.dart';
import '../widgets/custom_input_fields.dart';
import '../widgets/rounded_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey();
  final AuthService authService = GetIt.instance<AuthService>();
  final NavigationService navigationService =
      GetIt.instance<NavigationService>();
  final AlertServices alertServices = GetIt.instance<AlertServices>();
  final MediaService mediaService = GetIt.instance<MediaService>();

  String? _email;
  String? _password;
  String? _name;
  late double _deviceHeight;
  late double _deviceWidth;
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(resizeToAvoidBottomInset: false, body: _buildUI());
  }

  Widget _buildUI() {
    return SafeArea(
      child: Container(
        width: _deviceWidth * 0.97,
        height: _deviceHeight * 0.98,

        padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth * 0.03,
          vertical: _deviceHeight * 0.02,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _headerText(),
            _pfpSelectionField(),
            _registerForm(),

            SizedBox(height: 20),
            _registerAccountLink(),
          ],
        ),
      ),
    );
  }

  Widget _headerText() {
    return Container(
      width: _deviceWidth,
      margin: EdgeInsets.symmetric(
        horizontal: _deviceWidth * 0.03,
        vertical: _deviceHeight * 0.02,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Lets get going",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  Widget _registerForm() {
    return Container(
      height: _deviceHeight * 0.35,
      margin: EdgeInsets.symmetric(vertical: _deviceHeight * 0.05),
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextFormField(
              onSaved: (_value) {
                setState(() {
                  _name = _value;
                });
              },
              regEx: RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
              ),
              hintText: "Name",
              obscureText: false,
            ),
            CustomTextFormField(
              onSaved: (_value) {
                setState(() {
                  _email = _value;
                });
              },
              regEx: RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
              ),
              hintText: "Email",
              obscureText: false,
            ),
            CustomTextFormField(
              onSaved: (_value) {
                setState(() {
                  _password = _value;
                });
              },
              regEx: RegExp(r".{8,}"),
              hintText: "Password",
              obscureText: true,
            ),
            _registerButton(),
          ],
        ),
      ),
    );
  }

  Widget _pfpSelectionField() {
    return GestureDetector(
      onTap: () async {
        File? file = await mediaService.getImageFromGalery();
        if (file != null) {
          setState(() {
            _selectedImage = file;
          });
        }
      },
      child: CircleAvatar(
        radius: _deviceWidth * 0.15,
        backgroundImage: (_selectedImage != null)
            ? FileImage(_selectedImage!)
            : NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
      ),
    );
  }

  Widget _registerButton() {
    return RoundedButton(
      name: "register",
      height: _deviceHeight * 0.065,
      width: _deviceWidth * 0.65,
      onPressed: () async {
        try {
          if ((_registerFormKey.currentState?.validate() ?? false) &&
              _selectedImage != null) {
            _registerFormKey.currentState?.save();
          }
        } catch (e) {
          print(e);
        }
      },
    );
  }

  Widget _registerAccountLink() {
    return GestureDetector(
      onTap: () {}, //=> _navigation.navigateToRoute('/register'),
      child: Container(
        child: GestureDetector(
          child: Text(
            'Already have an account ?Login',
            style: TextStyle(color: Colors.blueAccent),
          ),
          onTap: () {
            navigationService.goBack();
          },
        ),
      ),
    );
  }
}

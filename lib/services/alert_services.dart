import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'navigation_service.dart';

class AlertServices {
  final NavigationService _navigationService= GetIt.instance<NavigationService>();
  AlertServices();

  void showToast({required String text, IconData icon = Icons.info}) {
    final context = NavigationService.navigatorKey.currentContext;
    try {
      DelightToastBar(
        autoDismiss: true,
        builder: (context) {
          return ToastCard(title: Text(text),leading: Icon(icon , size: 20,),);
        },
      ).show(context!);
    } catch (e) {
      print(e);
    }
  }
}

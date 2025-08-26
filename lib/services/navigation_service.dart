import 'package:flutter/material.dart';
import 'package:testfirebase/models/chat_user.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey =
  new GlobalKey<NavigatorState>();

  void removeAndNavigateToRoute(String _route) {
    navigatorKey.currentState?.popAndPushNamed(_route);
  }

  void navigateToRoute(String _route) {
    navigatorKey.currentState?.pushNamed(_route);
  }
  Future<dynamic>? navigateToRouteWithArgument(String routeName, {MyChatUser? user}) {
    return navigatorKey.currentState?.pushNamed(routeName, arguments: user);
  }

  void navigateToPage(Widget _page) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (BuildContext _context) {
          return _page;
        },
      ),
    );
  }

  String? getCurrentRoute() {
    return ModalRoute.of(navigatorKey.currentState!.context)?.settings.name!;
  }

  void goBack() {
    navigatorKey.currentState?.pop();
  }
}

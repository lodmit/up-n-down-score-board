import 'package:flutter/material.dart';

import 'core/page_arguments.dart';
import 'pages/home/home_view.dart';
import 'shared/splash_view.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => SplashView(),
          //settings:
        );
      case '/home':
        return MaterialPageRoute(
          builder: (_) => HomeView(arguments: settings.arguments as PageArguments?),
          //settings:
        );
      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          );
        });
    }
  }
}

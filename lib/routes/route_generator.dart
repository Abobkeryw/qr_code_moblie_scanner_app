import 'package:flutter/material.dart';
import '../home.dart';
import '../page/qr_code.dart';
import '../page/result_page.dart';
import '../page/register_screen.dart';
import '../page/forgot_password.dart';
import 'route_name.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.home:
        return MaterialPageRoute(builder: (context) => MyHomePage());
      case RouteName.qrCode:
        return MaterialPageRoute(builder: (context) => QRCodePage());
      case RouteName.resultPage:
        // Handle result page with optional arguments
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => ResultPage(
            result: args?['result'] ?? '',
          ),
        );
      case RouteName.registerScreen:
        return MaterialPageRoute(builder: (context) => RegisterScreen());
      case RouteName.forgotPassword:
        return MaterialPageRoute(builder: (context) => ForgotPasswordScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) => PageNotFound());
  }
}

class PageNotFound extends StatelessWidget {
  const PageNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page Not Found'),
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.redAccent, size: 80),
            SizedBox(height: 16),
            Text(
              '404',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Oops! Page Not Found',
              style: TextStyle(fontSize: 20, color: Colors.grey[700]),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteName.home,
                  (route) => false,
                );
              },
              child: Text('Go Home'),
            ),
            SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

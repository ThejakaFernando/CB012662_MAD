import 'package:cb012662/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:cb012662/register.dart';
import 'package:cb012662/home.dart';
import 'package:cb012662/login.dart';
import 'package:cb012662/products.dart';
import 'package:cb012662/cart.dart';

// light and dark themes are defined
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.purple,
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  // Method to toggle the theme mode
  void _toggleTheme() {
    setState(() {
      _themeMode =
      _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      initialRoute: Login.id, // initial route is set to login page
      routes: {
        Login.id: (context) =>
        const Login(),
        Register.id: (context) => Register(),
        Home.id: (context) =>
            Home(onToggleTheme: _toggleTheme),
        ProductsPage.id: (context) => ProductsPage(),
        CartPage.id: (context) => CartPage(),

      },
    );
  }
}

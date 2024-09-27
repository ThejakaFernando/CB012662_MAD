import 'package:flutter/material.dart';
import 'package:cb012662/home.dart';
import 'package:cb012662/register.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  static const String id = "login";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage("images/ecoCare.png"),
                backgroundColor: Colors.transparent,
                radius: 60,
              ),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "EcoCare",
                      style: TextStyle(fontSize: 35, fontFamily: "Roboto", fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),

              // username input with outline border
              TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Username",
                  prefixIcon: Icon(Icons.supervised_user_circle),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Password input with outline border
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
              ),
              SizedBox(height: 32),

              MaterialButton(
                color: Color(0xFF978D4F),
                height: 48,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, Home.id);


                },
              ),

              SizedBox(height: 14),

              GestureDetector(
                onTap: () {
                  navTransition(context, Register());
                },
                child: Text(
                  "New to EcoCare? Create an account",
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navTransition(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {

          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

}

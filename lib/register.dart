import 'package:flutter/material.dart';
import 'package:cb012662/home.dart';
import 'package:cb012662/login.dart';

class Register extends StatelessWidget {
  const Register({super.key});


  static const String id = "register";

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
                      style: TextStyle(
                          fontSize: 35,
                          fontFamily: "Ubuntu",
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),

              // firstName input with outline border
              TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Firstname",
                  prefixIcon: Icon(Icons.person_2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Lastname input with outline border
              TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Lastname",
                  prefixIcon: Icon(Icons.person_2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Email input with outline border
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // password Input with Outline Border
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.password_sharp),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
              ),
              SizedBox(height: 32),

              // Register Button
              MaterialButton(
                color: Color(0xFF978D4F),
                height: 48,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0), //rounded corners
                ),
                child: Text(

                  "Register",
                  style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: "Roboto"),
                ),
                onPressed: () {

                  navTransition(context, Login());
                },
              ),
              SizedBox(height: 14),

              // Login Redirect
              GestureDetector(
                onTap: () {
                  //Navigator.pushNamed(context, Login.id);
                  navTransition(context, Login());
                },
                child: Text(
                  "Already registered? Login",
                  style: TextStyle(
                    fontFamily: "Roboto",
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

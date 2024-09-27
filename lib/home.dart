import 'package:cb012662/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:cb012662/register.dart';
import 'package:cb012662/products.dart';
import 'package:cb012662/login.dart';
import 'package:cb012662/cart.dart';


class Home extends StatefulWidget {
  static final String id = 'Home';

  final VoidCallback onToggleTheme; // callback to toggle theme

  const Home({required this.onToggleTheme, Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0; // to track the selected tab index
  bool isDarkMode = false; // Tracks the current theme state

  // MEthod to handle custom page transitions
  void navTransition(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Apply a fade transition
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  // Method to handle bottom navigation bar item taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigates to different pages based on the selected index
    switch (index) {
      case 0:
        navTransition(context, Home(onToggleTheme: widget.onToggleTheme));
        break;
      case 1:
        navTransition(context, ProductsPage());
        break;
      case 2:
        navTransition(context, Login());
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'EcoCare',
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Roboto",
          ),
        ),
        backgroundColor: Color(0xFF978D4F),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF978D4F),
              ),
              child: Text(
                'EcoCare',
                style: TextStyle(
                  fontFamily: "Roboto",
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
                navTransition(context, Home(onToggleTheme: widget.onToggleTheme));
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Cart'),
              onTap: () {
                Navigator.pop(context);
                navTransition(context, CartPage());
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Your Wishlist'),
              onTap: () {
                Navigator.pop(context);
                navTransition(context, WishlistPage());
              },
            ),
            SwitchListTile(
              title: Text('Dark Mode'),
              secondary: Icon(
                Icons.dark_mode,
              ),
              value: isDarkMode,
              onChanged: (bool value) {
                setState(() {
                  isDarkMode = value;
                });
                widget.onToggleTheme(); // theme toggle function
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: ListView(
        children: [

          Card(
            margin: EdgeInsets.all(16.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset(
                'images/ecoBanner.png',
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),
          ),


          Card(
            margin: EdgeInsets.all(16.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Making a Difference Together',
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'A Commitment to Our Planet',
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 19.0,
                      fontWeight: FontWeight.w600, // semi-bold
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Our mission at EcoCare is to completely change personal care with '
                        'Eco-conscious products that benefit you and the environment. '
                        'Discover natural and sustainable personal care products from '
                        'reliable businesses devoted to environmental sustainability and '
                        'ethical business practices. Together, let\'s make the planet healthier '
                        'and greener!',
                    style: TextStyle(
                        fontSize: 16.0,
                      fontFamily: "Roboto",
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),


          Column(
            children: [
              Image.asset(
                'images/drop.png',
                height: 150,
                width: double.infinity,
              ),


              SizedBox(height: 16.0),


              Text(
                'Discover Eco-Friendly Personal Care Products',
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),


              SizedBox(height: 8.0),

              // Second line of text
              Text(
                'Your Choices Matter - Make a Positive Impact',
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 16.0,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Image.asset(
                    'images/ethiqueshampoo1.png',
                    height: 160,
                    width: 160,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 16.0),
                  Image.asset(
                    'images/ethiqueshampoo2.png',
                    height: 160,
                    width: 160,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 16.0),
                  Image.asset(
                    'images/ethiquedeodrant3.png',
                    height: 160,
                    width: 160,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 16.0),
                  Image.asset(
                    'images/ethiqueshampoo4.png',
                    height: 160,
                    width: 160,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 16.0),
                  Image.asset(
                    'images/ethiqueshampoo5.png',
                    height: 160,
                    width: 160,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 16.0),
                  Image.asset(
                    'images/ethiquedeodrant1.png',
                    height: 160,
                    width: 160,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ),


          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: MaterialButton(
                color: Color(0xFF978D4F),
                height: 44, // Button height
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Text(
                  "Shop Now",
                  style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  //transition method is used below (method is defined at the top)
                  navTransition(context, ProductsPage());
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color(0xFF978D4F),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shop_sharp),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}

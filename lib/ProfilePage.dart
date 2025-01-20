import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:cb012662/login.dart';
import 'package:geolocator/geolocator.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? userName;
  String? email;
  String? profilePhotoUrl;
  bool isLoading = true;
  String? errorMessage;
  String? location = 'Fetching location...';

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
    _fetchLocation();
  }

  Future<void> _fetchUserProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
        return;
      }

      final response = await http.get(
        Uri.parse('http://134.209.152.31/api/profile'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userName = data['data']['name'];
          email = data['data']['email'];
          profilePhotoUrl = data['data']['profile_photo_url'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load profile. Please try again later.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _fetchLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          location = 'Location services are disabled.';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            location = 'Location permission denied.';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          location = 'Location permissions are permanently denied.';
        });
        return;
      }

      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        location = 'Lat: ${pos.latitude}, Long: ${pos.longitude}';
      });
    } catch (e) {
      setState(() {
        location = 'Failed to fetch location: $e';
      });
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('auth_token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF978D4F),
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(
        child: Text(
          errorMessage!,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: const Color(0xFF978D4F),
                backgroundImage: profilePhotoUrl != null
                    ? NetworkImage(profilePhotoUrl!)
                    : null,
                child: profilePhotoUrl == null
                    ? Text(
                  userName != null
                      ? userName![0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                userName ?? 'User',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                email ?? 'Email not available',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person,
                          color: Color(0xFF978D4F)),
                      title: const Text('Name'),
                      subtitle: Text(userName ?? 'N/A'),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.email,
                          color: Color(0xFF978D4F)),
                      title: const Text('Email'),
                      subtitle: Text(email ?? 'N/A'),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.location_on,
                          color: Color(0xFF978D4F)),
                      title: const Text('Location'),
                      subtitle: Text(location ?? 'N/A'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              MaterialButton(
                color: const Color(0xFF978D4F),
                minWidth: double.infinity,
                height: 48,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onPressed: _logout,
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:percobaan/screens/generate_screen.dart';
import 'package:percobaan/screens/profile_screen.dart';
import 'package:percobaan/screens/feedback_screen.dart';
import 'package:percobaan/screens/premium_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:percobaan/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percobaan/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late bool isPremium;

  @override
  void initState() {
    super.initState();
    _checkPremiumStatus();
  }

  void _checkPremiumStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedInUsername = prefs.getString('loggedInUsername'); // Simpan username saat login
    final userBox = Hive.box<User>('users');
    final user = userBox.values.firstWhere(
          (user) => user.username == loggedInUsername,
      orElse: () => User(username: '', password: ''),
    );

    setState(() {
      isPremium = user.isPremium;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure want to logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false);
                if (!mounted) return;
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      // Home Content
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20), // Atur radius sudut
            child: Image.asset(
              'assets/dabble.png',
              width: 200, // Sesuaikan ukuran gambar
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Welcome to Dabble',
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.purple,
              backgroundColor: Colors.white,
            ),
            onPressed: () async {
              if (isPremium) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GenerateScreen()),
                );
              } else {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PremiumScreen()),
                );

                if (result == true) {
                  setState(() {
                    isPremium = true;
                  });
                }
              }
            },
            child: Text(isPremium ? 'Generate Something' : 'Unlock Premium Features'),
          ),
        ],
      ),
      const ProfileScreen(),
      const FeedbackScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Dabble'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _showLogoutDialog,
          ),
        ],
      ),
      body: Center(child: pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            label: 'Feedback',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
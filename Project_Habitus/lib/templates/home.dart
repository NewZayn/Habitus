import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../back4app/services/habitservice.dart';
import 'habits_page.dart';
import 'calendario_page.dart';
import 'habits_concluid_page.dart';
import 'profile_page.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomePage> {
  final HabitService habitService = HabitService();
  List<ParseObject> habits = [];
  int _selectedIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    habitService.initializeParse();
    fetchHabits();
  }

  Future<void> fetchHabits() async {
    try {
      final fetchedHabits = await habitService.getHabits();
      setState(() {
        habits = fetchedHabits;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching habits: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> logout() async {
    final user = await ParseUser.currentUser();
    if (user != null) {
      var response = await user.logout();
      if (response.success) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        print('Logout failed: ${response.error?.message}');
      }
    }
  }

  Widget _getSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        return HabitsPage(habits: habits, onAddHabit: fetchHabits);
      case 1:
        return CompletedHabitsPage(
          completedHabits: habits.where((habit) => habit.get<bool>('isCompleted') ?? false).toList(),
        );
      case 2:
        return const CalendarioPage();
      case 3:
        return ProfilePage();
      default:
        return HabitsPage(habits: habits, onAddHabit: fetchHabits);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Home'),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _getSelectedPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Habits"),
          BottomNavigationBarItem(icon: Icon(Icons.check_box), label: 'Completed Habits'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendário'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
      ),
      drawer: AppDrawer(onLogout: logout),
    );
  }
}

class AppDrawer extends StatelessWidget {
  final Future<void> Function() onLogout;

  const AppDrawer({required this.onLogout, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.popUntil(context, ModalRoute.withName('/home'));
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () async {
              await onLogout();
            },
          ),
        ],
      ),
    );
  }
}

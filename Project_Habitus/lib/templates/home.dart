import 'package:flutter/material.dart';
import 'package:newapp/back4app/services/habitservice.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'components/categorybutton.dart';
import 'create_habit.dart';
import 'login.dart';
import 'profile_page.dart'; // Import the ProfilePage
import 'editprofile.dart'; // Import the EditProfilePage

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomePage> {
  final HabitService habitService = HabitService();
  List<ParseObject> habits = [];
  int _selectedIndex = 1;

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
      });
    } catch (e) {
      print(e);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        return const Center(child: Text('Estatísticas'));
      case 1:
        return Column(
          children: [
            Container(
              color: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CategoryButton("Alimentação"),
                  CategoryButton("Exercícios"),
                  CategoryButton("Estudo"),
                  CategoryButton("Trabalho"),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Hoje',
                      style: TextStyle(fontSize: 24.0),
                    ),
                    const Spacer(),
                    habits.isEmpty
                        ? const Text('Não há hábitos ainda')
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: habits.length,
                            itemBuilder: (context, index) {
                              final habit = habits[index];
                              return ListTile(
                                title: Text(
                                    habit.get<String>('title') ?? 'No Title'),
                              );
                            },
                          ),
                    const Spacer(),
                    FloatingActionButton.extended(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => const CreateHabitWidget(),
                        ).whenComplete(() => fetchHabits());
                      },
                      label: const Text('Clique aqui para criar um hábito'),
                      icon: const Icon(Icons.add),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        );
      case 2:
        return const Center(child: Text('Calendário'));
      case 3:
        return ProfilePage(); // Use the ProfilePage for the profile section
      default:
        return const Center(child: Text('Página não encontrada'));
    }
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
        // Handle logout error
        print('Logout failed: ${response.error?.message}');
      }
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
      body: _getSelectedPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: "Estatísticas"),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_box), label: 'Hábitos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Calendário'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
      ),
      drawer: Drawer(
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
                await logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}

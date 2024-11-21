import 'package:brew/models/userData.dart';
import 'package:brew/pages/home/brew_list.dart';
import 'package:brew/pages/home/settings_from.dart';
import 'package:brew/services/auth.dart';
import 'package:brew/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  Home({super.key});

  @override
  Widget build(BuildContext context) {
    void showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: const SettingsForm(),
            );
          });
    }

    return StreamProvider<List<UserData>>.value(
      value: DatabaseService().brews,
      initialData: const [],
      child: Scaffold(
        backgroundColor: const Color.fromARGB(107, 56, 97, 63),
        appBar: AppBar(
          title: const Text('Brew'),
          backgroundColor: const Color.fromARGB(255, 56, 97, 63),
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              icon: const Icon(
                Icons.person,
                color: Colors.white,
              ),
              label: const Text(
                'logout',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
            TextButton.icon(
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              label: const Text(
                'settings',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => showSettingsPanel(),
            )
          ],
        ),
        body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/coffee_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: const BrewList()),
      ),
    );
  }
}

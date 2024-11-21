import 'package:brew/models/userData.dart';
import 'package:brew/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrewTile extends StatelessWidget {
  final UserData brew;
  final UserType type;
  const BrewTile({super.key, required this.brew, required this.type});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<BrewUser?>(context);

    if (type.type == 'Barista' || brew.uid == user?.uid) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Card(
          margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.brown[brew.strength],
              backgroundImage: const AssetImage('assets/coffee_icon.png'),
            ),
            title: Text(brew.name),
            subtitle: Text('Takes ${brew.sugars} sugar(s)'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.red,
              onPressed: () async {
                await DatabaseService(uid: brew.uid).deleteUserData();
              },
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Card(
          margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.brown[brew.strength],
              backgroundImage: const AssetImage('assets/coffee_icon.png'),
            ),
            title: Text(brew.name),
            subtitle: Text('Takes ${brew.sugars} sugar(s)'),
          ),
        ),
      );
    }
  }
}

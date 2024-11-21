import 'package:brew/models/userData.dart';
import 'package:brew/pages/home/brew_tile.dart';
import 'package:brew/services/database.dart';
import 'package:brew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrewList extends StatefulWidget {
  const BrewList({super.key});

  @override
  State<BrewList> createState() => _BrewListState();
}

class _BrewListState extends State<BrewList> {
  @override
  Widget build(BuildContext context) {
    final brews = Provider.of<List<UserData>>(context) ?? [];
    final user = Provider.of<BrewUser?>(context);

    if (user == null) {
      return const Loading();
    }

    final userTypeStream = DatabaseService(uid: user.uid).userType;

    return StreamBuilder<UserType>(
        stream: userTypeStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Failed to load user type'));
          }

          final userType = snapshot.data!;

          return ListView.builder(
            itemCount: brews.length,
            itemBuilder: (context, index) {
              return BrewTile(
                brew: brews[index],
                type: userType,
              );
            },
          );
        });
  }
}

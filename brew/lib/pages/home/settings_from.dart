import 'package:brew/models/userData.dart';
import 'package:brew/services/database.dart';
import 'package:brew/shared/constants.dart';
import 'package:brew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({super.key});

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];
  final List<int> strengths = [100, 200, 300, 400, 500, 600, 700, 800, 900];

  late TextEditingController _currentName;
  String? _currentSugars;
  int? _currentStrength;

  @override
  void initState() {
    _currentName = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _currentName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<BrewUser?>(context);

    if (user == null) {
      return const Loading();
    }

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;
            _currentName.text = userData?.name ?? '';

            return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const Text(
                    'Update your brew settings.',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: _currentName,
                    decoration: textInputDecoration,
                    validator: (val) => val == null || val.isEmpty
                        ? 'Please enter a name'
                        : null,
                  ),
                  const SizedBox(height: 10.0),
                  DropdownButtonFormField(
                    value: _currentSugars ?? userData?.sugars,
                    decoration: textInputDecoration,
                    items: sugars.map((sugar) {
                      return DropdownMenuItem(
                        value: sugar,
                        child: Text('$sugar sugars'),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _currentSugars = val),
                  ),
                  const SizedBox(height: 10.0),
                  Slider(
                    value: (_currentStrength ?? userData?.strength ?? 100)
                        .toDouble(),
                    activeColor: Colors
                        .brown[_currentStrength ?? userData?.strength ?? 100],
                    inactiveColor: Colors
                        .brown[_currentStrength ?? userData?.strength ?? 100],
                    min: 100.0,
                    max: 900.0,
                    divisions: 8,
                    onChanged: (val) =>
                        setState(() => _currentStrength = val.round()),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                            ),
                            child: const Text(
                              'Update',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                await DatabaseService(uid: user.uid)
                                    .updateUserData(
                                  _currentSugars ?? userData?.sugars ?? '0',
                                  _currentName.text,
                                  _currentStrength ?? userData?.strength ?? 100,
                                );
                                Navigator.pop(context);
                              }
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                            ),
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              await DatabaseService(uid: user.uid)
                                  .deleteUserData();
                              Navigator.pop(context);
                            }),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const Text(
                    'Update your brew settings.',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: _currentName,
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Enter a name'),
                    validator: (val) => val == null || val.isEmpty
                        ? 'Please enter a name'
                        : null,
                  ),
                  const SizedBox(height: 10.0),
                  DropdownButtonFormField(
                    value: _currentSugars ?? '0',
                    decoration: textInputDecoration,
                    items: sugars.map((sugar) {
                      return DropdownMenuItem(
                        value: sugar,
                        child: Text('$sugar sugars'),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _currentSugars = val),
                  ),
                  const SizedBox(height: 10.0),
                  Slider(
                    value: (_currentStrength ?? 100).toDouble(),
                    activeColor: Colors.brown[_currentStrength ?? 100],
                    inactiveColor: Colors.brown[_currentStrength ?? 100],
                    min: 100.0,
                    max: 900.0,
                    divisions: 8,
                    onChanged: (val) =>
                        setState(() => _currentStrength = val.round()),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                        ),
                        child: const Text(
                          'Create',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            await DatabaseService(uid: user.uid).updateUserData(
                              _currentSugars ?? '0',
                              _currentName.text,
                              _currentStrength ?? 100,
                            );
                            Navigator.pop(context);
                          }
                        }),
                  ),
                ],
              ),
            );
          }
        });
  }
}

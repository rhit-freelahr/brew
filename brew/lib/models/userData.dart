class BrewUser {
  final String uid;

  BrewUser({required this.uid});
}

class UserData {
  final String uid;
  final String name;
  final String sugars;
  final int strength;

  UserData({
    required this.uid,
    required this.sugars,
    required this.strength,
    required this.name,
  });
}

class UserType {
  final String uid;
  final String type;

  UserType({
    required this.uid,
    required this.type,
  });
}

import 'package:brew/models/userData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection('brews');

  final CollectionReference userTypeCollection =
      FirebaseFirestore.instance.collection('types');

  Future<void> updateUserData(String sugars, String name, int strength) async {
    return await brewCollection.doc(uid).set({
      'uid': uid!,
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }

  Future<void> updateUserType(String type) async {
    return await userTypeCollection.doc(uid).set({
      'type': type,
    });
  }

  Future<void> deleteUserData() async {
    return await brewCollection.doc(uid).delete();
  }

  List<UserData> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return UserData(
          uid: data['uid'],
          name: data['name'] ?? '',
          strength: data['strength'] ?? 0,
          sugars: data['sugars'] ?? '0');
    }).toList();
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return UserData(
      uid: uid!,
      name: data['name'],
      sugars: data['sugars'],
      strength: data['strength'],
    );
  }

  UserType _userTypeFromSnapShot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return UserType(uid: uid!, type: data['type']);
  }

  Stream<List<UserData>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  Stream<UserData> get userData {
    return brewCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  Stream<UserType> get userType {
    return userTypeCollection.doc(uid).snapshots().map(_userTypeFromSnapShot);
  }
}

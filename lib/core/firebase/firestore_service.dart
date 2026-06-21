import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dto/folder_dto.dart';
import 'dto/settings_dto.dart';
import 'dto/word_dto.dart';

class FirestoreService {
  final _firestore = FirebaseFirestore.instance;

  User? get _user => FirebaseAuth.instance.currentUser;

  String get _uid {
    final user = _user;

    if (user == null) {
      throw Exception("User not logged in");
    }

    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> get _folders {
    return _firestore.collection('users').doc(_uid).collection('folders');
  }

  CollectionReference<Map<String, dynamic>> get _words {
    return _firestore.collection('users').doc(_uid).collection('words');
  }

  DocumentReference<Map<String, dynamic>> get _settings {
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('settings')
        .doc('main');
  }

  ///////////////////////////////////////////
  // Upload
  ///////////////////////////////////////////

  // Future<void> uploadFolder(FolderDto dto) async {
  //   await _folders.doc(dto.id).set(dto.toJson());
  // }

  Future<void> uploadFolder(FolderDto dto) async {
    try {
      print("Firestore upload folder ${dto.name}");

      await _folders.doc(dto.id).set(dto.toJson());

      print("SUCCESS");
    } catch (e) {
      print(e);

      rethrow;
    }
  }

  Future<void> uploadWord(WordDto dto) async {
    await _words.doc(dto.id).set(dto.toJson());
  }

  Future<void> uploadSettings(SettingsDto dto) async {
    await _settings.set(dto.toJson());
  }

  ///////////////////////////////////////////
  // Download
  ///////////////////////////////////////////

  Future<List<FolderDto>> getFolders() async {
    final snapshot = await _folders.get();

    return snapshot.docs.map((e) {
      return FolderDto.fromJson(e.data());
    }).toList();
  }

  Future<List<WordDto>> getWords() async {
    final snapshot = await _words.get();

    return snapshot.docs.map((e) {
      return WordDto.fromJson(e.data());
    }).toList();
  }

  Future<SettingsDto?> getSettings() async {
    final doc = await _settings.get();

    if (!doc.exists) {
      return null;
    }

    return SettingsDto.fromJson(doc.data()!);
  }

  ///////////////////////////////////////////
  // Listeners
  ///////////////////////////////////////////

  Stream<QuerySnapshot<Map<String, dynamic>>> listenFolders() {
    return _folders.snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> listenWords() {
    return _words.snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> listenSettings() {
    return _settings.snapshots();
  }
}

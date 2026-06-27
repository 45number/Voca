import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String get uid {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    return user.uid;
  }

  Reference ref(String audioId) {
    return _storage.ref('users/$uid/audio/$audioId');
  }

  Future<bool> exists(String audioId) async {
    try {
      await ref(audioId).getMetadata();

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> uploadAudio(File file, String audioId) async {
    await ref(audioId).putFile(file);
  }

  Future<File> downloadAudio(String audioId, File target) async {
    await ref(audioId).writeToFile(target);

    return target;
  }

  Future<void> deleteAudio(String audioId) async {
    try {
      await ref(audioId).delete();
    } catch (_) {}
  }
}

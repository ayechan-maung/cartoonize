import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  static final storageRef = FirebaseStorage.instance.ref();

  uploadImage(String path) async {
    storageRef.child('cartoonized').child('cartoon_${DateTime.now()}.png');
    // await storageRef.putFile();
  }

  final fireStore = FirebaseFirestore.instance;

  storeImage(Map<String, String> store) async {
    await fireStore.collection('cartoons').add(store).catchError((e, _) {
      print('Error--> $e');
    });
  }

  Stream<QuerySnapshot> collections = FirebaseFirestore.instance.collection('cartoons').snapshots();
}

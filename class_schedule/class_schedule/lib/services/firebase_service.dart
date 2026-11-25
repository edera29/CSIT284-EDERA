
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/class_session.dart';
import '../data/dummy_classes.dart';

class FirebaseService {
  final CollectionReference<Map<String, dynamic>> classes =
      FirebaseFirestore.instance.collection('classes');


  Future<void> seedClasses() async {
    final existing = await classes.limit(1).get();

    if (existing.docs.isNotEmpty) {
      return;
    }

    final batch = FirebaseFirestore.instance.batch();

    for (var item in dummyClasses) {
      batch.set(
        classes.doc(item.id),
        item.toMap(),
      );
    }

    await batch.commit();
  }


  Stream<List<ClassSession>> getClasses() {
    return classes.snapshots().map((snapshot) {
      return snapshot.docs.map<ClassSession>((doc) {
        return ClassSession.fromMap(
          doc.id,
          doc.data(),
        );
      }).toList();
    });
  }
}

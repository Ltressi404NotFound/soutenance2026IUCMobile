import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/carnet_model.dart';
class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Carnet>> getCarnetPatient(String uid) {
    return _db.collection('consultations')
        .where('patientId', isEqualTo: uid) // Filtre crucial
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Carnet.fromFirestore(doc.data(), doc.id))
            .toList());
  }

}
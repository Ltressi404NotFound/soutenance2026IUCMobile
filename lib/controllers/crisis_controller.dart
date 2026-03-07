import 'package:cloud_firestore/cloud_firestore.dart';

class CrisisController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fonction pour déclencher l'alerte
  Future<void> triggerEmergency(String patientUid) async {
    try {
      await _db.collection('utilisateurs').doc(patientUid).update({
        'isEmergency': true,
        'lastCrisisTime': FieldValue.serverTimestamp(),
      });
      print("Alerte envoyée à l'Hôpital de Loum");
    } catch (e) {
      print("Erreur : $e");
    }
  }
}
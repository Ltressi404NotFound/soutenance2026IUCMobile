import 'package:cloud_firestore/cloud_firestore.dart';
class Carnet {
  final String id;
  final String ordonnance;
  final String resultatsLabo;
  final DateTime date;
  final String nomPatient;

  Carnet({required this.id, required this.ordonnance, required this.resultatsLabo, required this.date, required this.nomPatient});

  factory Carnet.fromFirestore(Map<String, dynamic> data, String id) {
    return Carnet(
      id: id,
      ordonnance: data['ordonnance'] ?? '',
      resultatsLabo: data['résultatsLabo'] ?? '', // Attention à l'accent si présent dans Firestore
      date: (data['date'] as Timestamp).toDate(),
      nomPatient: data['nom du patient'] ?? 'Patient',
    );
  }
}
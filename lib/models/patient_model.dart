class PatientModel {
  String uid;
  String nom;
  String matricule;
  bool isEmergency; // Pour savoir si une crise est en cours

  PatientModel({required this.uid, required this.nom, required this.matricule, this.isEmergency = false});

  // Convertir les données Firebase (Map) en objet Patient
  factory PatientModel.fromMap(Map<String, dynamic> data) {
    return PatientModel(
      uid: data['uid'] ?? '',
      nom: data['nom'] ?? '',
      matricule: data['matricule'] ?? '',
      isEmergency: data['isEmergency'] ?? false,
    );
  }
}
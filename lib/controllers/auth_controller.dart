import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. INSCRIPTION D'UN PATIENT
  Future<String?> registerPatient({
    required String email,
    required String password,
    required String nom,
    required String telephone,
  }) async {
    try {
      // Création du compte dans Firebase Authentication
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      User? user = result.user;

      if (user != null) {
        // Enregistrement des données complémentaires dans Firestore
        await _db.collection('utilisateurs').doc(user.uid).set({
          'uid': user.uid,
          'nom': nom,
          'email': email.trim(),
          'telephone': telephone,
          'role': 'patient', // On force le rôle patient pour l'app mobile
          'createdAt': FieldValue.serverTimestamp(),
          'statut': 'Stable',
        });
        return null; // Succès
      }
    } on FirebaseAuthException catch (e) {
      // Gestion des erreurs spécifiques à Firebase
      if (e.code == 'email-already-in-use') return "Cet email est déjà utilisé.";
      if (e.code == 'weak-password') return "Le mot de passe est trop court.";
      return e.message;
    } catch (e) {
      return "Une erreur est survenue lors de l'inscription.";
    }
    return "Erreur inconnue.";
  }

  // 2. CONNEXION D'UN PATIENT
  Future<String?> loginPatient(String email, String password) async {
    try {
      // Tentative de connexion avec Auth
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (result.user != null) {
        // Vérification cruciale : est-ce que cet utilisateur existe dans Firestore 
        // et possède bien le rôle 'patient' ?
        DocumentSnapshot userDoc = await _db
            .collection('utilisateurs')
            .doc(result.user!.uid)
            .get();

        if (userDoc.exists) {
          String role = userDoc['role'];
          if (role == 'patient') {
            return null; // Tout est OK, accès autorisé
          } else {
            // Si c'est un admin ou un docteur, on lui refuse l'accès sur l'app mobile
            await _auth.signOut();
            return "Accès refusé : Utilisez l'interface Web pour ce compte.";
          }
        } else {
          return "Profil utilisateur introuvable dans la base de données.";
        }
      }
    } on FirebaseAuthException catch (e) {
      // Affichage du code dans la console pour le débogage (très utile pour toi !)
      print("FIREBASE ERROR CODE: ${e.code}");
      
      // En 2026, Firebase regroupe souvent les erreurs sous 'invalid-credential'
      if (e.code == 'invalid-credential' || e.code == 'user-not-found' || e.code == 'wrong-password') {
        return "Email ou mot de passe incorrect.";
      }
      if (e.code == 'network-request-failed') {
        return "Problème de connexion internet (ou DNS).";
      }
      return "Erreur : ${e.message}";
    } catch (e) {
      print("GENERAL ERROR: $e");
      return "Une erreur de connexion est survenue.";
    }
    return "Erreur de serveur.";
  }

  // 3. DÉCONNEXION
  Future<void> logout() async {
    await _auth.signOut();
  }

  // 4. RÉCUPÉRER LES INFOS DE L'UTILISATEUR ACTUEL
  Stream<DocumentSnapshot> getUserData() {
    String uid = _auth.currentUser!.uid;
    return _db.collection('utilisateurs').doc(uid).snapshots();
  }
}
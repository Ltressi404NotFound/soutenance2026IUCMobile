import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/translation_service.dart'; // Importe ton service

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _passController = TextEditingController();
  final TranslationService _trans = TranslationService();
  final user = FirebaseAuth.instance.currentUser;

  // Fonction pour changer le mot de passe sur Firebase
  void _updatePassword() async {
    try {
      await user!.updatePassword(_passController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_trans.t("pass_success")), backgroundColor: Colors.green),
      );
      _passController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_trans.t("pass_error")), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_trans.t("profile_title"))),
      body: FutureBuilder<DocumentSnapshot>(
        // Isolation : On ne récupère que le document de l'UID connecté
        future: FirebaseFirestore.instance.collection('utilisateurs').doc(user?.uid).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
                SizedBox(height: 10),
                Text(userData['nom'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(userData['email']),
                Divider(height: 40),

                // SECTION MOT DE PASSE
                Text(_trans.t("change_pass"), style: TextStyle(fontWeight: FontWeight.bold)),
                TextField(
                  controller: _passController,
                  decoration: InputDecoration(hintText: _trans.t("new_pass_hint")),
                  obscureText: true,
                ),
                ElevatedButton(onPressed: _updatePassword, child: Text(_trans.t("update_btn"))),

                Divider(height: 40),

                // SECTION LANGUE
                Text(_trans.t("lang_label"), style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => setState(() => TranslationService.lang = "FR"),
                      style: ElevatedButton.styleFrom(backgroundColor: TranslationService.lang == "FR" ? Colors.blue : Colors.grey),
                      child: Text("Français"),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => setState(() => TranslationService.lang = "EN"),
                      style: ElevatedButton.styleFrom(backgroundColor: TranslationService.lang == "EN" ? Colors.blue : Colors.grey),
                      child: Text("English"),
                    ),
                  ],
                ),

                SizedBox(height: 40),
                TextButton(
                  onPressed: () => FirebaseAuth.instance.signOut().then((_) => Navigator.pushReplacementNamed(context, '/')),
                  child: Text(_trans.t("logout"), style: TextStyle(color: Colors.red)),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
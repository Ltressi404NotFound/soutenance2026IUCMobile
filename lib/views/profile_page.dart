import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/translation_service.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _passController = TextEditingController();
  final TranslationService _trans = TranslationService();
  final user = FirebaseAuth.instance.currentUser;

  void _updatePassword() async {
    if (_passController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Le mot de passe doit faire au moins 6 caractères"), backgroundColor: Colors.orange),
      );
      return;
    }
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
      backgroundColor: Colors.grey[100], // Fond légèrement gris pour faire ressortir les cartes
      appBar: AppBar(
        title: Text(_trans.t("profile_title"), style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('utilisateurs').doc(user?.uid).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                // 1. HEADER PROFIL
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.blue[800],
                        child: CircleAvatar(
                          radius: 52,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, size: 60, color: Colors.blue[800]),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(userData['nom'] ?? 'Utilisateur', 
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
                      Text(userData['email'] ?? '', 
                        style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                    ],
                  ),
                ),

                // 2. CARTE MOT DE PASSE
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.lock_outline, color: Colors.blue[800]),
                            SizedBox(width: 10),
                            Text(_trans.t("change_pass"), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(height: 15),
                        TextField(
                          controller: _passController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: _trans.t("new_pass_hint"),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            prefixIcon: Icon(Icons.vpn_key),
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _updatePassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[800],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text(_trans.t("update_btn")),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 15),

                // 3. CARTE LANGUE
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.language, color: Colors.blue[800]),
                            SizedBox(width: 10),
                            Text(_trans.t("lang_label"), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(height: 10),
                        // INSTRUCTION AUTOMATIQUE
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            "⚠️ Pour appliquer la langue, veuillez redémarrer l'application après votre choix.",
                            style: TextStyle(fontSize: 12, color: Colors.blue[900], fontStyle: FontStyle.italic),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: ChoiceChip(
                                label: Center(child: Text("Français")),
                                selected: TranslationService.lang == "FR",
                                onSelected: (val) {
                                  setState(() => TranslationService.lang = "FR");
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: ChoiceChip(
                                label: Center(child: Text("English")),
                                selected: TranslationService.lang == "EN",
                                onSelected: (val) {
                                  setState(() => TranslationService.lang = "EN");
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 30),

                // 4. BOUTON DÉCONNEXION
                OutlinedButton.icon(
                  onPressed: () => FirebaseAuth.instance.signOut().then((_) => Navigator.pushReplacementNamed(context, '/')),
                  icon: Icon(Icons.logout, color: Colors.red),
                  label: Text(_trans.t("logout"), style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
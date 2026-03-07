import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool _isLoading = false;
  bool _obscureText = true;
  String? _errorMessage;

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() { _isLoading = true; _errorMessage = null; });

      String? result = await _authController.registerPatient(
        email: _emailController.text.trim(),
        password: _passController.text.trim(),
        nom: _nomController.text.trim(),
        telephone: _phoneController.text.trim(),
      );

      setState(() { _isLoading = false; });

      if (result == null) {
        Navigator.pushReplacementNamed(context, '/home'); 
      } else {
        setState(() { _errorMessage = result; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC), // Blanc cassé/neige très pro
      body: Stack(
        children: [
          // 1. Header avec Dégradé et Forme Courbe
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0056D2), Color(0xFF003D96)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(60),
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.person_add_rounded, size: 60, color: Colors.white),
                  ),
                  SizedBox(height: 15),
                  Text("Rejoindre FirstAid", 
                    style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: -1)),
                  Text("Créez votre profil patient en 1 minute", 
                    style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),

          // 2. Bouton Retour
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // 3. Formulaire Flottant
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(60)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: Offset(0, -10))
                ]
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(35),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      if (_errorMessage != null) _buildErrorBanner(),

                      _buildInput(_nomController, "Nom complet", Icons.person_outline),
                      SizedBox(height: 20),
                      _buildInput(_emailController, "Adresse Email", Icons.alternate_email_rounded),
                      SizedBox(height: 20),
                      _buildInput(_phoneController, "Téléphone", Icons.phone_android_rounded, type: TextInputType.phone),
                      SizedBox(height: 20),
                      _buildPasswordInput(),
                      
                      SizedBox(height: 40),

                      // Bouton d'inscription stylisé
                      _isLoading 
                        ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)))
                        : Container(
                            width: double.infinity,
                            height: 65,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF10B981).withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: Offset(0, 8),
                                )
                              ],
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF10B981),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                elevation: 0,
                              ),
                              onPressed: _handleRegister,
                              child: Text("CRÉER MON COMPTE", 
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1)),
                            ),
                          ),

                      SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Déjà inscrit ?", style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500)),
                          TextButton(
                            onPressed: () => Navigator.pushNamed(context, '/login'),
                            child: Text("Se connecter", 
                              style: TextStyle(color: Color(0xFF0056D2), fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget pour les inputs classiques
  Widget _buildInput(TextEditingController controller, String hint, IconData icon, {TextInputType type = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      validator: (val) => val!.isEmpty ? "Veuillez remplir ce champ" : null,
      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w500),
        prefixIcon: Icon(icon, color: Color(0xFF0056D2), size: 22),
        filled: true,
        fillColor: Color(0xFFF1F5F9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Color(0xFF0056D2), width: 2),
        ),
      ),
    );
  }

  // Widget spécifique pour le mot de passe (avec oeil)
  Widget _buildPasswordInput() {
    return TextFormField(
      controller: _passController,
      obscureText: _obscureText,
      validator: (val) => val!.length < 6 ? "Minimum 6 caractères" : null,
      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
      decoration: InputDecoration(
        labelText: "Mot de passe sécurisé",
        labelStyle: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w500),
        prefixIcon: Icon(Icons.lock_outline_rounded, color: Color(0xFF0056D2), size: 22),
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
          onPressed: () => setState(() => _obscureText = !_obscureText),
        ),
        filled: true,
        fillColor: Color(0xFFF1F5F9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Color(0xFF0056D2), width: 2),
        ),
      ),
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      margin: EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.red[100]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 20),
          SizedBox(width: 10),
          Expanded(child: Text(_errorMessage!, style: TextStyle(color: Colors.red[700], fontSize: 13, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}
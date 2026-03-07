import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool _isLoading = false;
  bool _obscureText = true;
  String? _errorMessage;

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() { _isLoading = true; _errorMessage = null; });

      String? result = await _authController.loginPatient(
        _emailController.text.trim(),
        _passController.text.trim(),
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
      backgroundColor: Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // 1. Fond de couleur avec courbe design
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xFF0056D2), Color(0xFF002D6B)],
              ),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(100),
              ),
            ),
          ),

          // 2. Contenu principal
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  // Logo & Titre
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 20)
                            ]
                          ),
                          child: Icon(Icons.local_hospital_rounded, size: 60, color: Color(0xFF10B981)),
                        ),
                        SizedBox(height: 25),
                        Text("BONRETOUR !", 
                          style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -1)),
                        Text("Connectez-vous à votre espace santé", 
                          style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),

                  SizedBox(height: 60),

                  // 3. Carte de Formulaire "Floating"
                  Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 30,
                          offset: Offset(0, 10),
                        )
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          if (_errorMessage != null) _buildErrorBanner(),
                          
                          _buildInputField(_emailController, "Email", Icons.alternate_email_rounded),
                          SizedBox(height: 20),
                          _buildPasswordField(),
                          
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: Text("Oublié ?", style: TextStyle(color: Color(0xFF0056D2), fontWeight: FontWeight.bold)),
                            ),
                          ),

                          SizedBox(height: 20),

                          _isLoading 
                            ? CircularProgressIndicator(color: Color(0xFF10B981))
                            : Container(
                                width: double.infinity,
                                height: 60,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF10B981),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    elevation: 8,
                                    shadowColor: Color(0xFF10B981).withOpacity(0.4),
                                  ),
                                  onPressed: _handleLogin,
                                  child: Text("SE CONNECTER", 
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                                ),
                              ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 40),

                  // 4. Footer
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/register'),
                      child: RichText(
                        text: TextSpan(
                          text: "Pas encore membre ? ",
                          style: TextStyle(color: Color(0xFF64748B), fontSize: 15),
                          children: [
                            TextSpan(
                              text: "Créer un compte", 
                              style: TextStyle(color: Color(0xFF0056D2), fontWeight: FontWeight.bold)
                            )
                          ]
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widgets réutilisables pour garder le code propre
  Widget _buildInputField(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      validator: (val) => val!.isEmpty ? "Champ obligatoire" : null,
      style: TextStyle(fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
        prefixIcon: Icon(icon, color: Color(0xFF0056D2)),
        filled: true,
        fillColor: Color(0xFFF1F5F9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Color(0xFF10B981), width: 2),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passController,
      obscureText: _obscureText,
      validator: (val) => val!.isEmpty ? "Champ obligatoire" : null,
      style: TextStyle(fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        labelText: "Mot de passe",
        labelStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
        prefixIcon: Icon(Icons.lock_person_rounded, color: Color(0xFF0056D2)),
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
          onPressed: () => setState(() => _obscureText = !_obscureText),
        ),
        filled: true,
        fillColor: Color(0xFFF1F5F9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Color(0xFF10B981), width: 2),
        ),
      ),
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
          SizedBox(width: 10),
          Expanded(child: Text(_errorMessage!, style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}
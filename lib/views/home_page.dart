import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/auth_controller.dart';
import '../services/translation_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = AuthController();
    final trans = Provider.of<TranslationService>(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // --- HEADER PREMIUM ---
          Container(
            padding: const EdgeInsets.only(top: 60, left: 30, right: 30, bottom: 40),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0056D2), Color(0xFF002D6B)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: const Icon(Icons.person, color: Colors.white, size: 30),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${trans.t('welcome')},",
                              style: const TextStyle(color: Colors.white70, fontSize: 16),
                            ),
                            Text(
                              user?.email?.split('@')[0].toUpperCase() ?? "Patient",
                              style: const TextStyle(
                                color: Colors.white, 
                                fontSize: 22, 
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.logout_rounded, color: Colors.white),
                        onPressed: () async {
                          await authController.logout();
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- BANNIÈRE D'URGENCE (LE POINT FORT) ---
                  _buildEmergencyBanner(context, trans),

                  const SizedBox(height: 35),
                  
                  Text(
                    "Services Médicaux",
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold, 
                      color: Color(0xFF1E293B),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- GRILLE DE SERVICES ---
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.9,
                    children: [
                      _buildServiceCard(
                        context,
                        "Gestes Secours",
                        Icons.health_and_safety_rounded,
                        const Color(0xFF10B981), // Vert Émeraude
                        '/firstaid_steps',
                        "Savoir réagir"
                      ),
                      _buildServiceCard(
                        context,
                        trans.t('chat_title'),
                        Icons.forum_rounded,
                        const Color(0xFF0056D2), // Bleu Royal
                        '/chat',
                        "IA & Docteurs"
                      ),
                      _buildServiceCard(
                        context,
                        "Carnet Médical",
                        Icons.local_hospital_rounded,
                        Colors.orangeAccent,
                        '/carnet',
                        "visiter votre carnet médical"
                      ),
                      _buildServiceCard(
                        context,
                        trans.t('profile_title'),
                        Icons.manage_accounts_rounded,
                        const Color(0xFF64748B), // Slate
                        '/profile',
                        "Mes données"
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // --- CONSEIL DU JOUR ---
                  _buildDailyTip(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget pour l'Urgence (doit être massif et rassurant)
  Widget _buildEmergencyBanner(BuildContext context, dynamic trans) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.red.withOpacity(0.1), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.red[50],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.campaign_rounded, color: Colors.redAccent, size: 40),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "BESOIN D'AIDE ?",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent, fontSize: 12),
                ),
                const Text(
                  "Urgence Immédiate",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1E293B)),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/emergency'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(15),
              elevation: 5,
            ),
            child: const Icon(Icons.phone_forwarded_rounded, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // Widget pour les cartes de services
  Widget _buildServiceCard(BuildContext context, String title, IconData icon, Color color, String route, String subtitle) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, size: 30, color: color),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B)),
            ),
            Text(
              subtitle,
              style: TextStyle(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyTip() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_circle, color: Colors.white, size: 40),
          const SizedBox(width: 15),
          const Expanded(
            child: Text(
              "Conseil : Restez hydraté et maintenez un cycle de sommeil régulier pour réduire les crises.",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
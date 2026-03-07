import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyPage extends StatelessWidget {
  const EmergencyPage({super.key});

  // Fonction pour lancer l'appel
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      }
    } catch (e) {
      debugPrint("Erreur d'appel : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1F2), // Fond rouge très pâle (alerte mais doux)
      appBar: AppBar(
        title: const Text("URGENCE SOS", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
        centerTitle: true,
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            // 1. Icône d'alerte animée (symbolique)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.red.withOpacity(0.2), blurRadius: 30, spreadRadius: 10)
                ],
              ),
              child: Icon(Icons.emergency_share_rounded, size: 80, color: Colors.red[700]),
            ),
            
            const SizedBox(height: 30),
            
            const Text(
              "Une urgence ?",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            const Text(
              "Appuyez sur un bouton pour contacter les secours immédiatement.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 50),

            // 2. LE GROS BOUTON SOS (Centralisé)
            _buildBigSOSButton(
              title: "APPEL D'URGENCE (112)",
              subtitle: "Numéro de secours universel",
              color: Colors.red[700]!,
              number: "112",
              icon: Icons.phone_forwarded_rounded
            ),

            const SizedBox(height: 20),

            // 3. AUTRES NUMÉROS UTILES (Spécifiques Loum/Cameroun)
            _buildSecondaryEmergencyCard(
              title: "SAMU",
              number: "119",
              icon: Icons.medical_services_rounded,
              color: const Color(0xFF0056D2)
            ),
            
            const SizedBox(height: 15),
            
            _buildSecondaryEmergencyCard(
              title: "Gendarmerie (Loum)",
              number: "113",
              icon: Icons.shield_rounded,
              color: const Color(0xFF0F172A)
            ),

            const SizedBox(height: 40),

            // 4. Message de réassurance
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700]),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Text(
                      "Votre position GPS peut être demandée par les secours pour vous localiser à Loum.",
                      style: TextStyle(fontSize: 12, color: Colors.blueGrey, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget pour le bouton principal
  Widget _buildBigSOSButton({required String title, required String subtitle, required Color color, required String number, required IconData icon}) {
    return GestureDetector(
      onTap: () => _makePhoneCall(number),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10))
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.phone_in_talk_rounded, color: Colors.white, size: 40),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  // Widget pour les boutons secondaires
  Widget _buildSecondaryEmergencyCard({required String title, required String number, required IconData icon, required Color color}) {
    return InkWell(
      onTap: () => _makePhoneCall(number),
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: color.withOpacity(0.2), width: 2),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(width: 20),
            Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
            const Spacer(),
            Text(number, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
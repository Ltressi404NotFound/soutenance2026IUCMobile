import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  // Fonction pour lancer les appels ou la carte
  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Impossible de lancer $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Urgence & Localisation", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0056b3),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Section Carte (Image cliquable vers Google Maps)
            GestureDetector(
              onTap: () => _launchURL("https://www.google.com/maps/search/?api=1&query=Hopital+de+District+de+Loum"),
              child: Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  image: const DecorationImage(
                    image: NetworkImage("https://maps.googleapis.com/maps/api/staticmap?center=Loum,Cameroon&zoom=15&size=600x300&key=TON_API_KEY"), // Ou une image asset
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on, color: Colors.red, size: 50),
                        Text("Ouvrir dans Google Maps", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Numéros d'Urgence", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w100, color: Color(0xFF0056b3))),
                  const Text("Cliquez sur un numéro pour appeler directement l'hôpital.", style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 20),

                  _buildContactCard(
                    title: "Orange Cameroun",
                    number: "690 12 34 56",
                    color: Colors.orange,
                    icon: Icons.phone_forwarded,
                    onTap: () => _launchURL("tel:+237690123456"),
                  ),
                  _buildContactCard(
                    title: "MTN Cameroon",
                    number: "670 11 22 33",
                    color: Colors.yellow[700]!,
                    icon: Icons.phone_forwarded,
                    onTap: () => _launchURL("tel:+237670112233"),
                  ),
                  _buildContactCard(
                    title: "Camtel (Fixe)",
                    number: "233 44 55 66",
                    color: Colors.blue,
                    icon: Icons.phone_in_talk,
                    onTap: () => _launchURL("tel:+237233445566"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({required String title, required String number, required Color color, required IconData icon, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(number, style: const TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.call, color: Color(0xFF28a745)),
        onTap: onTap,
      ),
    );
  }
}
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;
  String _selectedLang = "Français";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paramètres", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0056b3),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionTitle("Apparence"),
          _buildSettingTile(
            icon: Icons.dark_mode,
            title: "Mode Sombre",
            subtitle: "Réduire la fatigue oculaire",
            trailing: Switch(
              value: _isDarkMode,
              activeColor: const Color(0xFF28a745),
              onChanged: (val) {
                setState(() => _isDarkMode = val);
                // Ici tu appelleras la fonction toggleTheme de ton main.dart
              },
            ),
          ),
          
          const SizedBox(height: 30),
          _buildSectionTitle("Langue & Région"),
          _buildSettingTile(
            icon: Icons.translate,
            title: "Langue de l'application",
            subtitle: _selectedLang,
            onTap: _showLanguageDialog,
          ),

          const SizedBox(height: 30),
          _buildSectionTitle("Compte"),
          _buildSettingTile(
            icon: Icons.logout,
            title: "Déconnexion",
            subtitle: "Quitter votre session",
            color: Colors.red,
            onTap: () {
              // Logique de déconnexion Firebase
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Choisir la langue"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("Français"),
              leading: const Text("🇫🇷"),
              onTap: () {
                setState(() => _selectedLang = "Français");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("English"),
              leading: const Text("🇬🇧"),
              onTap: () {
                setState(() => _selectedLang = "English");
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 10),
      child: Text(title.toUpperCase(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[600])),
    );
  }

  Widget _buildSettingTile({required IconData icon, required String title, required String subtitle, Widget? trailing, VoidCallback? onTap, Color color = const Color(0xFF0056b3)}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: trailing ?? const Icon(Icons.chevron_right, size: 20),
      ),
    );
  }
}
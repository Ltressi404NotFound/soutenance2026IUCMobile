import 'package:flutter/material.dart';

class FirstAidPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gestes de Secours")),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          _stepCard(
            "1. Sécuriser l'espace",
            "Éloignez tout objet dangereux autour du patient pour éviter les blessures.",
            "assets/images/securiser.png"
          ),
          
          _stepCard(
            "2. Position Latérale de Sécurité (PLS)",
            "Si la personne est inconsciente mais respire, placez-la sur le côté.",
            "assets/images/pls.png"
          ),
          
          _stepCard(
            "3. Chronométrer",
            "Si la crise dure plus de 5 minutes, appelez immédiatement l'urgence.",
            "assets/images/timer.png"
          ),
        ],
      ),
    );
  }

  Widget _stepCard(String title, String desc, String imgPath) {
    return Card(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Image.asset(imgPath, height: 150, fit: BoxFit.cover),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                SizedBox(height: 5),
                Text(desc),
              ],
            ),
          )
        ],
      ),
    );
  }
}
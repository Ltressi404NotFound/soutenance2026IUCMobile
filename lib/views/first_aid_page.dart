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
            "https://www.chuv.ch/fileadmin/sites/nlg/images/nlg-epilepsie-examen.jpg"
          ),
          
          _stepCard(
            "2. Position Latérale de Sécurité (PLS)",
            "Si la personne est inconsciente mais respire, placez-la sur le côté.",
            "https://2.bp.blogspot.com/-IufKc77hLmA/UqHGizfSe2I/AAAAAAAADgQ/T07WqH5GZQE/s1600/54634874ym6.jpg"
          ),
          
          _stepCard(
            "3. Chronométrer",
            "Si la crise dure plus de 5 minutes, appelez immédiatement l'urgence.",
            "https://img.freepik.com/photos-gratuite/medecin-age-utilisant-tonometre-medical-pour-mesurer-pression-pulsee-hypertension-du-patient-effectuant-examen-cardiologie-dans-salle-attente-hopital-homme-age-assistant-visite-controle-notion-medecine_482257-69568.jpg"
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
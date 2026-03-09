import 'package:flutter/material.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Données pour le carrousel (Images stylisées du net)
  final List<Map<String, String>> onboardingData = [
    {
      "title": "Expertise Médicale",
      "desc": "Accédez aux meilleurs neurologues de l'Hôpital de District de Loum depuis votre mobile.",
      "image": "https://img.passeportsante.net/1200x675/2021-05-03/i103772-neurologie.webp",
    },
    {
      "title": "Gestes de Secours",
      "desc": "Apprenez à réagir immédiatement face à une crise grâce à nos guides interactifs.",
      "image": "https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&q=80&w=800",
    },
    {
      "title": "Suivi en Temps Réel",
      "desc": "Enregistrez vos crises et partagez votre journal de bord avec votre médecin traitant.",
      "image": "https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?auto=format&fit=crop&q=80&w=800",
    },
    {
      "title": "Communauté Unie",
      "desc": "L'épilepsie n'est pas une fatalité. Rejoignez une communauté qui vous soutient.",
      "image": "https://images.unsplash.com/photo-1511632765486-a01980e01a18?auto=format&fit=crop&q=80&w=800",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. CARROUSEL D'IMAGES
          PageView.builder(
            controller: _pageController,
            onPageChanged: (value) => setState(() => _currentPage = value),
            itemCount: onboardingData.length,
            itemBuilder: (context, index) => Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  onboardingData[index]['image']!,
                  fit: BoxFit.cover,
                ),
                // Dégradé sombre pour rendre le texte lisible
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. CONTENU TEXTUEL (FLOTTANT)
          SafeArea(
            child: Column(
              children: [
                // Logo en haut
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.add_moderator, color: Color(0xFF0056D2)),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "FirstAid LOUM",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),

                Spacer(),

                // Bloc d'info
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        onboardingData[_currentPage]['title']!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        onboardingData[_currentPage]['desc']!,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 40),

                      // Indicateurs de page (Dots)
                      Row(
                        children: List.generate(
                          onboardingData.length,
                          (index) => AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            margin: EdgeInsets.only(right: 8),
                            height: 6,
                            width: _currentPage == index ? 30 : 10,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? Color(0xFF10B981)
                                  : Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),

                      // Bouton Action
                      ElevatedButton(
                        onPressed: () {
                          if (_currentPage == onboardingData.length - 1) {
                            Navigator.pushNamed(context, '/register');
                          } else {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 65),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 10,
                          shadowColor: Color(0xFF10B981).withOpacity(0.4),
                        ),
                        child: Text(
                          _currentPage == onboardingData.length - 1
                              ? "COMMENCER L'AVENTURE"
                              : "SUIVANT",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      
                      // Bouton Sauter
                      if (_currentPage < onboardingData.length - 1)
                        Center(
                          child: TextButton(
                            onPressed: () => Navigator.pushNamed(context, '/register'),
                            child: Text(
                              "Passer l'introduction",
                              style: TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                          ),
                        ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
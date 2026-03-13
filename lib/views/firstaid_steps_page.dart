import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/translation_service.dart';

class FirstAidStepsPage extends StatelessWidget {
  const FirstAidStepsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final trans = Provider.of<TranslationService>(context);

    // Liste des gestes (Titre FR, Titre EN, Description FR, Description EN, Image URL)
    final List<Map<String, String>> steps = [
      {
        "titleFR": "1. Garder son calme", "titleEN": "1. Stay Calm",
        "descFR": "Ne paniquez pas, la crise s'arrêtera d'elle-même.", "descEN": "Do not panic, the seizure will end on its own.",
        "url": "https://img.freepik.com/vecteurs-libre/concept-meditation-design-plat_23-2147941785.jpg"
      },
      {
        "titleFR": "2. Chronométrer la crise", "titleEN": "2. Time the seizure",
        "descFR": "Notez l'heure de début. Si elle dure plus de 5 min, appelez l'urgence.", "descEN": "Note the start time. If it lasts more than 5 min, call emergency.",
        "url": "https://2.bp.blogspot.com/-IufKc77hLmA/UqHGizfSe2I/AAAAAAAADgQ/T07WqH5GZQE/s1600/54634874ym6.jpg"
      },
      {
        "titleFR": "3. Protéger la tête", "titleEN": "3. Protect the head",
        "descFR": "Placez quelque chose de souple sous sa tête.", "descEN": "Place something soft under their head.",
        "url": "https://img.freepik.com/photos-gratuite/medecin-age-utilisant-tonometre-medical-pour-mesurer-pression-pulsee-hypertension-du-patient-effectuant-examen-cardiologie-dans-salle-attente-hopital-homme-age-assistant-visite-controle-notion-medecine_482257-69568.jpg"
      },
      {
        "titleFR": "4. Écarter les objets", "titleEN": "4. Clear the area",
        "descFR": "Éloignez les meubles ou objets durs pour éviter les blessures.", "descEN": "Move furniture or hard objects away to avoid injury.",
        "url": "https://www.drkmst.de/assets/images/1/Arzt-Patient-Pflege_CHI-e8ca2784.jpg"
      },
      {
        "titleFR": "5. Ne rien mettre en bouche", "titleEN": "5. Nothing in mouth",
        "descFR": "N'essayez jamais de lui tenir la langue ou de mettre un objet.", "descEN": "Never try to hold the tongue or put an object in the mouth.",
        "url": "https://img.freepik.com/photos-premium/groupe-personnes-assises-dans-salle-attente-hopital-parlant-du-soutien-assurance-medicale-patients-masculins-attendant-assister-examen-discutant-traitement-medicament_482257-60766.jpg"
      },
      {
        "titleFR": "6. Ne pas retenir", "titleEN": "6. Do not restrain",
        "descFR": "Ne tentez pas de stopper ses mouvements saccadés.", "descEN": "Do not try to stop the jerky movements.",
        "url": "https://c8.alamy.com/compfr/2jwbb97/patiente-asiatique-assise-avec-des-jambes-relaxantes-et-un-tube-d-ecoulement-intraveineux-a-portee-de-main-a-l-hopital-en-noir-et-blanc-2jwbb97.jpg"
      },
      {
        "titleFR": "7. Desserrer les vêtements", "titleEN": "7. Loosen clothing",
        "descFR": "Ouvrez le col de chemise ou retirez les lunettes.", "descEN": "Open shirt collars or remove glasses.",
        "url": "https://cdn-icons-png.flaticon.com/512/3232/3232512.png"
      },
      {
        "titleFR": "8. Position Latérale (PLS)", "titleEN": "8. Recovery Position",
        "descFR": "À la fin des secousses, tournez la personne sur le côté.", "descEN": "After the shaking stops, turn the person on their side.",
        "url": "https://img.freepik.com/vecteurs-premium/premiers-secours-position-laterale-securite-illustration_611015-1033.jpg"
      },
      {
        "titleFR": "9. Libérer les voies", "titleEN": "9. Clear airway",
        "descFR": "Vérifiez que rien ne gêne sa respiration une fois sur le côté.", "descEN": "Ensure nothing blocks breathing once on their side.",
        "url": "https://o.quizlet.com/xFN96B.ippRwiMZUYvbXhg.png"
      },
      {
        "titleFR": "10. Rester présent", "titleEN": "10. Stay with them",
        "descFR": "Attendez qu'elle reprenne totalement ses esprits.", "descEN": "Wait until they are fully conscious.",
        "url": "https://img.freepik.com/photos-gratuite/medecin-praticien-afro-americain-debout-cote-jeune-patient-malade-lors-rendez-vous-medical-expliquant-expertise-radiographie-osseuse-dans-service-hospitalier-femme-medecin-discutant-expertise-soins-sante_482257-33629.jpg?size=626&ext=jpg"
      },
      {
        "titleFR": "11. Parler calmement", "titleEN": "11. Speak calmly",
        "descFR": "Rassurez la personne, elle peut être confuse au réveil.", "descEN": "Reassure the person, they may be confused upon waking.",
        "url": "https://media.istockphoto.com/id/1464381424/photo/sick-patient-standing-in-bed-while-african-american-physician-doctor-monitoring-heart-rate.jpg?s=170667a&w=0&k=20&c=2nEZ1rpNkDXm3utblplZ202KzdbFu2OsUgtHeqJfOlw="
      },
      {
        "titleFR": "12. Vérifier l'identité", "titleEN": "12. Check ID",
        "descFR": "Cherchez un bracelet ou une carte médicale d'épileptique.", "descEN": "Look for a medical ID bracelet or card.",
        "url": "https://embrlabs.com/cdn/shop/files/embr_wave_half_header_1920x540_hands.jpg?v=1702315417"
      },
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header Stylé
          SliverAppBar(
            expandedHeight: 150.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(trans.t('aid_title'), style: const TextStyle(fontWeight: FontWeight.bold)),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.green[800]!, Colors.green[400]!]),
                ),
              ),
            ),
          ),
          
          SliverPadding(
            padding: const EdgeInsets.all(15),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final step = steps[index];
                  bool isFR = TranslationService.lang == "FR";
                  
                  return _buildStepCard(
                    isFR ? step['titleFR']! : step['titleEN']!,
                    isFR ? step['descFR']! : step['descEN']!,
                    step['url']!,
                    index + 1,
                  );
                },
                childCount: steps.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard(String title, String desc, String imageUrl, int stepNumber) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE DEPUIS LE NET
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              // Gestion des erreurs de chargement (si pas d'internet)
              errorBuilder: (context, error, stackTrace) => Container(
                height: 200,
                color: Colors.grey[200],
                child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
              ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 200,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                );
              },
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.green[700],
                      radius: 15,
                      child: Text("$stepNumber", style: const TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(desc, style: TextStyle(color: Colors.grey[600], fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
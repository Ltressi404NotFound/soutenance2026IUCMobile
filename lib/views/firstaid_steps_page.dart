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
        "url": "https://cdn-icons-png.flaticon.com/512/3232/3232551.png"
      },
      {
        "titleFR": "3. Protéger la tête", "titleEN": "3. Protect the head",
        "descFR": "Placez quelque chose de souple sous sa tête.", "descEN": "Place something soft under their head.",
        "url": "https://www.croix-rouge.fr/var/ezflow_site/storage/images/media/images/ps-6-conduite-a-tenir/744081-1-fre-FR/PS-6-conduite-a-tenir_large.jpg"
      },
      {
        "titleFR": "4. Écarter les objets", "titleEN": "4. Clear the area",
        "descFR": "Éloignez les meubles ou objets durs pour éviter les blessures.", "descEN": "Move furniture or hard objects away to avoid injury.",
        "url": "https://cdn-icons-png.flaticon.com/512/1257/1257125.png"
      },
      {
        "titleFR": "5. Ne rien mettre en bouche", "titleEN": "5. Nothing in mouth",
        "descFR": "N'essayez jamais de lui tenir la langue ou de mettre un objet.", "descEN": "Never try to hold the tongue or put an object in the mouth.",
        "url": "https://cdn-icons-png.flaticon.com/512/3232/3232491.png"
      },
      {
        "titleFR": "6. Ne pas retenir", "titleEN": "6. Do not restrain",
        "descFR": "Ne tentez pas de stopper ses mouvements saccadés.", "descEN": "Do not try to stop the jerky movements.",
        "url": "https://cdn-icons-png.flaticon.com/512/3232/3232537.png"
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
        "url": "https://cdn-icons-png.flaticon.com/512/3232/3232525.png"
      },
      {
        "titleFR": "10. Rester présent", "titleEN": "10. Stay with them",
        "descFR": "Attendez qu'elle reprenne totalement ses esprits.", "descEN": "Wait until they are fully conscious.",
        "url": "https://cdn-icons-png.flaticon.com/512/3232/3232541.png"
      },
      {
        "titleFR": "11. Parler calmement", "titleEN": "11. Speak calmly",
        "descFR": "Rassurez la personne, elle peut être confuse au réveil.", "descEN": "Reassure the person, they may be confused upon waking.",
        "url": "https://cdn-icons-png.flaticon.com/512/3232/3232502.png"
      },
      {
        "titleFR": "12. Vérifier l'identité", "titleEN": "12. Check ID",
        "descFR": "Cherchez un bracelet ou une carte médicale d'épileptique.", "descEN": "Look for a medical ID bracelet or card.",
        "url": "https://cdn-icons-png.flaticon.com/512/3232/3232517.png"
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
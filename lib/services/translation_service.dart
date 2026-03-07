import 'package:flutter/material.dart';

class TranslationService extends ChangeNotifier {
  static String lang = "FR"; // Langue par défaut

  static final Map<String, Map<String, String>> _localizedValues = {
    "FR": {
      "profile_title": "Mon Profil",
      "change_pass": "Changer le mot de passe",
      "new_pass_hint": "Nouveau mot de passe",
      "update_btn": "Mettre à jour",
      "lang_label": "Langue de l'application",
      "logout": "Déconnexion",
      "pass_success": "Mot de passe modifié !",
      "pass_error": "Erreur : Reconnectez-vous avant de changer",
      "chat_title": "Discussion avec l'Hôpital",
      "chat_hint": "Écrivez votre message...",
      "send": "Envoyer",
      "aid_title": "Gestes qui Sauvent",
      "aid_intro": "En cas de crise d'épilepsie, suivez ces étapes :",

    },
    "EN": {
      "profile_title": "My Profile",
      "change_pass": "Change Password",
      "new_pass_hint": "New password",
      "update_btn": "Update Now",
      "lang_label": "App Language",
      "logout": "Logout",
      "pass_success": "Password updated!",
      "pass_error": "Error: Re-login required to change",
      "chat_title": "Chat with Hospital",
      "chat_hint": "Type your message...",
      "send": "Send",
      "aid_title": "First Aid Steps",
      "aid_intro": "During an epilepsy seizure, follow these steps:",
    }
  };

  String t(String key) => _localizedValues[lang]![key] ?? key;

  void toggleLanguage(String newLang) {
    lang = newLang;
    notifyListeners(); // Informe l'app qu'il faut redessiner les textes
  }
}
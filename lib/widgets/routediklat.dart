import 'package:flutter/material.dart';

// Import semua halaman
import 'package:inocare/screens/diklat_penelitian.dart';
import 'package:inocare/screens/kajietik_screen.dart';
import 'package:inocare/screens/kajiproposal_screen.dart';
import 'package:inocare/screens/preparat_screen.dart';

class AppRoutes {
  static void navigate(BuildContext context, String menu) {
    Widget page;

    switch (menu) {
      case "Pre Survey":
        page = const PreSurveyListScreen();
        break;
      case "Kaji Etik":
        page = const KajiEtikScreen();
        break;
      case "Kaji Proposal":
        page = const KajiProposalScreen();
        break;
      case "Penelitian":
        page = const PreSurveyListScreen();
        break;
      case "Preparat":
        page = const PreparatScreen();
        break;
      default:
        page = const PreSurveyListScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }
}

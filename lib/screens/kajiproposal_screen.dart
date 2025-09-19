import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'kajietik_screen.dart';
import 'preparat_screen.dart';
import 'kajiproposal_screen.dart';
import 'diklat_penelitian.dart';

class KajiProposalScreen extends StatefulWidget {
  const KajiProposalScreen({super.key});

  @override
  State<KajiProposalScreen> createState() => _KajiProposalScreenState();
}

class _KajiProposalScreenState extends State<KajiProposalScreen> {
  String selectedMenu = "Kaji Proposal";

  void _navigate(String menu) {
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
        page = const KajiProposalScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    final bool isSelected = selectedMenu == title;
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.blue : Colors.black54),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.blue : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Colors.blue.withOpacity(0.1),
      onTap: () {
        setState(() {
          selectedMenu = title;
        });
        _navigate(title);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kaji Proposal"),
        backgroundColor: const Color(0xFF1565C0),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF1565C0)),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ),
            _buildMenuItem(MdiIcons.featureSearchOutline, "Pre Survey"),
            _buildMenuItem(MdiIcons.bookEditOutline, "Kaji Etik"),
            _buildMenuItem(MdiIcons.fileDocumentEditOutline, "Kaji Proposal"),
            _buildMenuItem(MdiIcons.deskLampOn, "Penelitian"),
            _buildMenuItem(MdiIcons.cashMultiple, "Preparat"),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          "Halaman Kaji Proposal",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:inocare/screens/diklat_pelatihan.dart';
import 'package:inocare/screens/diklat_pendidikan.dart';
import 'package:inocare/screens/diklat_penelitian.dart';
import 'package:inocare/screens/lab.dart';
import 'package:inocare/screens/pegawai_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DiklatScreen extends StatelessWidget {
  const DiklatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {
        "title": "Master",
        "icon": MdiIcons.database,
        "page": const DummyPage(title:"master"),
      },
      {
        "title": "Petugas", 
        "icon": MdiIcons.accountGroup,
        "page": const PegawaiScreen()},
      {
        "title": "Penelitian",
        "icon": MdiIcons.deskLampOn,
        "page": const PreSurveyListScreen(),
      },
      {
        "title": "Pendidikan",         
        "icon": MdiIcons.handCoinOutline,
        "page": const DiklatPendidikanPage()},
      {
        "title": "Pelatihan",
        "icon": MdiIcons.bookOpenPageVariantOutline,
        "page": const DiklatPelatihanPage(),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu Diklat"),
        elevation: 0,
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // hitung jumlah kolom berdasarkan lebar layar
          int crossAxisCount =
              constraints.maxWidth < 600
                  ? 2 // HP
                  : constraints.maxWidth < 900
                  ? 3 // Tablet
                  : 4; // Desktop

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: menuItems.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1, // supaya kotak
            ),
            itemBuilder: (context, index) {
              final item = menuItems[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => item["page"]),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  color: Colors.blueGrey[50],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item["icon"], size: 40, color: Colors.blueGrey),
                      const SizedBox(height: 12),
                      Text(
                        item["title"],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
class DummyPage extends StatelessWidget {
  final String title;
  const DummyPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text("Ini halaman $title", style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
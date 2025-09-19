import 'package:flutter/material.dart';

class QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const QuickAccessCard({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 35),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class QuickAccessScreen extends StatefulWidget {
  const QuickAccessScreen({super.key});

  @override
  State<QuickAccessScreen> createState() => _QuickAccessScreenState();
}

class _QuickAccessScreenState extends State<QuickAccessScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Data asli
  final List<Map<String, dynamic>> _allCards = [
    {"icon": Icons.description, "label": "CPPT", "color": Colors.red},
    {"icon": Icons.medical_information, "label": "Diagnosa", "color": Colors.purple},
    {"icon": Icons.biotech, "label": "Lab", "color": Colors.blue},
    {"icon": Icons.waves, "label": "Radiologi", "color": Colors.indigo},
    {"icon": Icons.medication, "label": "Obat", "color": Colors.green},
  ];

  // Data hasil filter
  List<Map<String, dynamic>> _filteredCards = [];

  @override
  void initState() {
    super.initState();
    _filteredCards = _allCards; // awalnya tampil semua
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCards = _allCards.where((card) {
        final label = card["label"].toString().toLowerCase();
        return label.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quick Access")),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Cari menu...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Grid daftar card
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // jumlah kolom
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: _filteredCards.length,
              itemBuilder: (context, index) {
                final item = _filteredCards[index];
                return QuickAccessCard(
                  icon: item["icon"],
                  label: item["label"],
                  color: item["color"],
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Klik ${item['label']}")),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class BloodAvailabilityPage extends StatefulWidget {
  const BloodAvailabilityPage({super.key});

  @override
  State<BloodAvailabilityPage> createState() => _BloodAvailabilityPageState();
}

class _BloodAvailabilityPageState extends State<BloodAvailabilityPage> {
  bool _onlyAvailable = false;

  final List<BloodInfo> _bloods = [
    BloodInfo("A+", 2, "Tersedia", Colors.green),
    BloodInfo("A-", 2, "Tersedia", Colors.green),
    BloodInfo("B+", 2, "Tersedia", Colors.green),
    BloodInfo("B-", 2, "Tersedia", Colors.green),
    BloodInfo("AB+", 2, "Tersedia", Colors.green),
    BloodInfo("AB-", 2, "Tersedia", Colors.green),
    BloodInfo("O+", 2, "Tersedia", Colors.green),
    BloodInfo("O-", 2, "Tersedia", Colors.green),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredBloods = _onlyAvailable
        ? _bloods.where((b) => b.count > 0).toList()
        : _bloods;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: const [
            Text(
              "Ketersediaan Labu Darah",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            // Text(
            //   "RSUD Dr.H.ABDUL MOELOEK",
            //   style: TextStyle(
            //     fontSize: 12,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.black87,
            //   ),
            // ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.filter_list, color: Colors.black),
                    SizedBox(width: 6),
                    Text("Semua Tipe"),
                  ],
                ),
                Row(
                  children: [
                    const Text("Hanya Tersedia"),
                    Switch(
                      value: _onlyAvailable,
                      activeColor: Colors.orange,
                      onChanged: (val) {
                        setState(() {
                          _onlyAvailable = val;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Grid golongan darah
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: filteredBloods.length,
              itemBuilder: (context, index) {
                final blood = filteredBloods[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.grey[300],
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              blood.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Icon(
                              Icons.bloodtype,
                              color: Colors.red,
                              size: 26,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          blood.count.toString(),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          blood.status,
                          style: TextStyle(
                            color: blood.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: blood.count == 0 ? 0 : (blood.count / 3).clamp(0, 1),
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(blood.color),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Tombol pesan
          // Padding(
          //   padding: const EdgeInsets.all(16),
          //   child: SizedBox(
          //     width: double.infinity,
          //     height: 45,
          //     child: ElevatedButton(
          //       style: ElevatedButton.styleFrom(
          //         backgroundColor: Colors.grey[300],
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(30),
          //         ),
          //       ),
          //       onPressed: () {
          //         // Aksi ketika ditekan
          //         ScaffoldMessenger.of(context).showSnackBar(
          //           const SnackBar(content: Text("Fitur Pesan belum tersedia")),
          //         );
          //       },
          //       child: const Text(
          //         "Pesan",
          //         style: TextStyle(color: Colors.black),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class BloodInfo {
  final String title;
  final int count;
  final String status;
  final Color color;

  BloodInfo(this.title, this.count, this.status, this.color);
}

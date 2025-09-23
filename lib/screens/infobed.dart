import 'package:flutter/material.dart';
import 'package:inocare/screens/detailbed.dart';
import 'bed_info.dart';
class BedAvailabilityPage extends StatefulWidget {
  const BedAvailabilityPage({super.key});

  @override
  State<BedAvailabilityPage> createState() => _BedAvailabilityPageState();
}

class _BedAvailabilityPageState extends State<BedAvailabilityPage> {
  bool _onlyAvailable = false;

  final List<BedInfo> _beds = [
    BedInfo("VIP", 2, "Tersedia", Colors.green),
    BedInfo("Kelas 1", 2, "Tersedia", Colors.green),
    BedInfo("Kelas 2", 2, "Tersedia", Colors.green),
    BedInfo("Kelas 3", 1, "Terbatas", Colors.orange),
    BedInfo("ICU", 0, "Penuh", Colors.red),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredBeds =
        _onlyAvailable ? _beds.where((bed) => bed.count > 0).toList() : _beds;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2196F3)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          children: [
            Text(
              "Ketersediaan Bed",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            // Text(
            //   "RSUD Dr. H. ABDUL MOELOEK",
            //   style: TextStyle(
            //     fontSize: 12,
            //     fontWeight: FontWeight.w500,
            //     color: Colors.black54,
            //   ),
            // ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    "Total Bed",
                    _beds.fold(0, (sum, bed) => sum + bed.count).toString(),
                    const Color(0xFF2196F3),
                    Icons.hotel,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey[300],
                ),
                Expanded(
                  child: _buildStatItem(
                    "Tersedia",
                    _beds.where((bed) => bed.count > 0).length.toString(),
                    Colors.green,
                    Icons.check_circle,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey[300],
                ),
                Expanded(
                  child: _buildStatItem(
                    "Penuh",
                    _beds.where((bed) => bed.count == 0).length.toString(),
                    Colors.red,
                    Icons.cancel,
                  ),
                ),
              ],
            ),
          ),

          // Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.filter_list, color: Colors.black54),
                    SizedBox(width: 8),
                    Text(
                      "Semua Tipe",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Hanya Tersedia",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    Switch(
                      value: _onlyAvailable,
                      activeColor: const Color(0xFF2196F3),
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

          // Grid bed
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: filteredBeds.length,
              itemBuilder: (context, index) {
                final bed = filteredBeds[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BedDetailPage(bedInfo: bed),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Header with icon and title
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  bed.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: bed.color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.bed,
                                  color: bed.color,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Count
                          Text(
                            bed.count.toString(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: bed.color,
                            ),
                          ),
                          
                          const SizedBox(height: 4),
                          
                          // Status
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: bed.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              bed.status,
                              style: TextStyle(
                                color: bed.color,
                                fontWeight: FontWeight.w600,
                                fontSize: 8,
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // Progress indicator
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Okupansi",
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    "${((3 - bed.count) / 3 * 100).toInt()}%",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: bed.count == 0 ? 1.0 : (3 - bed.count) / 3,
                                  backgroundColor: Colors.grey[200],
                                  valueColor: AlwaysStoppedAnimation<Color>(bed.color),
                                  minHeight: 6,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

// class BedInfo {
//   final String title;
//   final int count;
//   final String status;
//   final Color color;

//   BedInfo(this.title, this.count, this.status, this.color);
// }

// Import untuk BedDetailPage - pastikan file ini tersedia
// class BedDetailPage extends StatelessWidget {
//   final BedInfo bedInfo;
  
//   const BedDetailPage({super.key, required this.bedInfo});

//   @override
//   Widget build(BuildContext context) {
//     // Placeholder implementation - ganti dengan implementasi sebenarnya dari BedDetailPage
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Detail ${bedInfo.title}'),
//         backgroundColor: const Color(0xFF2196F3),
//         foregroundColor: Colors.white,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.bed,
//               size: 64,
//               color: bedInfo.color,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               bedInfo.title,
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text(
//               '${bedInfo.count} beds available',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: bedInfo.color,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
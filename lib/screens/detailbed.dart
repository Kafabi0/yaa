import 'package:flutter/material.dart';
import 'bed_info.dart';

class BedDetailPage extends StatefulWidget {
  final BedInfo bedInfo;

  const BedDetailPage({super.key, required this.bedInfo});

  @override
  State<BedDetailPage> createState() => _BedDetailPageState();
}

class _BedDetailPageState extends State<BedDetailPage> {
  int selectedDays = 1;
  int currentImageIndex = 0;

  // Data dummy untuk detail
  Map<String, dynamic> get bedDetails => {
        'VIP': {
          'price': 800000,
          'facilities': [
            'Kamar pribadi dengan AC',
            'TV LCD 42 inch',
            'Kulkas mini',
            'Sofa untuk keluarga',
            'Kamar mandi pribadi',
            'WiFi gratis',
            'Layanan makanan premium',
          ],
          'images': [
            'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?w=400',
            'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
          ],
          'description':
              'Ruang VIP dengan fasilitas lengkap dan pelayanan premium untuk kenyamanan maksimal pasien dan keluarga.',
          'icon': Icons.diamond,
          'color': Color.fromARGB(255, 255, 139, 7),
        },
        'Kelas 1': {
          'price': 500000,
          'facilities': [
            'Kamar pribadi dengan AC',
            'TV LCD 32 inch',
            'Kamar mandi pribadi',
            'WiFi gratis',
            'Lemari pakaian',
            'Kursi untuk keluarga',
          ],
          'images': [
            'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
          ],
          'description':
              'Kamar kelas 1 dengan fasilitas nyaman dan privasi penuh untuk pemulihan yang optimal.',
          'icon': Icons.star,
          'color': Color(0xFF4CAF50),
        },
        'Kelas 2': {
          'price': 300000,
          'facilities': [
            'Kamar semi pribadi (2 bed)',
            'AC sentral',
            'TV bersama',
            'Kamar mandi bersama',
            'WiFi area',
            'Lemari kecil',
          ],
          'images': [
            'https://images.unsplash.com/photo-1538108149393-fbbd81895907?w=400',
          ],
          'description':
              'Kamar kelas 2 dengan fasilitas memadai dan suasana yang nyaman untuk pemulihan.',
          'icon': Icons.local_hotel,
          'color': Color(0xFF2196F3),
        },
        'Kelas 3': {
          'price': 150000,
          'facilities': [
            'Kamar bersama (4-6 bed)',
            'Kipas angin',
            'TV bersama',
            'Kamar mandi bersama',
            'Lemari bersama',
          ],
          'images': [
            'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400',
          ],
          'description':
              'Kamar kelas 3 dengan fasilitas dasar yang bersih dan nyaman dengan harga terjangkau.',
          'icon': Icons.bed,
          'color': Color(0xFF9E9E9E),
        },
        'ICU': {
          'price': 2000000,
          'facilities': [
            'Ruang perawatan intensif',
            'Monitor vital 24/7',
            'Ventilator',
            'Peralatan medis canggih',
            'Tim medis khusus',
            'Akses terbatas keluarga',
          ],
          'images': [
            'https://images.unsplash.com/photo-1559757175-0eb30cd8c063?w=400',
          ],
          'description':
              'Unit perawatan intensif dengan peralatan medis terdepan dan pengawasan medis 24 jam.',
          'icon': Icons.emergency,
          'color': Color(0xFFFF5722),
        },
      };

  @override
  Widget build(BuildContext context) {
    final details = bedDetails[widget.bedInfo.title] ?? {};
    final price = details['price'] ?? 0;
    final facilities = List<String>.from(details['facilities'] ?? []);
    final images = List<String>.from(details['images'] ?? []);
    final description = details['description'] ?? '';
    final icon = details['icon'] ?? Icons.bed;
    final color = details['color'] ?? Colors.blue;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Custom App Bar dengan gambar
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            backgroundColor: color,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  if (images.isNotEmpty)
                    PageView.builder(
                      itemCount: images.length,
                      onPageChanged: (index) {
                        setState(() {
                          currentImageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(images[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            color.withOpacity(0.7),
                            color,
                          ],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          icon,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                  // Image indicators
                  if (images.length > 1)
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: images.asMap().entries.map((entry) {
                          return Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: currentImageIndex == entry.key
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.5),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            icon,
                            color: color,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Ruang ${widget.bedInfo.title}",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green[100],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  "Tersedia",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Price Section
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color.withOpacity(0.1), Colors.white],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: color.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.monetization_on,
                            color: color,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Tarif per hari",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "Rp ${_formatCurrency(price)}",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Description Section
                    const Text(
                      "Deskripsi",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Text(
                        description,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Facilities Section
                    const Text(
                      "Fasilitas",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...facilities.map((facility) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              facility,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                    
                    const SizedBox(height: 32),
                    
                    // Book Now Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle booking
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Reservasi untuk Ruang ${widget.bedInfo.title} sedang diproses",
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          "Reservasi Sekarang",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildOrderCard(
                      title: 'Order Ambulance',
                      subtitle: '3 Ambulance Tersedia',
                      buttonText: 'Order Sekarang',
                      colors: [Colors.red[600]!, Colors.red[800]!],
                      icon: Icons.local_hospital,
                      image: 'ambulance',
                    ),
                    const SizedBox(height: 16),
                    _buildOrderCard(
                      title: 'Order Farmasi',
                      subtitle: '',
                      buttonText: 'Order Sekarang',
                      colors: [Colors.green[600]!, Colors.green[800]!],
                      icon: Icons.local_pharmacy,
                      image: 'pharmacy',
                    ),
                    const SizedBox(height: 16),
                    _buildOrderCard(
                      title: 'Order Lab',
                      subtitle: '',
                      buttonText: 'Cek Ketersediaan Lab',
                      colors: [Colors.blue[500]!, Colors.blue[700]!],
                      icon: Icons.science,
                      image: 'lab',
                    ),
                    const SizedBox(height: 16),
                    _buildOrderCard(
                      title: 'Order Radiologi',
                      subtitle: '',
                      buttonText: 'Cek Ketersediaan Radiologi',
                      colors: [Colors.grey[600]!, Colors.grey[800]!],
                      icon: Icons.medical_services,
                      image: 'radiology',
                    ),
                    const SizedBox(height: 16),
                    _buildOrderCard(
                      title: 'Order Forensik',
                      subtitle: '',
                      buttonText: 'Cek Ketersediaan Forensik',
                      colors: [Colors.indigo[600]!, Colors.indigo[800]!],
                      icon: Icons.fingerprint,
                      image: 'forensic',
                    ),
                    const SizedBox(height: 16),
                    _buildOrderCard(
                      title: 'Order UTDRS',
                      subtitle: '',
                      buttonText: 'Cek Ketersediaan UTDRS',
                      colors: [Colors.red[700]!, Colors.red[900]!],
                      icon: Icons.bloodtype,
                      image: 'blood',
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Order Services',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Cari Aja Dulu ...',
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildOrderCard({
    required String title,
    required String subtitle,
    required String buttonText,
    required List<Color> colors,
    required IconData icon,
    required String image,
  }) {
    return GestureDetector(
      onTap: () {
        _showOrderDialog(title);
      },
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colors[0].withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background decoration
            Positioned(
              right: -20,
              top: -10,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Main content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              buttonText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          icon,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Medical symbol decoration for specific cards
            if (title == 'Order Farmasi')
              Positioned(
                right: 10,
                top: 10,
                child: Icon(
                  FontAwesomeIcons.pills,
                  color: Colors.white.withOpacity(0.3),
                  size: 40,
                ),
              ),
            if (title == 'Order Lab')
              Positioned(
                right: 10,
                top: 10,
                child: Icon(
                  Icons.biotech,
                  color: Colors.white.withOpacity(0.3),
                  size: 40,
                ),
              ),
            if (title == 'Order Radiologi')
              Positioned(
                right: 10,
                top: 10,
                child: Icon(
                  FontAwesomeIcons.xRay,
                  color: Colors.white.withOpacity(0.3),
                  size: 40,
                ),
              ),
            if (title == 'Order Forensik')
              Positioned(
                right: 10,
                top: 10,
                child: Icon(
                  FontAwesomeIcons.magnifyingGlass,
                  color: Colors.white.withOpacity(0.3),
                  size: 40,
                ),
              ),
            if (title == 'Order UTDRS')
              Positioned(
                right: 10,
                top: 10,
                child: Icon(
                  FontAwesomeIcons.droplet,
                  color: Colors.white.withOpacity(0.3),
                  size: 40,
                ),
              ),
            if (title == 'Order Ambulance')
              Positioned(
                right: 10,
                top: 10,
                child: Icon(
                  FontAwesomeIcons.truckMedical,
                  color: Colors.white.withOpacity(0.3),
                  size: 40,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showOrderDialog(String serviceType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.medical_services,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  serviceType,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Apakah Anda ingin melanjutkan order untuk layanan $serviceType?',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange[700], size: 20),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Layanan ini akan segera tersedia',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Batal',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showSuccessSnackbar(serviceType);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Lanjutkan',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessSnackbar(String serviceType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text('Order $serviceType berhasil dibuat!'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
import 'package:flutter/material.dart';

class OrderAmbulancePage extends StatefulWidget {
  const OrderAmbulancePage({Key? key}) : super(key: key);

  @override
  State<OrderAmbulancePage> createState() => _OrderAmbulancePageState();
}

class _OrderAmbulancePageState extends State<OrderAmbulancePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  String? _selectedAmbulanceType;
  final List<String> ambulanceTypes = [
    "Basic Life Support (BLS)",
    "Advanced Life Support (ALS)",
    "Neonatal Ambulance",
    "Ambulance Jenazah"
  ];

  int availableAmbulances = 3; // contoh data statis

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double fontScale = (screenWidth / 400).clamp(0.8, 1.2);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Ambulance"),
        backgroundColor: Colors.red[700],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20 * fontScale),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info ketersediaan
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16 * fontScale),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.local_hospital,
                          color: Colors.red, size: 32),
                      const SizedBox(width: 12),
                      Text(
                        "$availableAmbulances Ambulance tersedia",
                        style: TextStyle(
                          fontSize: 16 * fontScale,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[800],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Dropdown jenis ambulance
                Text(
                  "Pilih Jenis Ambulance",
                  style: TextStyle(
                    fontSize: 14 * fontScale,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedAmbulanceType,
                  items: ambulanceTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedAmbulanceType = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? "Silakan pilih jenis ambulance" : null,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Lokasi penjemputan
                Text(
                  "Lokasi Penjemputan",
                  style: TextStyle(
                    fontSize: 14 * fontScale,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _pickupController,
                  validator: (val) =>
                      val == null || val.isEmpty ? "Masukkan lokasi penjemputan" : null,
                  decoration: InputDecoration(
                    hintText: "Contoh: Jalan Merdeka No. 10",
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.location_on),
                  ),
                ),
                const SizedBox(height: 20),

                // Lokasi tujuan
                Text(
                  "Lokasi Tujuan",
                  style: TextStyle(
                    fontSize: 14 * fontScale,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _destinationController,
                  validator: (val) =>
                      val == null || val.isEmpty ? "Masukkan lokasi tujuan" : null,
                  decoration: InputDecoration(
                    hintText: "Contoh: RSUD Kota Bandung",
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.local_hospital),
                  ),
                ),
                const SizedBox(height: 30),

                // Tombol order
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _confirmOrder();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[700],
                      padding: EdgeInsets.symmetric(
                        vertical: 14 * fontScale,
                        horizontal: 20 * fontScale,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.check, color: Colors.white),
                    label: Text(
                      "Konfirmasi Order",
                      style: TextStyle(
                        fontSize: 16 * fontScale,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmOrder() {
    Navigator.pop(context); // kembali ke halaman sebelumnya
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              "Order Ambulance (${_selectedAmbulanceType ?? ''}) berhasil!",
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _destinationController.dispose();
    super.dispose();
  }
}

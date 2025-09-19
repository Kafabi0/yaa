import 'package:flutter/material.dart';
import '../models/pasien_transaksi.dart';
import '../widgets/pasien_service.dart';
import 'pasien_profile_page.dart';

class PasienSelectionPage extends StatefulWidget {
  const PasienSelectionPage({Key? key}) : super(key: key);

  @override
  State<PasienSelectionPage> createState() => _PasienSelectionPageState();
}

class _PasienSelectionPageState extends State<PasienSelectionPage> {
  List<Pasien> pasienList = [];
  List<Pasien> filteredPasienList = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  final String baseUrl = "http://192.168.1.38:8080/";

  @override
  void initState() {
    super.initState();
    _loadPasienList();
    _searchController.addListener(_filterPasien);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPasienList() async {
    try {
      final data = await PasienService.getAllPasien();
      setState(() {
        pasienList = data;
        filteredPasienList = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal memuat daftar pasien: $e"),
          backgroundColor: Colors.red[600],
        ),
      );
    }
  }

  void _filterPasien() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredPasienList = pasienList.where((pasien) {
        return pasien.name.toLowerCase().contains(query) ||
               pasien.nik.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });
    await _loadPasienList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Pilih Pasien"),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.blue[600],
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Cari nama atau NIK pasien...",
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text("Memuat data pasien..."),
                      ],
                    ),
                  )
                : filteredPasienList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _searchController.text.isNotEmpty 
                                  ? Icons.search_off
                                  : Icons.people_outline,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchController.text.isNotEmpty
                                  ? "Tidak ada pasien yang sesuai pencarian"
                                  : "Tidak ada pasien terdaftar",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            if (_searchController.text.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () {
                                  _searchController.clear();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[600],
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text("Reset Pencarian"),
                              ),
                            ],
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _refreshData,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredPasienList.length,
                          itemBuilder: (context, index) {
                            final pasien = filteredPasienList[index];
                            final fotoUrl = pasien.foto.isNotEmpty
                                ? (pasien.foto.startsWith("http")
                                    ? pasien.foto
                                    : "$baseUrl${pasien.foto.replaceAll("\\", "/")}")
                                : "";

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                leading: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.blue[200]!,
                                      width: 2,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: fotoUrl.isNotEmpty
                                        ? NetworkImage(fotoUrl)
                                        : const AssetImage("assets/nailong.png")
                                            as ImageProvider,
                                  ),
                                ),
                                title: Text(
                                  pasien.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.badge,
                                          size: 16,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          pasien.nik,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (pasien.jenisKelamin.isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Icon(
                                            pasien.jenisKelamin.toLowerCase() == 'laki-laki'
                                                ? Icons.male
                                                : Icons.female,
                                            size: 16,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            pasien.jenisKelamin,
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: Colors.blue[600],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PasienProfilePage(
                                        pasienId: pasien.id!,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
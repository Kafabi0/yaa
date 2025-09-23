import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/pasien_transaksi.dart';
import '../widgets/transaksi_service.dart';
import '../widgets/pasien_service.dart';

class InputTransaksiPage extends StatefulWidget {
  const InputTransaksiPage({super.key});

  @override
  State<InputTransaksiPage> createState() => _InputTransaksiPageState();
}

class _InputTransaksiPageState extends State<InputTransaksiPage> {
  final _formKey = GlobalKey<FormState>();
  List<Pasien> pasienList = [];
  int? selectedPasienId;
  final TextEditingController _totalController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchPasien();
  }

  Future<void> fetchPasien() async {
    try {
      pasienList = await PasienService.getAllPasien();
      // Jangan set otomatis -> biar user pilih
      selectedPasienId = null;
    } catch (e) {
      debugPrint("Error fetching pasien: $e");
    }
    setState(() => loading = false);
  }

  Future<void> submitTransaksi() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedPasienId == null) return;

    final formattedDate =
        DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
        ).toUtc().toIso8601String();

    final transaksi = {
      "pasien_id": selectedPasienId,
      "total": int.parse(_totalController.text),
      "tanggal_transaksi": formattedDate,
    };

    try {
      await TransaksiService.createTransaksi(transaksi);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Transaksi berhasil ditambahkan"),
          backgroundColor: Colors.green,
        ),
      );
      _totalController.clear();
      setState(() => selectedDate = DateTime.now());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal menambahkan transaksi: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      setState(() => selectedDate = date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Input Transaksi Pasien",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body:
          loading
              ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade600, Colors.blue.shade400],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "Transaksi Baru",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Lengkapi form di bawah untuk menambahkan transaksi baru",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Form Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Section: Pilih Pasien
                            const Text(
                              "Data Pasien",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                                color: Colors.grey.shade50,
                              ),
                              child: DropdownButtonFormField<int>(
                                value:
                                    pasienList.any(
                                          (p) => p.id == selectedPasienId,
                                        )
                                        ? selectedPasienId
                                        : null,
                                items:
                                    pasienList
                                        .map(
                                          (p) => DropdownMenuItem(
                                            value: p.id,
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 8,
                                                  height: 8,
                                                  decoration:
                                                      const BoxDecoration(
                                                        color: Colors.green,
                                                        shape: BoxShape.circle,
                                                      ),
                                                ),
                                                const SizedBox(width: 12),
                                                Text(
                                                  p.name,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList(),
                                onChanged: (value) {
                                  setState(() => selectedPasienId = value);
                                },
                                decoration: InputDecoration(
                                  labelText: "Pilih Pasien",
                                  labelStyle: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.person_outline,
                                    color: Colors.grey.shade600,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                                dropdownColor: Colors.white,
                                validator: (value) {
                                  if (value == null) {
                                    return "Pilih pasien terlebih dahulu";
                                  }
                                  return null;
                                },
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Section: Jumlah Transaksi
                            const Text(
                              "Detail Transaksi",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                                color: Colors.grey.shade50,
                              ),
                              child: TextFormField(
                                controller: _totalController,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  labelText: "Jumlah Transaksi",
                                  labelStyle: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.attach_money,
                                    color: Colors.grey.shade600,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Masukkan jumlah transaksi";
                                  }
                                  if (int.tryParse(value) == null) {
                                    return "Harus berupa angka";
                                  }
                                  return null;
                                },
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Section: Tanggal
                            const Text(
                              "Tanggal Transaksi",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                                color: Colors.grey.shade50,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    color: Colors.grey.shade600,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      DateFormat(
                                        'EEEE, dd MMMM yyyy',
                                        'id_ID',
                                      ).format(selectedDate),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: InkWell(
                                      onTap: pickDate,
                                      child: Text(
                                        "Ubah",
                                        style: TextStyle(
                                          color: Colors.blue.shade700,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Submit Button
                            Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.shade600,
                                    Colors.blue.shade400,
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: submitTransaksi,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.save_outlined,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Simpan Transaksi",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
    );
  }
}

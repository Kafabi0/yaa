import 'package:flutter/material.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.blue[50],
    appBar: AppBar(
      title: const Text(
        'Form Detail',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      backgroundColor: Colors.blue[700],
      elevation: 2,
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // === FORM FILTER 2 KOLOM SELALU ===
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Row 1: Kode & Unit Farmasi
                Row(
                  children: [
                    Expanded(child: _buildTextField(context, "Kode", "20250731143058")),
                    const SizedBox(width: 12),
                    Expanded(child: _buildDropdown(context, "Unit Farmasi", ["Gudang", "Apotek"], "Gudang")),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Row 2: Tanggal Pelaksanaan & Bulan Stock Opname
                Row(
                  children: [
                    Expanded(child: _buildTextField(context, "Tanggal Pelaksanaan", "31-07-2025")),
                    const SizedBox(width: 12),
                    Expanded(child: _buildDropdown(context, "Bulan Stock Opname", ["Januari", "Februari", "Juli"], "Juli")),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Row 3: Tahun Stock Opname & Tipe Petugas
                Row(
                  children: [
                    Expanded(child: _buildDropdown(context, "Tahun Stock Opname", ["2024", "2025"], "2025")),
                    const SizedBox(width: 12),
                    Expanded(child: _buildDropdown(context, "Tipe Petugas", ["Staff", "Admin"], "Staff")),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Row 4: Petugas & Field Kosong
                Row(
                  children: [
                    Expanded(child: _buildTextField(context, "Petugas", "Diana Aprilia")),
                    const SizedBox(width: 12),
                    Expanded(child: Container()), // Field kosong untuk menjaga 2 kolom
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // === TABEL SECTION RESPONSIF ===
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                // desktop → tabel berdampingan
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildTableCard(
                        title: "Stok Barang Gudang",
                        table: _buildGudangTable(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTableCard(
                        title: "Stok Opname",
                        table: _buildOpnameTable(),
                      ),
                    ),
                  ],
                );
              } else {
                // mobile → tabel vertikal
                return Column(
                  children: [
                    _buildTableCard(
                      title: "Stok Barang Gudang",
                      table: _buildGudangTable(),
                    ),
                    const SizedBox(height: 20),
                    _buildTableCard(
                      title: "Stok Opname",
                      table: _buildOpnameTable(),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    ),
  );
}

  // Widget untuk card tabel
  Widget _buildTableCard({required String title, required Widget table}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 12),
          _buildSearchField(),
          const SizedBox(height: 12),
          table,
        ],
      ),
    );
  }

  // === WIDGET FORM ===
  Widget _buildTextField(BuildContext context, String label, String value) {
    return SizedBox(
      width: MediaQuery.of(context).size.width > 600 ? 250 : 180,
      child: TextFormField(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.blue[700]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
          ),
          filled: true,
          fillColor: Colors.blue[50],
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        ),
      ),
    );
  }

  Widget _buildDropdown(BuildContext context, String label, List<String> items, String selected) {
    return SizedBox(
      width: MediaQuery.of(context).size.width > 600 ? 250 : 180,
      child: DropdownButtonFormField<String>(
        value: selected,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.blue[700]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
          ),
          filled: true,
          fillColor: Colors.blue[50],
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        ),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (v) {},
      ),
    );
  }

  Widget _buildSearchField() {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, size: 18, color: Colors.blue[700]),
          hintText: "Cari",
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
          ),
          filled: true,
          fillColor: Colors.blue[50],
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        ),
      ),
    );
  }

  // === TABEL GUDANG ===
  Widget _buildGudangTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        border: TableBorder.all(color: Colors.grey.shade300),
        defaultColumnWidth: const IntrinsicColumnWidth(),
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: Colors.blue[700],
            ),
            children: const [
              _tableHeaderCell("No"),
              _tableHeaderCell("Nama"),
              _tableHeaderCell("Kelompok"),
              _tableHeaderCell("Golongan"),
              _tableHeaderCell("Stok"),
              _tableHeaderCell("Tanggal Kadaluarsa"),
            ],
          ),
          // Data dummy sesuai gambar
          _buildGudangTableRow("1", "Test Programmer Barang Farmasi", "Alat Kesehatan", "BHP", "10", "31-12-2025", true),
          _buildGudangTableRow("2", "SLIT KNIFE 15 DEGR.", "Alat Kesehatan", "BHP", "5", "31-12-2025", false),
          _buildGudangTableRow("3", "CONTAINER URINE", "Alat Kesehatan", "BHP", "20", "31-12-2025", true),
          _buildGudangTableRow("4", "GLOVE EXAMINATION", "Alat Kesehatan", "BHP", "50", "31-12-2025", false),
        ],
      ),
    );
  }

  TableRow _buildGudangTableRow(String no, String nama, String kelompok, String golongan, String stok, String tanggal, bool isEven) {
    return TableRow(
      decoration: BoxDecoration(
        color: isEven ? Colors.blue[50] : Colors.white,
      ),
      children: [
        _tableCell(no),
        _tableCell(nama),
        _tableCell(kelompok),
        _tableCell(golongan),
        _tableCell(stok, isBold: true),
        _tableCell(tanggal),
      ],
    );
  }

  // === TABEL OPNAME ===
  Widget _buildOpnameTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        border: TableBorder.all(color: Colors.grey.shade300),
        defaultColumnWidth: const IntrinsicColumnWidth(),
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: Colors.blue[700],
            ),
            children: const [
              _tableHeaderCell("No"),
              _tableHeaderCell("Obat"),
              _tableHeaderCell("Kelompok"),
              _tableHeaderCell("Golongan"),
              _tableHeaderCell("Stok"),
              _tableHeaderCell("Baik"),
              _tableHeaderCell("Rusak"),
              _tableHeaderCell("Kadaluarsa"),
              _tableHeaderCell("Tidak Diketahui"),
              _tableHeaderCell("Selisih"),
              _tableHeaderCell("Status"),
            ],
          ),
          // Data dummy sesuai gambar
          _buildOpnameTableRow("1", "CYCLOSERIN 250-", "Obat", "OBAT", "100", "100", "0", "0", "0", "0", "Disimpan", Colors.green, true),
          _buildOpnameTableRow("2", "VITAMIN B6 100 M.", "Obat", "OBAT", "200", "200", "0", "0", "0", "0", "Disimpan", Colors.green, false),
          _buildOpnameTableRow("3", "PARACETAMOL 500MG", "Obat", "OBAT", "500", "500", "0", "0", "0", "0", "Disimpan", Colors.green, true),
        ],
      ),
    );
  }

  TableRow _buildOpnameTableRow(String no, String obat, String kelompok, String golongan, String stok, 
      String baik, String rusak, String kadaluarsa, String tidakDiketahui, String selisih, 
      String status, Color statusColor, bool isEven) {
    return TableRow(
      decoration: BoxDecoration(
        color: isEven ? Colors.blue[50] : Colors.white,
      ),
      children: [
        _tableCell(no),
        _tableCell(obat),
        _tableCell(kelompok),
        _tableCell(golongan),
        _tableCell(stok, isBold: true),
        _tableCellField(baik),
        _tableCellField(rusak),
        _tableCellField(kadaluarsa),
        _tableCellField(tidakDiketahui),
        _tableCell(selisih, isBold: true),
        _tableStatusCell(status, statusColor),
      ],
    );
  }
}

// === REUSABLE CELL ===
class _tableCell extends StatelessWidget {
  final String text;
  final bool isBold;
  const _tableCell(this.text, {this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: Colors.grey[800],
        ),
      ),
    );
  }
}

class _tableHeaderCell extends StatelessWidget {
  final String text;
  const _tableHeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _tableCellField extends StatelessWidget {
  final String value;
  const _tableCellField(this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: TextFormField(
        initialValue: value,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.blue[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.blue[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
          ),
          filled: true,
          fillColor: Colors.blue[50],
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        ),
      ),
    );
  }
}

class _tableStatusCell extends StatelessWidget {
  final String label;
  final Color color;
  const _tableStatusCell(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
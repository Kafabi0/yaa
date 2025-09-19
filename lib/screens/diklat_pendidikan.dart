import 'package:flutter/material.dart';

class DiklatPendidikanPage extends StatelessWidget {
  const DiklatPendidikanPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data
    final List<Map<String, dynamic>> dataPeserta = [
      {
        "no": 1,
        "id": "20250529144337",
        "bagian": "SARAF",
        "minggu": 2,
        "jumlahPeserta": 150,
        "inputPeserta": 2,
        "kirimKasir": true,
        "statusBayar": true,
      },
      {
        "no": 2,
        "id": "20250529143446",
        "bagian": "OBGYN",
        "minggu": 3,
        "jumlahPeserta": 150,
        "inputPeserta": 3,
        "kirimKasir": true,
        "statusBayar": true,
      },
    ];

    // 🔹 Hitung total
    final int totalPeserta =
        dataPeserta.fold(0, (sum, item) => sum + (item["jumlahPeserta"] as int));
    final int totalInputPeserta =
        dataPeserta.fold(0, (sum, item) => sum + (item["inputPeserta"] as int));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pendidikan"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Header informasi
            Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Bagian Program Pendidikan Dokter (PPD)",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text("Perihal: PPD MEI"),
                    Text("Periode: 2025-05-01"),
                    Text("Total Peserta: 300"),
                  ],
                ),
              ),
            ),

            // 🔹 Tombol refresh & tambah
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.refresh),
                  label: const Text("Refresh Data"),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text("Tambah"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 🔹 Tabel data
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                border: TableBorder.all(color: Colors.grey.shade300),
                columns: const [
                  DataColumn(label: Text("No")),
                  DataColumn(label: Text("ID")),
                  DataColumn(label: Text("Bagian")),
                  DataColumn(label: Text("Minggu")),
                  DataColumn(label: Text("Jumlah Peserta")),
                  DataColumn(label: Text("Jumlah Input Peserta")),
                  DataColumn(label: Text("Kirim Kasir")),
                  DataColumn(label: Text("Status Bayar")),
                  DataColumn(label: Text("Action")),
                ],
                rows: [
                  // 🔹 Baris data
                  ...dataPeserta.map((item) {
                    return DataRow(cells: [
                      DataCell(Text(item["no"].toString())),
                      DataCell(Text(item["id"])),
                      DataCell(Text(item["bagian"])),
                      DataCell(Text(item["minggu"].toString())),
                      DataCell(Text(item["jumlahPeserta"].toString())),
                      DataCell(
                        Text(
                          item["inputPeserta"].toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataCell(
                        Chip(
                          label: const Text("Sudah Kirim",
                              style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.teal,
                        ),
                      ),
                      DataCell(
                        Chip(
                          label: const Text("Lunas",
                              style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.green,
                        ),
                      ),
                      DataCell(Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white),
                            child: const Text("Detail"),
                          ),
                          const SizedBox(width: 4),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                foregroundColor: Colors.white),
                            child: const Text("Peserta"),
                          ),
                          const SizedBox(width: 4),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white),
                            child: const Text("Billing"),
                          ),
                        ],
                      )),
                    ]);
                  }).toList(),

                  // 🔹 Baris total + Cetak Bagian di kolom Action
                  DataRow(cells: [
                    const DataCell(SizedBox()), // No
                    const DataCell(SizedBox()), // ID
                    const DataCell(SizedBox()), // Bagian
                    const DataCell(SizedBox()), // Minggu
                    DataCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            totalPeserta.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.blue),
                          ),
                          const Text("(Total Peserta)",
                              style: TextStyle(
                                  fontSize: 11, fontStyle: FontStyle.italic)),
                        ],
                      ),
                    ),
                    DataCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            totalInputPeserta.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.blue),
                          ),
                          const Text("(Total Input Peserta)",
                              style: TextStyle(
                                  fontSize: 11, fontStyle: FontStyle.italic)),
                        ],
                      ),
                    ),
                    const DataCell(SizedBox()), // Kirim Kasir
                    const DataCell(SizedBox()), // Status Bayar
                    DataCell(
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.print),
                          label: const Text("Cetak Bagian"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ), // Action
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

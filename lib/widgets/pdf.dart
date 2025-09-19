// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// class PdfExamplePage extends StatelessWidget {
//   const PdfExamplePage({super.key});

//   Future<pw.Document> _generatePdf(List<Map<String, dynamic>> data) async {
//     final pdf = pw.Document();

//     final logo = await imageFromAssetBundle('assets/images/logo_rs.png');
//     final tandaTangan = await imageFromAssetBundle('assets/images/ttd.png');

//     pdf.addPage(
//       pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         build: (context) => [
//           // Header dengan logo
//           pw.Row(
//             crossAxisAlignment: pw.CrossAxisAlignment.center,
//             mainAxisAlignment: pw.MainAxisAlignment.start,
//             children: [
//               pw.Image(logo, width: 60, height: 60),
//               pw.SizedBox(width: 15),
//               pw.Column(
//                 crossAxisAlignment: pw.CrossAxisAlignment.start,
//                 children: [
//                   pw.Text(
//                     "RUMAH SAKIT INOCARE",
//                     style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
//                   ),
//                   pw.Text("Jl. Sehat No. 123, Jakarta", style: pw.TextStyle(fontSize: 10)),
//                   pw.Text("Telp: (021) 123456 – Email: info@inocare.com",
//                       style: pw.TextStyle(fontSize: 10)),
//                 ],
//               ),
//             ],
//           ),
//           pw.Divider(),
//           pw.SizedBox(height: 20),

//           pw.Center(
//             child: pw.Text(
//               "LAPORAN PEMERIKSAAN LAB PATOLOGI ANATOMI",
//               style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
//             ),
//           ),
//           pw.SizedBox(height: 20),

//           pw.Table.fromTextArray(
//             headers: [
//               "No",
//               "Jenis Pemeriksaan",
//               "Umum",
//               "JKN Non PBI",
//               "JKN PBI",
//               "Jamkesda",
//               "Pemda",
//               "Asuransi",
//               "Covid",
//               "Dinsos",
//             ],
//             data: data.map((row) {
//               return [
//                 row["no"].toString(),
//                 row["jenis"],
//                 row["umum"].toString(),
//                 row["jknNonPbi"].toString(),
//                 row["jknPbi"].toString(),
//                 row["jamkesda"].toString(),
//                 row["pemda"].toString(),
//                 row["asuransi"].toString(),
//                 row["covid"].toString(),
//                 row["dinsos"].toString(),
//               ];
//             }).toList(),
//             border: pw.TableBorder.all(width: 0.5),
//             headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//             headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
//             cellAlignment: pw.Alignment.center,
//             cellStyle: const pw.TextStyle(fontSize: 9),
//           ),

//           pw.SizedBox(height: 40),

//           pw.Row(
//             mainAxisAlignment: pw.MainAxisAlignment.end,
//             children: [
//               pw.Column(
//                 children: [
//                   pw.Text("Mengetahui,", style: pw.TextStyle(fontSize: 12)),
//                   pw.SizedBox(height: 50),
//                   pw.Image(tandaTangan, width: 100, height: 60),
//                   pw.Text("Dr. John Doe, Sp.PA",
//                       style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
//                   pw.Text("Dokter Patologi Anatomi", style: pw.TextStyle(fontSize: 10)),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );

//     return pdf;
//   }

//   Future<void> _downloadPdf(BuildContext context, List<Map<String, dynamic>> data) async {
//     try {
//       final pdf = await _generatePdf(data);
//       final bytes = await pdf.save();

//       final dir = await getExternalStorageDirectory(); // lebih mudah diakses user
//       final filePath = "${dir!.path}/laporan_lab.pdf";
//       final file = File(filePath);
//       await file.writeAsBytes(bytes);

//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("✅ PDF berhasil disimpan di: $filePath")),
//         );
//       }
//     } catch (e) {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("❌ Gagal membuat PDF: $e")),
//         );
//       }
//     }
//   }

//   Future<void> _sharePdf(List<Map<String, dynamic>> data) async {
//     final pdf = await _generatePdf(data);
//     final bytes = await pdf.save();
//     await Printing.sharePdf(bytes: bytes, filename: "laporan_lab.pdf");
//   }

//   @override
//   Widget build(BuildContext context) {
//     final dummyData = [
//       {
//         "no": 1,
//         "jenis": "Biopsi Jaringan",
//         "umum": 2,
//         "jknNonPbi": 3,
//         "jknPbi": 1,
//         "jamkesda": 0,
//         "pemda": 0,
//         "asuransi": 1,
//         "covid": 0,
//         "dinsos": 0,
//       },
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Cetak PDF Laporan"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton.icon(
//               icon: const Icon(Icons.download),
//               label: const Text("Download PDF"),
//               onPressed: () => _downloadPdf(context, dummyData),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton.icon(
//               icon: const Icon(Icons.share),
//               label: const Text("Bagikan PDF"),
//               onPressed: () => _sharePdf(dummyData),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class BillingDetailPage extends StatelessWidget {
  final Map<String, dynamic> bill;

  const BillingDetailPage({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    if (bill["isPaid"] == true) {
      statusColor = Colors.green.shade600;
      statusIcon = Icons.check_circle;
      statusText = "Lunas";
    } else if (bill["isLate"] == true) {
      statusColor = Colors.red.shade600;
      statusIcon = Icons.error;
      statusText = "Terlambat";
    } else {
      statusColor = Colors.blue.shade700;
      statusIcon = Icons.hourglass_empty;
      statusText = "Belum Lunas";
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Tagihan"),
        backgroundColor: const Color(0xFF1976D2),
        elevation: 1.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          shadowColor: Colors.black26,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Invoice",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  bill["invoice"] ?? "-",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildDetailRow("Layanan", bill["service"]),
                _buildDetailRow("Tanggal", "${bill["date"]} • ${bill["time"]}"),
                _buildDetailRow("Deskripsi", bill["description"]),
                _buildDetailRow("Jumlah Tagihan", bill["amount"], isAmount: true),
                const SizedBox(height: 24),
                Divider(color: Colors.grey.shade300, thickness: 1),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text(
                      "Status: ",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(statusIcon, size: 18, color: statusColor),
                          const SizedBox(width: 8),
                          Text(
                            statusText,
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String? value, {bool isAmount = false}) {
    final displayValue = value ?? "-";
    final textStyle = isAmount
        ? const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)
        : const TextStyle(fontSize: 16);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
          const SizedBox(height: 4),
          Text(displayValue, style: textStyle),
        ],
      ),
    );
  }
}

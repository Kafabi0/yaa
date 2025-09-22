import 'package:flutter/material.dart';

class LiveAntrianPage extends StatefulWidget {
  final String nomorAntrian;   // contoh: RJ40
  final String antrianSaatIni; // contoh: RJ37
  final int estimasiMenit;     // contoh: 20

  const LiveAntrianPage({
    super.key,
    required this.nomorAntrian,
    required this.antrianSaatIni,
    this.estimasiMenit = 20,
  });

  @override
  State<LiveAntrianPage> createState() => _LiveAntrianPageState();
}

class _LiveAntrianPageState extends State<LiveAntrianPage> {
  bool reminderAktif = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // AppBar Custom
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              color: Colors.orange,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Antrian Rajal",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Nomor Antrian Anda",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 10),

            Text(
              widget.nomorAntrian,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Antrian Saat ini : ${widget.antrianSaatIni}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // Progress bar dummy
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: LinearProgressIndicator(
                value: 0.5, // nanti bisa dihitung dari posisi antrian
                color: Colors.orange,
                backgroundColor: Colors.grey[300],
                minHeight: 12,
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Status : Menunggu",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.orange,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Perkiraan Waktu Menunggu\n± ${widget.estimasiMenit} Menit",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),

            const Spacer(),

            const Text(
              "Harap Selalu Berada di area Rumah Sakit",
              style: TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 30),

            // Switch reminder
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orange),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Ingatkan Saya 3 Antrian Sebelum Saya"),
                    Switch(
                      activeColor: Colors.white,
                      activeTrackColor: Colors.orange,
                      value: reminderAktif,
                      onChanged: (val) {
                        setState(() => reminderAktif = val);
                      },
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

import 'package:flutter/material.dart';
import 'package:inocare/screens/detailjadwaldokter.dart';
import 'package:inocare/screens/homepagepasien.dart';
import 'rumahsakitmember.dart';
import 'package:inocare/services/user_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HospitalDetailPage extends StatefulWidget {
  final Hospital hospital;
  
  const HospitalDetailPage({Key? key, required this.hospital}) : super(key: key);

  @override
  State<HospitalDetailPage> createState() => _HospitalDetailPageState();
}

class _HospitalDetailPageState extends State<HospitalDetailPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // App Bar with Hospital Image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: Color(0xFFFF6B35),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    widget.hospital.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.local_hospital,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 60,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.hospital.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 3,
                                color: Colors.black.withOpacity(0.8),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 18),
                            SizedBox(width: 4),
                            Text(
                              '${widget.hospital.rating} (${widget.hospital.reviewCount} ulasan)',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                widget.hospital.distance,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildStatusRealTime(),
                _buildBloodStockSection(),
                _buildDoctorSection(),
                _buildPharmacySection(),
                _buildFacilitiesSection(),
                _buildAmbulanceSection(),
                _buildContactInfo(),
                _buildActionButton(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Di dalam HospitalDetailPage, tambahkan atau modifikasi bagian _buildStatusRealTime()
Widget _buildStatusRealTime() {
  return Container(
    margin: EdgeInsets.all(16),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.circle, color: Colors.red, size: 8),
            SizedBox(width: 8),
            Text(
              'Status Real-time',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            // Gunakan data dari widget.hospital.bedAvailability
            _buildStatusCard(
              '${widget.hospital.bedAvailability?['igd']?['available'] ?? 0}/${widget.hospital.bedAvailability?['igd']?['total'] ?? 0}', 
              'Bed IGD', 
              (widget.hospital.bedAvailability?['igd']?['available'] ?? 0) > 0 ? Colors.green : Colors.red
            ),
            _buildStatusCard(
              '${widget.hospital.bedAvailability?['vip']?['available'] ?? 0}/${widget.hospital.bedAvailability?['vip']?['total'] ?? 0}', 
              'Bed VIP', 
              (widget.hospital.bedAvailability?['vip']?['available'] ?? 0) > 0 ? Colors.green : Colors.red
            ),
            _buildStatusCard(
              '${widget.hospital.bedAvailability?['kelas1']?['available'] ?? 0}/${widget.hospital.bedAvailability?['kelas1']?['total'] ?? 0}', 
              'Bed Kelas 1', 
              (widget.hospital.bedAvailability?['kelas1']?['available'] ?? 0) > 0 ? Colors.green : Colors.red
            ),
            _buildStatusCard(
              '${widget.hospital.bedAvailability?['kelas2']?['available'] ?? 0}/${widget.hospital.bedAvailability?['kelas2']?['total'] ?? 0}', 
              'Bed Kelas 2', 
              (widget.hospital.bedAvailability?['kelas2']?['available'] ?? 0) > 0 ? Colors.green : Colors.red
            ),
            _buildStatusCard(
              '${widget.hospital.bedAvailability?['kelas3']?['available'] ?? 0}/${widget.hospital.bedAvailability?['kelas3']?['total'] ?? 0}', 
              'Bed Kelas 3', 
              (widget.hospital.bedAvailability?['kelas3']?['available'] ?? 0) > 0 ? Colors.green : Colors.red
            ),
            _buildStatusCard('25 Menit', 'Est. Antrian', Colors.green),
          ],
        ),
      ],
    ),
  );
}

  Widget _buildStatusCard(String value, String label, Color color) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBloodStockSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bloodtype, color: Colors.red, size: 16),
              SizedBox(width: 8),
              Text(
                'Stok Darah Hari Ini',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildBloodTypeCard('A+', widget.hospital.bloodStock['A+']!.count.toString(), widget.hospital.bloodStock['A+']!.available ? Colors.green : Colors.red)),
              SizedBox(width: 8),
              Expanded(child: _buildBloodTypeCard('B+', widget.hospital.bloodStock['B+']!.count.toString(), widget.hospital.bloodStock['B+']!.available ? Colors.green : Colors.red)),
              SizedBox(width: 8),
              Expanded(child: _buildBloodTypeCard('AB+', widget.hospital.bloodStock['AB+']!.count.toString(), widget.hospital.bloodStock['AB+']!.available ? Colors.green : Colors.red)),
              SizedBox(width: 8),
              Expanded(child: _buildBloodTypeCard('O-', widget.hospital.bloodStock['O-']!.count.toString(), widget.hospital.bloodStock['O-']!.available ? Colors.green : Colors.red)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildBloodTypeCard('A-', widget.hospital.bloodStock['A-']!.count.toString(), widget.hospital.bloodStock['A-']!.available ? Colors.green : Colors.red)),
              SizedBox(width: 8),
              Expanded(child: _buildBloodTypeCard('B-', widget.hospital.bloodStock['B-']!.count.toString(), widget.hospital.bloodStock['B-']!.available ? Colors.green : Colors.red)),
              SizedBox(width: 8),
              Expanded(child: _buildBloodTypeCard('AB-', widget.hospital.bloodStock['AB-']!.count.toString(), widget.hospital.bloodStock['AB-']!.available ? Colors.green : Colors.red)),
              SizedBox(width: 8),
              Expanded(child: _buildBloodTypeCard('O+', widget.hospital.bloodStock['O+']!.count.toString(), widget.hospital.bloodStock['O+']!.available ? Colors.green : Colors.red)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBloodTypeCard(String type, String count, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            type,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            '($count)',
            style: TextStyle(
              fontSize: 10,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('🩺', style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Text(
                'Dokter Hari Ini',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildDoctorCard('Dokter Jaga IGD', '24 Jam | Siaga', Colors.green, 'AKTIF'),
          SizedBox(height: 8),
          _buildDoctorCard('Spesialis Penyakit Dalam', 'Tersedia untuk konsultasi', Colors.blue, '08:00-16:00'),
          SizedBox(height: 8),
          _buildDoctorCard('Spesialis Jantung', 'Konsultasi & Tindakan', Colors.purple, '10:00-18:00'),
          SizedBox(height: 8),
          _buildDoctorCard('Spesialis Anak', 'Konsultasi Anak', Colors.pink, '14:00-22:00'),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorSchedulePage(hospital: widget.hospital),
                  ),
                );
              },
              icon: Icon(Icons.calendar_today, size: 16),
              label: Text('Lihat Jadwal Lengkap Dokter'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Color(0xFF4A90E2),
                side: BorderSide(color: Color(0xFF4A90E2)),
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(String title, String subtitle, Color color, String status) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPharmacySection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('💊', style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Text(
                'Farmasi & Apotek',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Apotek ${widget.hospital.name}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Buka 24 Jam | Obat dan alat kesehatan',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'BUKA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.orange),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Antrian saat ini: 8 orang\nEstimasi tunggu: 15-20 menit',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.orange[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilitiesSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('🏥', style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Text(
                'Layanan & Fasilitas',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildFacilityItem('IGD 24 Jam', 'Siaga penuh dengan 4 ambulans', Icons.local_hospital, Colors.green, 'SIAGA'),
          SizedBox(height: 8),
          _buildFacilityItem('Laboratorium', 'Hasil cepat, booking online', Icons.science, Colors.blue, 'BUKA'),
          SizedBox(height: 8),
          _buildFacilityItem('Radiologi', 'CT Scan, MRI, Rontgen', Icons.medical_services, Colors.purple, 'BUKA'),
          SizedBox(height: 8),
          _buildFacilityItem('Kamar Operasi', '3 ruang operasi tersedia', Icons.masks, Colors.orange, 'SIAP'),
        ],
      ),
    );
  }

  Widget _buildFacilityItem(String title, String subtitle, IconData icon, Color color, String status) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmbulanceSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('🚑', style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Text(
                'Layanan Ambulans',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Ambulans: 4 unit',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Tersedia: 4 unit',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.local_hospital, size: 20, color: Colors.red),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.pink.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.pink.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('🚑', style: TextStyle(fontSize: 14)),
                          SizedBox(width: 4),
                          Text(
                            'Ambulans ICU: 2 unit (Tersedia)',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Text('🚑', style: TextStyle(fontSize: 14)),
                          SizedBox(width: 4),
                          Text(
                            'Ambulans Transportasi: 2 unit (Tersedia)',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Catatan: Untuk penggunaan ambulans darurat, tetap perlu ke data pendaftaran pasien setelah mendali layanan ini.',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.phone, color: Colors.white, size: 16),
              label: Text(
                'Hubungi untuk Ambulans',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.phone, color: Colors.green, size: 16),
              SizedBox(width: 8),
              Text(
                'Informasi Kontak',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.red, size: 16),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.hospital.address,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.phone, color: Colors.green, size: 16),
              SizedBox(width: 8),
              Text(
                widget.hospital.phone,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.access_time, color: Colors.blue, size: 16),
              SizedBox(width: 8),
              Text(
                widget.hospital.operatingHours,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return Container(
      margin: EdgeInsets.all(16),
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          // Simpan rumah sakit terpilih ke SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          final currentNik = prefs.getString('current_nik');
          
          if (currentNik != null) {
            await UserPrefs.setSelectedHospital(currentNik, {
              'name': widget.hospital.name,
              'address': widget.hospital.address,
              'phone': widget.hospital.phone,
              'distance': widget.hospital.distance,
              'rating': widget.hospital.rating,
              'reviewCount': widget.hospital.reviewCount,
              'isOpen': widget.hospital.isOpen,
              'imagePath': widget.hospital.imagePath,
              'operatingHours': widget.hospital.operatingHours,
              'type': widget.hospital.type,
              'services': widget.hospital.services,
              'specialties': widget.hospital.specialties,
            });
          }

          // Navigasi ke HomePage Pasien
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomePagePasien(selectedHospital: widget.hospital),
            ),
            (route) => false,
          );
        },
        icon: Icon(Icons.check_circle, color: Colors.white, size: 20),
        label: Text(
          'Pilih & Daftar di RS Ini',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
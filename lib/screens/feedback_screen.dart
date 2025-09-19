import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;


class FeedbackItem {
  final String id;
  final String name;
  final String message;
  FeedbackItem({
    required this.id,
    required this.name,
    required this.message,
  });

  factory FeedbackItem.fromJson(Map<String, dynamic> json) {
    return FeedbackItem(
      id: json['id'].toString(),
      name: json['name'] as String,
      message: json['message'] as String,
    );
  }
}

class FeedbackList extends StatefulWidget {
  const FeedbackList({super.key});

  @override
  State<FeedbackList> createState() => _FeedbackListState();
}

class _FeedbackListState extends State<FeedbackList> {
  List<FeedbackItem> feedbacks = [];
  bool loading = true;
  bool hasError = false;

  final String _apiUrl = "http://192.168.1.11:8080/feedbacks";

  @override
  void initState() {
    super.initState();
    fetchFeedbacks();
  }

  Future<void> fetchFeedbacks() async {
    setState(() {
      loading = true;
      hasError = false;
    });

    try {
      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data != null && data['data'] is List) {
          setState(() {
            feedbacks = (data['data'] as List)
                .map((item) => FeedbackItem.fromJson(item))
                .toList();
            loading = false;
          });
        } else {
          setState(() {
            hasError = true;
            loading = false;
          });
        }
      } else {
        setState(() {
          hasError = true;
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal memuat ulasan. Status: ${response.statusCode}',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            backgroundColor: const Color(0xFFE53935),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.all(12),
          ),
        );
      }
    } catch (e) {
      // Handle network or parsing errors
      setState(() {
        hasError = true;
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Terjadi kesalahan: $e',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          ),
          backgroundColor: const Color(0xFFE53935),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(12),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the current theme is dark mode.
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Medical-themed colors
    final backgroundColor = isDarkMode 
        ? const Color(0xFF121F2F) 
        : const Color(0xFFF7FAFC);
    final cardColor = isDarkMode 
        ? const Color(0xFF1D2939) 
        : Colors.white;
    final textColor = isDarkMode 
        ? Colors.white 
        : const Color(0xFF101828);
    final subtitleColor = isDarkMode 
        ? const Color(0xFFADB5BD) 
        : const Color(0xFF64748B);
    final accentColor = const Color(0xFF0077B6); // Medical blue

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Daftar Ulasan Pasien',
          style: GoogleFonts.poppins(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: isDarkMode ? const Color(0xFF0F172A) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              FontAwesomeIcons.arrowsRotate,
              size: 18,
              color: accentColor,
            ),
            onPressed: fetchFeedbacks,
            tooltip: 'Refresh Data',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _buildBody(context, isDarkMode, cardColor, textColor, subtitleColor, accentColor),
    );
  }

  /// Builds the body of the page based on the current state (loading, error, or data).
  Widget _buildBody(BuildContext context, bool isDarkMode, Color cardColor, 
      Color textColor, Color subtitleColor, Color accentColor) {
    if (loading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Memuat data ulasan...',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: subtitleColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    } else if (hasError || feedbacks.isEmpty) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                hasError 
                    ? FontAwesomeIcons.triangleExclamation 
                    : FontAwesomeIcons.clipboardList,
                size: 48,
                color: hasError 
                    ? const Color(0xFFE53935) 
                    : accentColor.withOpacity(0.8),
              ),
              const SizedBox(height: 20),
              Text(
                hasError 
                    ? 'Gagal memuat data ulasan' 
                    : 'Belum ada ulasan yang tersedia',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                hasError 
                    ? 'Terjadi kesalahan saat mengambil data dari server. Silakan coba lagi nanti.' 
                    : 'Belum ada ulasan yang disubmit oleh pasien. Harap periksa kembali nanti.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: subtitleColor,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: fetchFeedbacks,
                icon: const Icon(Icons.refresh, size: 18),
                label: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    'Muat Ulang',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return RefreshIndicator(
        onRefresh: fetchFeedbacks,
        color: accentColor,
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: feedbacks.length,
          itemBuilder: (context, index) {
            final feedback = feedbacks[index];
            return _buildFeedbackCard(
              context, feedback, cardColor, textColor, subtitleColor, index);
          },
        ),
      );
    }
  }

  /// Builds a single premium-looking feedback card for medical staff.
  Widget _buildFeedbackCard(BuildContext context, FeedbackItem feedback, 
      Color cardColor, Color textColor, Color subtitleColor, int index) {
    
    // Create an alternating pattern of accent colors for visual distinction
    final List<Color> accentColors = [
      const Color(0xFF0077B6),  // Medical blue
      const Color(0xFF2A9D8F),  // Teal
      const Color(0xFF4361EE),  // Royal blue
    ];
    
    final accentColor = accentColors[index % accentColors.length];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Colored header bar
          Container(
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      FontAwesomeIcons.userDoctor,
                      size: 16,
                      color: accentColor,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feedback.name,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'ID: ${feedback.id}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: subtitleColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Feedback message content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ulasan Pasien:',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: subtitleColor,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: accentColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    feedback.message,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: textColor,
                      height: 1.6,
                      fontWeight: FontWeight.w400,
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
}
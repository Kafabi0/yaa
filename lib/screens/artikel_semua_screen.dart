import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AllHealthArticlesPage extends StatefulWidget {
  @override
  _AllHealthArticlesPageState createState() => _AllHealthArticlesPageState();
}

class _AllHealthArticlesPageState extends State<AllHealthArticlesPage>
    with SingleTickerProviderStateMixin {
  String selectedCategory = 'Semua';
  String searchQuery = '';
  int currentPage = 1;
  final int itemsPerPage = 10;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> categories = [
    'Semua',
    'Kesehatan Ginjal',
    'Nutrisi',
    'Pencernaan',
    'Jantung',
    'Mental Health',
    'Olahraga',
    'Penyakit Dalam',
    'Mata',
    'THT',
    'Kulit',
    'Anak',
    'Lansia',
    'Wanita',
    'Pria'
  ];

  final List<ArticleModel> articles = [
    // Kesehatan Ginjal
    ArticleModel(
      id: 1,
      title: '5 Cara Merawat Ginjal agar Sehat & Cegah Penyakit Ginjal',
      category: 'Kesehatan Ginjal',
      date: '3 September 2025',
      image: 'assets/images/ginjal.jpg',
      excerpt: 'Tips praktis untuk menjaga kesehatan ginjal dan mencegah penyakit ginjal kronis yang dapat berdampak pada kualitas hidup.',
      readTime: '5 min',
      views: 1250,
      url: 'https://www.biofarma.co.id/id/announcement/detail/5-cara-merawat-ginjal-agar-sehat-cegah-penyakit-ginjal',
    ),
    ArticleModel(
      id: 2,
      title: 'Rahasia Menjaga Ginjal Tetap Sehat dan Aktif',
      category: 'Kesehatan Ginjal',
      date: '18 Juni 2025',
      image: 'assets/images/rahasiaginjal.jpg',
      excerpt: 'Yuk, kenali cara-cara merawat ginjal berikut ini agar kamu bisa terhindar dari penyakit serius di kemudian hari.',
      readTime: '7 min',
      views: 985,
      url: 'https://www.biofarma.co.id/id/announcement/detail/rahasia-menjaga-ginjal-tetap-sehat-dan-aktif',
    ),
    ArticleModel(
      id: 3,
      title: '6 Makanan Sehat untuk Ginjal yang Wajib Ada di Menu Harianmu',
      category: 'Kesehatan Ginjal',
      date: '25 April 2025',
      image: 'assets/images/makananginjal.jpg',
      excerpt: 'Yuk, kenali makanan sehat untuk ginjal berikut ini yang terbukti mendukung fungsi ginjal secara alami!',
      readTime: '8 min',
      views: 742,
      url: 'https://www.biofarma.co.id/id/announcement/detail/6-makanan-sehat-untuk-ginjal-yang-wajib-ada-di-menu-harianmu',
    ),
    ArticleModel(
      id: 4,
      title: 'Cuci Darah: Prosedur, Manfaat, dan Efek Sampingnya',
      category: 'Kesehatan Ginjal',
      date: '28 Agustus 2025',
      image: 'assets/images/dialysis.jpg',
      excerpt: 'Informasi lengkap tentang hemodialisis untuk penderita gagal ginjal termasuk prosedur dan hal yang perlu diketahui.',
      readTime: '10 min',
      views: 1567,
      url: 'https://www.biofarma.co.id/id/announcement/detail/cuci-darah-prosedur-manfaat-efek-samping',
    ),
    ArticleModel(
      id: 5,
      title: 'Batu Ginjal: Penyebab, Gejala, dan Cara Mengatasinya',
      category: 'Kesehatan Ginjal',
      date: '26 Agustus 2025',
      image: 'assets/images/kidney_stone.jpg',
      excerpt: 'Panduan komprehensif tentang batu ginjal dan penanganannya mulai dari pencegahan hingga pengobatan.',
      readTime: '6 min',
      views: 892,
      url: 'https://www.biofarma.co.id/id/announcement/detail/batu-ginjal-penyebab-gejala-cara-mengatasi',
    ),

    // Nutrisi
    ArticleModel(
      id: 6,
      title: '9 Manfaat Kolang Kaling yang Perlu Kamu Ketahui',
      category: 'Nutrisi',
      date: '30 Juni 2025',
      image: 'assets/images/olang.jpg',
      excerpt: 'Temukan manfaat luar biasa kolang kaling untuk kesehatan tubuh dan bagaimana cara mengonsumsinya dengan tepat.',
      readTime: '4 min',
      views: 654,
      url: 'https://www.biofarma.co.id/id/announcement/detail/9-manfaat-kolang-kaling-yang-perlu-kamu-ketahui',
    ),
    ArticleModel(
      id: 7,
      title: '15 Makanan Super yang Wajib Ada di Menu Harian',
      category: 'Nutrisi',
      date: '25 Agustus 2025',
      image: 'assets/images/superfoods.jpg',
      excerpt: 'Daftar superfood yang kaya nutrisi untuk kesehatan optimal dan cara mudah mengintegrasikannya dalam diet sehari-hari.',
      readTime: '9 min',
      views: 1324,
      url: 'https://www.biofarma.co.id/id/announcement/detail/15-makanan-super-menu-harian',
    ),
    ArticleModel(
      id: 8,
      title: 'Vitamin D: Manfaat, Sumber, dan Tanda Kekurangannya',
      category: 'Nutrisi',
      date: '23 Agustus 2025',
      image: 'assets/images/vitamin_d.jpg',
      excerpt: 'Pentingnya vitamin D untuk kesehatan tulang dan sistem imun serta cara memenuhi kebutuhan vitamin D harian.',
      readTime: '7 min',
      views: 976,
      url: 'https://www.biofarma.co.id/id/announcement/detail/vitamin-d-manfaat-sumber-tanda-kekurangan',
    ),
    ArticleModel(
      id: 9,
      title: 'Panduan Lengkap Diet Mediterania untuk Pemula',
      category: 'Nutrisi',
      date: '21 Agustus 2025',
      image: 'assets/images/mediterranean_diet.jpg',
      excerpt: 'Mengenal diet Mediterania yang terbukti baik untuk kesehatan jantung dan cara menerapkannya dalam kehidupan sehari-hari.',
      readTime: '11 min',
      views: 1089,
      url: 'https://www.biofarma.co.id/id/announcement/detail/panduan-diet-mediterania-pemula',
    ),
    ArticleModel(
      id: 10,
      title: 'Probiotik vs Prebiotik: Perbedaan dan Manfaatnya',
      category: 'Nutrisi',
      date: '19 Agustus 2025',
      image: 'assets/images/probiotics.jpg',
      excerpt: 'Memahami perbedaan probiotik dan prebiotik untuk kesehatan usus serta makanan yang mengandung keduanya.',
      readTime: '6 min',
      views: 738,
      url: 'https://www.biofarma.co.id/id/announcement/detail/probiotik-vs-prebiotik-perbedaan-manfaat',
    ),

    // Pencernaan
    ArticleModel(
      id: 11,
      title: 'Kenali Jenis Makanan Penyebab GERD',
      category: 'Pencernaan',
      date: '17 Agustus 2025',
      image: 'assets/images/gerd.png',
      excerpt: 'Informasi lengkap tentang penyakit asam lambung dan penanganannya termasuk perubahan gaya hidup yang diperlukan.',
      readTime: '8 min',
      views: 1456,
      url: 'https://www.biofarma.co.id/id/announcement/detail/kenali-jenis-makanan-penyebab-gerd',
    ),
    ArticleModel(
      id: 12,
      title: '7 Makanan yang Baik untuk Kesehatan Lambung',
      category: 'Pencernaan',
      date: '15 Agustus 2025',
      image: 'assets/images/stomach_food.jpg',
      excerpt: 'Daftar makanan yang aman dan baik untuk penderita sakit lambung serta tips mengatur pola makan yang sehat.',
      readTime: '5 min',
      views: 923,
      url: 'https://www.biofarma.co.id/id/announcement/detail/7-makanan-baik-kesehatan-lambung',
    ),
    ArticleModel(
      id: 13,
      title: 'IBS (Irritable Bowel Syndrome): Kenali dan Atasi',
      category: 'Pencernaan',
      date: '13 Agustus 2025',
      image: 'assets/images/ibs.jpg',
      excerpt: 'Panduan mengenali dan mengatasi sindrom usus besar sensitif termasuk diet dan gaya hidup yang mendukung.',
      readTime: '9 min',
      views: 675,
      url: 'https://www.biofarma.co.id/id/announcement/detail/ibs-irritable-bowel-syndrome-kenali-atasi',
    ),

    // Jantung
    ArticleModel(
      id: 14,
      title: '10 Tips Menjaga Kesehatan Jantung di Usia Muda',
      category: 'Jantung',
      date: '11 Agustus 2025',
      image: 'assets/images/heart_health.jpg',
      excerpt: 'Langkah preventif untuk menjaga kesehatan jantung sejak dini dan mengurangi risiko penyakit kardiovaskular.',
      readTime: '7 min',
      views: 1234,
      url: 'https://www.biofarma.co.id/id/announcement/detail/10-tips-menjaga-kesehatan-jantung-usia-muda',
    ),
    ArticleModel(
      id: 15,
      title: 'Kolesterol Tinggi: Bahaya dan Cara Menurunkannya',
      category: 'Jantung',
      date: '9 Agustus 2025',
      image: 'assets/images/cholesterol.jpg',
      excerpt: 'Strategi efektif untuk menurunkan kadar kolesterol tinggi melalui diet, olahraga, dan perubahan gaya hidup.',
      readTime: '8 min',
      views: 1567,
      url: 'https://www.biofarma.co.id/id/announcement/detail/kolesterol-tinggi-bahaya-cara-menurunkan',
    ),

    // Mental Health
    ArticleModel(
      id: 16,
      title: 'Mengatasi Stres dan Kecemasan di Era Digital',
      category: 'Mental Health',
      date: '7 Agustus 2025',
      image: 'assets/images/stress_digital.jpg',
      excerpt: 'Tips praktis mengelola stres di tengah perkembangan teknologi dan cara menjaga keseimbangan mental.',
      readTime: '6 min',
      views: 876,
      url: 'https://www.biofarma.co.id/id/announcement/detail/mengatasi-stres-kecemasan-era-digital',
    ),
    ArticleModel(
      id: 17,
      title: 'Depresi pada Remaja: Tanda dan Cara Membantu',
      category: 'Mental Health',
      date: '5 Agustus 2025',
      image: 'assets/images/teen_depression.jpg',
      excerpt: 'Mengenali tanda depresi pada remaja dan cara memberikan dukungan yang tepat untuk pemulihan mental.',
      readTime: '10 min',
      views: 1124,
      url: 'https://www.biofarma.co.id/id/announcement/detail/depresi-remaja-tanda-cara-membantu',
    ),

    // Olahraga
    ArticleModel(
      id: 18,
      title: 'Olahraga untuk Pemula: Memulai Hidup Sehat',
      category: 'Olahraga',
      date: '3 Agustus 2025',
      image: 'assets/images/exercise_beginner.jpg',
      excerpt: 'Panduan olahraga untuk pemula yang ingin memulai hidup sehat dengan program latihan yang mudah diikuti.',
      readTime: '7 min',
      views: 945,
      url: 'https://www.biofarma.co.id/id/announcement/detail/olahraga-pemula-memulai-hidup-sehat',
    ),
    ArticleModel(
      id: 19,
      title: 'Yoga untuk Kesehatan Mental dan Fisik',
      category: 'Olahraga',
      date: '1 Agustus 2025',
      image: 'assets/images/yoga.jpg',
      excerpt: 'Manfaat yoga untuk keseimbangan mental dan kesehatan fisik serta gerakan dasar yang dapat dipraktikkan.',
      readTime: '8 min',
      views: 789,
      url: 'https://www.biofarma.co.id/id/announcement/detail/yoga-kesehatan-mental-fisik',
    ),

    // Penyakit Dalam
    ArticleModel(
      id: 20,
      title: 'Diabetes Tipe 2: Pencegahan dan Pengelolaan',
      category: 'Penyakit Dalam',
      date: '30 Juli 2025',
      image: 'assets/images/diabetes.jpg',
      excerpt: 'Strategi pencegahan dan pengelolaan diabetes tipe 2 melalui diet, olahraga, dan monitoring gula darah.',
      readTime: '9 min',
      views: 1678,
      url: 'https://www.biofarma.co.id/id/announcement/detail/diabetes-tipe-2-pencegahan-pengelolaan',
    ),

    // Mata
    ArticleModel(
      id: 21,
      title: 'Cara Menjaga Kesehatan Mata di Era Digital',
      category: 'Mata',
      date: '28 Juli 2025',
      image: 'assets/images/eye_health.jpg',
      excerpt: 'Tips menjaga kesehatan mata dari paparan layar gadget dan cara mengurangi mata lelah.',
      readTime: '6 min',
      views: 834,
      url: 'https://www.biofarma.co.id/id/announcement/detail/cara-menjaga-kesehatan-mata-era-digital',
    ),

    // THT
    ArticleModel(
      id: 22,
      title: 'Sinusitis: Penyebab, Gejala, dan Pengobatan',
      category: 'THT',
      date: '26 Juli 2025',
      image: 'assets/images/sinusitis.jpg',
      excerpt: 'Memahami sinusitis dan cara mengatasinya dengan pengobatan medis dan perawatan rumahan.',
      readTime: '7 min',
      views: 567,
      url: 'https://www.biofarma.co.id/id/announcement/detail/sinusitis-penyebab-gejala-pengobatan',
    ),

    // Kulit
    ArticleModel(
      id: 23,
      title: 'Perawatan Kulit Wajah untuk Berbagai Jenis Kulit',
      category: 'Kulit',
      date: '24 Juli 2025',
      image: 'assets/images/skincare.jpg',
      excerpt: 'Panduan perawatan kulit wajah yang tepat sesuai dengan jenis kulit untuk hasil yang optimal.',
      readTime: '8 min',
      views: 912,
      url: 'https://www.biofarma.co.id/id/announcement/detail/perawatan-kulit-wajah-jenis-kulit',
    ),

    // Anak
    ArticleModel(
      id: 24,
      title: 'Imunisasi Anak: Jadwal dan Manfaatnya',
      category: 'Anak',
      date: '22 Juli 2025',
      image: 'assets/images/child_immunization.jpg',
      excerpt: 'Pentingnya imunisasi untuk anak dan jadwal vaksinasi yang harus diikuti untuk perlindungan optimal.',
      readTime: '9 min',
      views: 1456,
      url: 'https://www.biofarma.co.id/id/announcement/detail/imunisasi-anak-jadwal-manfaat',
    ),

    // Lansia
    ArticleModel(
      id: 25,
      title: 'Menjaga Kesehatan Tulang pada Lansia',
      category: 'Lansia',
      date: '20 Juli 2025',
      image: 'assets/images/elderly_bone.jpg',
      excerpt: 'Tips menjaga kesehatan tulang untuk lansia dan mencegah osteoporosis dengan nutrisi yang tepat.',
      readTime: '7 min',
      views: 678,
      url: 'https://www.biofarma.co.id/id/announcement/detail/menjaga-kesehatan-tulang-lansia',
    ),

    // Wanita
    ArticleModel(
      id: 26,
      title: 'Kesehatan Reproduksi Wanita: Yang Perlu Diketahui',
      category: 'Wanita',
      date: '18 Juli 2025',
      image: 'assets/images/women_health.jpg',
      excerpt: 'Informasi penting tentang kesehatan reproduksi wanita dan cara menjaga kesehatan organ intim.',
      readTime: '10 min',
      views: 1234,
      url: 'https://www.biofarma.co.id/id/announcement/detail/kesehatan-reproduksi-wanita',
    ),

    // Pria
    ArticleModel(
      id: 27,
      title: 'Kesehatan Prostat: Pencegahan dan Deteksi Dini',
      category: 'Pria',
      date: '16 Juli 2025',
      image: 'assets/images/men_health.jpg',
      excerpt: 'Pentingnya menjaga kesehatan prostat untuk pria dan cara deteksi dini masalah kesehatan prostat.',
      readTime: '8 min',
      views: 889,
      url: 'https://www.biofarma.co.id/id/announcement/detail/kesehatan-prostat-pencegahan-deteksi-dini',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tidak dapat membuka artikel'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  List<ArticleModel> get filteredArticles {
    List<ArticleModel> filtered = articles;

    if (selectedCategory != 'Semua') {
      filtered = filtered.where((article) => article.category == selectedCategory).toList();
    }

    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((article) =>
          article.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          article.excerpt.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    }

    return filtered;
  }

  List<ArticleModel> get paginatedArticles {
    final filtered = filteredArticles;
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    return filtered.sublist(
      startIndex,
      endIndex > filtered.length ? filtered.length : endIndex,
    );
  }

  int get totalPages => (filteredArticles.length / itemsPerPage).ceil();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildHeader(),
              _buildSearchAndFilter(),
              _buildCategoryChips(),
              Expanded(
                child: _buildArticlesList(),
              ),
              _buildPagination(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE5E5E5), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFFFF5F0),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFFFF6B35).withOpacity(0.2)),
                ),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back, color: Color(0xFFFF6B35)),
                  padding: EdgeInsets.all(8),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Artikel Kesehatan',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Color(0xFFFFF5F0),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xFFFF6B35).withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.article_outlined, color: Color(0xFFFF6B35), size: 18),
                SizedBox(width: 8),
                Text(
                  '${filteredArticles.length} artikel tersedia',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFFF6B35),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE5E5E5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            searchQuery = value;
            currentPage = 1;
          });
        },
        decoration: InputDecoration(
          hintText: 'Cari topik artikel kesehatan...',
          hintStyle: TextStyle(color: Color(0xFF999999), fontSize: 14),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          prefixIcon: Padding(
            padding: EdgeInsets.all(12),
            child: Icon(Icons.search, color: Color(0xFFFF6B35), size: 20),
          ),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      searchQuery = '';
                    });
                  },
                  icon: Icon(Icons.clear, color: Color(0xFF999999), size: 20),
                )
              : null,
        ),
        style: TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;
          
          return Container(
            margin: EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : Color(0xFF333333),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  selectedCategory = category;
                  currentPage = 1;
                });
              },
              backgroundColor: Colors.white,
              selectedColor: Color(0xFFFF6B35),
              checkmarkColor: Colors.white,
              elevation: 0,
              pressElevation: 2,
              side: BorderSide(
                color: isSelected ? Color(0xFFFF6B35) : Color(0xFFE5E5E5),
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildArticlesList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE5E5E5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: paginatedArticles.length,
        separatorBuilder: (context, index) => Divider(
          color: Color(0xFFF0F0F0),
          height: 24,
        ),
        itemBuilder: (context, index) {
          final article = paginatedArticles[index];
          return _buildArticleCard(article, index);
        },
      ),
    );
  }

  Widget _buildArticleCard(ArticleModel article, int index) {
    return InkWell(
      onTap: () => _launchURL(article.url),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Responsive breakpoint
            bool isSmallScreen = constraints.maxWidth < 400;
            double imageSize = isSmallScreen ? 70 : 90;
            
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Article Image - Responsive
                Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      article.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Color(0xFFF8F9FA),
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: Color(0xFFCCCCCC),
                            size: imageSize * 0.3,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: isSmallScreen ? 12 : 16),
                // Article Content - Responsive
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category and Views Row
                      Row(
                        children: [
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 6 : 8, 
                                vertical: 4
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFFFFF5F0),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Color(0xFFFF6B35).withOpacity(0.2)),
                              ),
                              child: Text(
                                article.category,
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 10 : 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFFF6B35),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Color(0xFFF8F9FA),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.visibility_outlined, 
                                    size: isSmallScreen ? 12 : 14, 
                                    color: Color(0xFF999999)),
                                SizedBox(width: 3),
                                Text(
                                  '${article.views}',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 10 : 11,
                                    color: Color(0xFF999999),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isSmallScreen ? 8 : 10),
                      // Title - Responsive font size
                      Text(
                        article.title,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                          height: 1.3,
                        ),
                        maxLines: isSmallScreen ? 2 : 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6),
                      // Excerpt - Responsive
                      Text(
                        article.excerpt,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 12 : 13,
                          color: Color(0xFF666666),
                          height: 1.4,
                        ),
                        maxLines: isSmallScreen ? 1 : 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: isSmallScreen ? 10 : 12),
                      // Bottom Row - Responsive layout
                      isSmallScreen 
                        ? _buildSmallScreenBottomRow(article)
                        : _buildLargeScreenBottomRow(article),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSmallScreenBottomRow(ArticleModel article) {
    return Column(
      children: [
        // Date and Read time
        Row(
          children: [
            Icon(Icons.calendar_today_outlined,
                size: 11, color: Color(0xFF999999)),
            SizedBox(width: 3),
            Flexible(
              child: Text(
                article.date,
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFF999999),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 12),
            Icon(Icons.access_time_outlined,
                size: 11, color: Color(0xFF999999)),
            SizedBox(width: 3),
            Text(
              article.readTime,
              style: TextStyle(
                fontSize: 10,
                color: Color(0xFF999999),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        // Read button full width on small screens
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Color(0xFFFF6B35),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Baca Artikel',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 6),
              Icon(
                Icons.open_in_new,
                size: 14,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLargeScreenBottomRow(ArticleModel article) {
    return Row(
      children: [
        Icon(Icons.calendar_today_outlined,
            size: 12, color: Color(0xFF999999)),
        SizedBox(width: 4),
        Text(
          article.date,
          style: TextStyle(
            fontSize: 11,
            color: Color(0xFF999999),
          ),
        ),
        SizedBox(width: 12),
        Icon(Icons.access_time_outlined,
            size: 12, color: Color(0xFF999999)),
        SizedBox(width: 4),
        Text(
          article.readTime,
          style: TextStyle(
            fontSize: 11,
            color: Color(0xFF999999),
          ),
        ),
        Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Color(0xFFFF6B35),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFFF6B35).withOpacity(0.3),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Baca',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 6),
              Icon(
                Icons.open_in_new,
                size: 13,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPagination() {
    if (totalPages <= 1) return SizedBox.shrink();

    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE5E5E5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: currentPage > 1
                ? () {
                    setState(() {
                      currentPage--;
                    });
                  }
                : null,
            icon: Icon(Icons.chevron_left),
            color: currentPage > 1 ? Color(0xFFFF6B35) : Color(0xFFCCCCCC),
          ),
          ...List.generate(
            totalPages > 5 ? 5 : totalPages,
            (index) {
              int pageNum = currentPage <= 3
                  ? index + 1
                  : currentPage + index - 2;
              if (pageNum > totalPages) pageNum = totalPages - (5 - index - 1);
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    currentPage = pageNum;
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: currentPage == pageNum
                        ? Color(0xFFFF6B35)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: currentPage == pageNum
                        ? null
                        : Border.all(color: Color(0xFFE5E5E5)),
                  ),
                  child: Text(
                    pageNum.toString(),
                    style: TextStyle(
                      color: currentPage == pageNum
                          ? Colors.white
                          : Color(0xFF666666),
                      fontWeight: currentPage == pageNum
                          ? FontWeight.w600
                          : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            },
          ),
          IconButton(
            onPressed: currentPage < totalPages
                ? () {
                    setState(() {
                      currentPage++;
                    });
                  }
                : null,
            icon: Icon(Icons.chevron_right),
            color: currentPage < totalPages ? Color(0xFFFF6B35) : Color(0xFFCCCCCC),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Kesehatan Ginjal':
        return Icons.water_drop_outlined;
      case 'Nutrisi':
        return Icons.restaurant_outlined;
      case 'Pencernaan':
        return Icons.local_dining_outlined;
      case 'Jantung':
        return Icons.favorite_outline;
      case 'Mental Health':
        return Icons.psychology_outlined;
      case 'Olahraga':
        return Icons.fitness_center_outlined;
      case 'Penyakit Dalam':
        return Icons.local_hospital_outlined;
      case 'Mata':
        return Icons.remove_red_eye_outlined;
      case 'THT':
        return Icons.hearing_outlined;
      case 'Kulit':
        return Icons.face_outlined;
      case 'Anak':
        return Icons.child_care_outlined;
      case 'Lansia':
        return Icons.elderly_outlined;
      case 'Wanita':
        return Icons.woman_outlined;
      case 'Pria':
        return Icons.man_outlined;
      default:
        return Icons.article_outlined;
    }
  }
}

class ArticleModel {
  final int id;
  final String title;
  final String category;
  final String date;
  final String image;
  final String excerpt;
  final String readTime;
  final int views;
  final String url;

  ArticleModel({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.image,
    required this.excerpt,
    required this.readTime,
    required this.views,
    required this.url,
  });
}
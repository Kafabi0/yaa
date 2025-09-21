import 'package:flutter/material.dart';

class MenuMakananPage extends StatefulWidget {
  final String patientName;
  final String ranapNumber;

  const MenuMakananPage({
    Key? key,
    required this.patientName,
    required this.ranapNumber,
  }) : super(key: key);

  @override
  State<MenuMakananPage> createState() => _MenuMakananPageState();
}

class _MenuMakananPageState extends State<MenuMakananPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String patientDiet = 'Diet Diabetes'; // Diet yang ditetapkan dokter

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Menu Diet Pasien',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: _buildPatientInfo(),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTodayMenu(),
                _buildWeeklyMenu(),
                _buildDietGuidelines(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    widget.patientName.isNotEmpty 
                      ? widget.patientName[0].toUpperCase() 
                      : 'P',
                    style: const TextStyle(
                      color: Colors.teal,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.patientName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'No. Rawat Inap: ${widget.ranapNumber}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.restaurant_menu,
                  color: Colors.teal,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  patientDiet,
                  style: const TextStyle(
                    color: Colors.teal,
                    fontSize: 14,
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

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.teal,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.teal,
        indicatorWeight: 3,
        tabs: const [
          Tab(text: 'Hari Ini'),
          Tab(text: 'Minggu Ini'),
          Tab(text: 'Panduan Diet'),
        ],
      ),
    );
  }

  Widget _buildTodayMenu() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateHeader(),
          const SizedBox(height: 20),
          
          _buildMealCard(
            'Sarapan',
            '07:00',
            Icons.wb_sunny,
            Colors.orange,
            _getTodayBreakfast(),
          ),
          
          _buildMealCard(
            'Makan Siang',
            '12:00',
            Icons.wb_sunny_outlined,
            Colors.blue,
            _getTodayLunch(),
          ),
          
          _buildMealCard(
            'Makan Malam',
            '18:00',
            Icons.nightlight_round,
            Colors.indigo,
            _getTodayDinner(),
          ),
          
          _buildMealCard(
            'Snack',
            '15:00 & 20:00',
            Icons.cookie,
            Colors.brown,
            _getTodaySnacks(),
          ),
          
          const SizedBox(height: 20),
          _buildNutritionalInfo(),
        ],
      ),
    );
  }

  Widget _buildDateHeader() {
    final now = DateTime.now();
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    final days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.calendar_today,
              color: Colors.teal,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${days[now.weekday % 7]}, ${now.day} ${months[now.month - 1]} ${now.year}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Text(
                'Menu Diet Hari Ini',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard(String mealName, String time, IconData icon, Color color, List<Map<String, String>> foods) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mealName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'Jam $time',
                        style: TextStyle(
                          fontSize: 12,
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Wajib',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: foods.map((food) => _buildFoodItem(food)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodItem(Map<String, String> food) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getFoodIcon(food['name']!),
              color: Colors.teal,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food['name']!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  food['portion']!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${food['calories']} kal',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange,
                ),
              ),
              Text(
                food['carb']!,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyMenu() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Menu Diet Minggu Ini',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          
          ...List.generate(7, (index) {
            final date = DateTime.now().add(Duration(days: index));
            final days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
            final dayName = days[date.weekday % 7];
            final isToday = index == 0;
            
            return _buildWeeklyMenuItem(
              dayName,
              '${date.day}/${date.month}',
              isToday,
              _getWeeklyMenuSummary(index),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildWeeklyMenuItem(String day, String date, bool isToday, String menuSummary) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isToday ? Colors.teal.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isToday ? Colors.teal : Colors.grey[200]!,
          width: isToday ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isToday ? Colors.teal : Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  day,
                  style: TextStyle(
                    color: isToday ? Colors.white : Colors.black87,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    color: isToday ? Colors.white : Colors.black87,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  menuSummary,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const Text(
                  'Menu sesuai diet diabetes',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          if (isToday)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Hari Ini',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDietGuidelines() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Panduan Diet Diabetes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildGuidelineCard(
            'Makanan yang Dianjurkan',
            Icons.thumb_up,
            Colors.green,
            [
              'Nasi merah, roti gandum utuh',
              'Ikan, ayam tanpa kulit, tahu, tempe',
              'Sayuran hijau (bayam, kangkung, brokoli)',
              'Buah dengan indeks glikemik rendah (apel, pepaya)',
              'Kacang-kacangan (almond, walnut)',
              'Air putih minimal 8 gelas per hari',
            ],
          ),
          
          _buildGuidelineCard(
            'Makanan yang Harus Dihindari',
            Icons.block,
            Colors.red,
            [
              'Nasi putih, roti putih, mie instan',
              'Makanan dan minuman manis',
              'Gorengan dan makanan berlemak tinggi',
              'Daging berlemak, jeroan',
              'Buah dengan gula tinggi (mangga, anggur)',
              'Minuman bersoda dan beralkohol',
            ],
          ),
          
          _buildGuidelineCard(
            'Tips Penting',
            Icons.lightbulb,
            Colors.orange,
            [
              'Makan dalam porsi kecil tapi sering (5-6x sehari)',
              'Jangan melewatkan jadwal makan',
              'Kunyah makanan secara perlahan',
              'Olahraga ringan setelah makan',
              'Kontrol gula darah secara teratur',
              'Konsultasi dengan dokter dan ahli gizi',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGuidelineCard(String title, IconData icon, Color color, List<String> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: items.map((item) => _buildGuidelineItem(item)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuidelineItem(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionalInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue, size: 20),
              SizedBox(width: 8),
              Text(
                'Informasi Gizi Harian',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildNutritionItem('Kalori', '1,800', 'kal')),
              Expanded(child: _buildNutritionItem('Karbohidrat', '225', 'g')),
              Expanded(child: _buildNutritionItem('Protein', '90', 'g')),
              Expanded(child: _buildNutritionItem('Lemak', '60', 'g')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionItem(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          '$value $unit',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  // Data Methods
  List<Map<String, String>> _getTodayBreakfast() {
    return [
      {'name': 'Nasi Tim', 'portion': '1 porsi (100g)', 'calories': '130', 'carb': '28g karbo'},
      {'name': 'Ikan Kukus', 'portion': '1 potong (80g)', 'calories': '120', 'carb': '0g karbo'},
      {'name': 'Sayur Bayam', 'portion': '1 mangkuk', 'calories': '25', 'carb': '4g karbo'},
      {'name': 'Teh Tawar', 'portion': '1 gelas', 'calories': '0', 'carb': '0g karbo'},
    ];
  }

  List<Map<String, String>> _getTodayLunch() {
    return [
      {'name': 'Nasi Merah', 'portion': '1 porsi (100g)', 'calories': '110', 'carb': '23g karbo'},
      {'name': 'Ayam Panggang', 'portion': '1 potong (100g)', 'calories': '165', 'carb': '0g karbo'},
      {'name': 'Tahu Kukus', 'portion': '2 potong', 'calories': '80', 'carb': '4g karbo'},
      {'name': 'Sayur Asem', 'portion': '1 mangkuk', 'calories': '35', 'carb': '7g karbo'},
    ];
  }

  List<Map<String, String>> _getTodayDinner() {
    return [
      {'name': 'Nasi Tim', 'portion': '1 porsi (80g)', 'calories': '104', 'carb': '22g karbo'},
      {'name': 'Ikan Bakar', 'portion': '1 potong (80g)', 'calories': '140', 'carb': '0g karbo'},
      {'name': 'Tempe Kukus', 'portion': '2 potong', 'calories': '95', 'carb': '4g karbo'},
      {'name': 'Sayur Sop', 'portion': '1 mangkuk', 'calories': '30', 'carb': '6g karbo'},
    ];
  }

  List<Map<String, String>> _getTodaySnacks() {
    return [
      {'name': 'Apel', 'portion': '1 buah sedang', 'calories': '80', 'carb': '21g karbo'},
      {'name': 'Biskuit Gandum', 'portion': '2 keping', 'calories': '60', 'carb': '12g karbo'},
    ];
  }

  String _getWeeklyMenuSummary(int dayIndex) {
    final menus = [
      'Nasi tim, ikan kukus, sayur bayam', // Hari ini
      'Nasi merah, ayam rebus, cap cay',
      'Bubur ayam, telur rebus, sayur sop',
      'Nasi tim, ikan bakar, tumis kangkung',
      'Kentang rebus, ayam kukus, sayur lodeh',
      'Nasi merah, tempe kukus, sayur bayam',
      'Bubur kacang hijau, ikan kukus, sayur asem',
    ];
    return menus[dayIndex % menus.length];
  }

  IconData _getFoodIcon(String foodName) {
    if (foodName.toLowerCase().contains('nasi') || foodName.toLowerCase().contains('bubur')) {
      return Icons.rice_bowl;
    } else if (foodName.toLowerCase().contains('ikan')) {
      return Icons.set_meal;
    } else if (foodName.toLowerCase().contains('ayam')) {
      return Icons.lunch_dining;
    } else if (foodName.toLowerCase().contains('sayur')) {
      return Icons.eco;
    } else if (foodName.toLowerCase().contains('buah') || 
               foodName.toLowerCase().contains('apel') || 
               foodName.toLowerCase().contains('pisang')) {
      return Icons.apple;
    } else if (foodName.toLowerCase().contains('teh') || 
               foodName.toLowerCase().contains('air')) {
      return Icons.local_drink;
    }
    return Icons.restaurant;
  }
}
import 'package:flutter/material.dart';
import 'dart:math';
import 'canteen_detail_page.dart';

class CanteensPage extends StatefulWidget {
  @override
  _CanteensPageState createState() => _CanteensPageState();
}

class _CanteensPageState extends State<CanteensPage> {
  late String todayMainDish;
  final Random random = Random();

  // Ana yemek listesi
  final List<String> mainDishes = [
    'Orman Kebabı',
    'Antep Tava',
    'Etli Nohut',
    'İzmir Köfte',
    'Sebzeli Tavuk',
  ];

  // Sabit yan yemekler
  final List<String> sideDishes = [
    'Pilav',
    'Yoğurt',
    'Tulumba Tatlısı',
  ];

  @override
  void initState() {
    super.initState();
    // Uygulama açıldığında random ana yemek seç
    todayMainDish = mainDishes[random.nextInt(mainDishes.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kantinler'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.all(16),
            children: [
              // Fırat Üniversitesi Yemekhanesi
              _buildDiningHallCard(),
              SizedBox(height: 24),
              
              // Kampüs Kantinleri Başlığı
              Text(
                'Kampüs Kantinleri',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B0000),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              
              // Rektörlük Kampüsü
              _buildCampusSection('Rektörlük Kampüsü', rektorlukCanteens),
              SizedBox(height: 16),
              
              // Mühendislik Kampüsü
              _buildCampusSection('Mühendislik Kampüsü', muhendislikCanteens),
              
              // Alt boşluk
              SizedBox(height: 80),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDiningHallCard() {
    return Card(
      elevation: 4,
      child: Column(
        children: [
          // Yemekhane başlığı
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                color: Color(0xFF8B0000),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.restaurant,
                  color: Colors.white,
                  size: 40,
                ),
                SizedBox(height: 8),
                Text(
                  'Fırat Üniversitesi Yemekhanesi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          // Yemek saatleri
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            color: Colors.grey[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.access_time, color: Color(0xFF8B0000)),
                SizedBox(width: 8),
                Text(
                  'Yemek Saatleri: 11:30 - 13:30',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B0000),
                  ),
                ),
              ],
            ),
          ),
          
          // Günlük menü
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Günlük Menü',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B0000),
                  ),
                ),
                SizedBox(height: 12),
                
                // Ana yemek kategorisi
                Text(
                  'Ana Yemek',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B0000),
                  ),
                ),
                SizedBox(height: 8),
                _buildMenuItem('', todayMainDish, Icons.restaurant_menu),
                SizedBox(height: 16),
                
                // Yan yemekler kategorisi
                Text(
                  'Yan Yemekler',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B0000),
                  ),
                ),
                SizedBox(height: 8),
                ...sideDishes.map((dish) => _buildMenuItem('', dish, Icons.fastfood)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String category, String dish, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFF8B0000), size: 20),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            category.isEmpty ? dish : '$category: $dish',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildCampusSection(String campusName, List<Map<String, String>> canteens) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          campusName,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF8B0000),
          ),
        ),
        SizedBox(height: 8),
        ...canteens.map((canteen) => _buildCanteenCard(canteen)),
      ],
    );
  }

  Widget _buildCanteenCard(Map<String, String> canteen) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color(0xFF8B0000),
          child: Icon(Icons.local_cafe, color: Colors.white),
          radius: 25,
        ),
        title: Text(
          canteen['name']!,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(canteen['location']!),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CanteenDetailPage(canteen: canteen),
            ),
          );
        },
      ),
    );
  }


}

// Rektörlük Kampüsü Kantinleri
final List<Map<String, String>> rektorlukCanteens = [
  {
    'name': '30. Yıl Kantini',
    'location': 'Teknoloji Fakültesi',
    'openingHours': '08:00 - 18:00',
  },
  {
    'name': 'C Blok Kantini',
    'location': 'Teknoloji Fakültesi',
    'openingHours': '07:00 - 22:00',
  },
  {
    'name': 'Kütüphane Kantini',
    'location': 'Kütüphane Binası',
    'openingHours': '09:00 - 17:00',
  },
  {
    'name': 'Eğitim Fakültesi Kantini',
    'location': 'Eğitim Fakültesi',
    'openingHours': '08:00 - 20:00',
  },
];

// Mühendislik Kampüsü Kantinleri
final List<Map<String, String>> muhendislikCanteens = [
  {
    'name': 'Mühendislik Kantini',
    'location': 'Mühendislik Fakültesi',
    'openingHours': '08:00 - 18:00',
  },
  {
    'name': 'Harput Dibek Kafe',
    'location': 'AKM Karşısı',
    'openingHours': '08:00 - 17:00',
  },
  {
    'name': 'Bilgisayar Mühendislik Kantini',
    'location': 'Bilgisayar Mühendisliği',
    'openingHours': '09:00 - 16:00',
  },
  {
    'name': 'İlahiyat Fakültesi Kantini',
    'location': 'İlahiyat Fakültesi',
    'openingHours': '08:00 - 18:00',
  },
];


import 'package:flutter/material.dart';

class LibraryPage extends StatefulWidget {
  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  // Örnek kitap listesi
  final List<String> _books = [
    'Yapay Zeka ve Toplum',
    'Veri Bilimi 101',
    'Modern Fizik',
    'Türk Edebiyatı Tarihi',
    'Mühendislik Matematiği',
    'Psikolojiye Giriş',
    'Algoritmalar ve Programlama',
    'İktisat Teorisi',
    'Biyokimya Temelleri',
    'Osmanlı Tarihi',
  ];

  // Güncellenmiş doluluk oranları
  int groundFloorOccupancy = 92;
  int firstFloorOccupancy = 60;
  int secondFloorOccupancy = 40;
  int thirdFloorOccupancy = 18;

  @override
  Widget build(BuildContext context) {
    final filteredBooks = _books.where((book) => book.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Kütüphane'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              // Banner veya kütüphane görseli
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/firat_kampus.jpg',
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Fırat Üniversitesi Kütüphanesi',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Çalışma Saatları', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(height: 8),
                      Text('Zemin Kat: 7/24 açık'),
                      Text('Diğer Katlar: Hafta içi 08:00 - 17:00'),
                      Text('Hafta sonu diğer katlar: 09:00 - 16:00'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text('Doluluk Oranı', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 8),
              occupancyCard('Zemin Kat', groundFloorOccupancy, Icons.meeting_room),
              occupancyCard('1. Kat', firstFloorOccupancy, Icons.looks_one),
              occupancyCard('2. Kat', secondFloorOccupancy, Icons.looks_two),
              occupancyCard('3. Kat', thirdFloorOccupancy, Icons.looks_3),
              if (groundFloorOccupancy > 85)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Zemin kat çok yoğun, üst katları tercih edebilirsiniz.',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              SizedBox(height: 24),
              Text('Kitap Arama', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 8),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Kitap adı girin...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
              ),
              SizedBox(height: 16),
              if (_searchQuery.isNotEmpty && filteredBooks.isEmpty)
                Text('Aradığınız kitap bulunamadı.', style: TextStyle(color: Colors.red)),
              ...filteredBooks.map((book) => Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 1,
                    child: ListTile(
                      leading: Icon(Icons.book, color: Colors.red),
                      title: Text(book),
                      ),
                    )),
              SizedBox(height: 16),
              TextButton.icon(
                icon: Icon(Icons.open_in_new, color: Colors.red),
                label: Text('Fırat Üniversitesi Kütüphane Kataloğu'),
                onPressed: () {
                  // url_launcher ile açılabilir
                  // launchUrl(Uri.parse('https://katalog.firat.edu.tr/'));
                },
              ),
              
              // Alt boşluk
              SizedBox(height: 80),
            ],
          ),
        ],
      ),
    );
  }



  Widget occupancyCard(String label, int percent, IconData icon) {
    Color color = percent > 80
        ? Colors.red
        : percent > 50
            ? Colors.orange
            : Colors.green;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: percent / 100,
                    backgroundColor: Colors.grey[200],
                    color: color,
                  ),
                  SizedBox(height: 4),
                  Text('%$percent dolu', style: TextStyle(color: color)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 
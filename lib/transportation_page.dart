import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class TransportationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ulaşım'),
        backgroundColor: Color(0xFF8B0000),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kampüs Haritası
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(38.6790, 39.1970), // Fırat Üniversitesi - güncellenmiş merkez
                    initialZoom: 15.0,
                    minZoom: 14.0,
                    maxZoom: 18.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.kampusum_yeni',
                    ),
                    MarkerLayer(
                      markers: [
                        // Ana Giriş (Merkez)
                        _buildMarker(
                          LatLng(38.6765, 39.1953),
                          'Ana Giriş',
                          Icons.directions_bus,
                          Colors.blue,
                        ),
                        // Rektörlük (OpenStreetMap koordinatları)
                        _buildMarker(
                          LatLng(38.678150, 39.201716),
                          'Rektörlük',
                          Icons.account_balance,
                          Color(0xFF8B0000),
                        ),
                        // Mühendislik Fakültesi (OpenStreetMap koordinatları)
                        _buildMarker(
                          LatLng(38.674721, 39.192535),
                          'Mühendislik Fakültesi',
                          Icons.school,
                          Colors.red,
                        ),
                        // Tıp Fakültesi (Google Maps koordinatları)
                        _buildMarker(
                          LatLng(38.67874611364284, 39.20283254703138),
                          'Tıp Fakültesi',
                          Icons.local_hospital,
                          Colors.green,
                        ),
                        // Eğitim Fakültesi (OpenStreetMap koordinatları)
                        _buildMarker(
                          LatLng(38.680181, 39.194748),
                          'Eğitim Fakültesi',
                          Icons.school,
                          Colors.orange,
                        ),
                        // Fen Fakültesi (OpenStreetMap koordinatları)
                        _buildMarker(
                          LatLng(38.680493, 39.201450),
                          'Fen Fakültesi',
                          Icons.science,
                          Colors.purple,
                        ),
                        // İİBF (OpenStreetMap koordinatları)
                        _buildMarker(
                          LatLng(38.684947, 39.192674),
                          'İİBF',
                          Icons.account_balance,
                          Colors.teal,
                        ),
                        // Veteriner Fakültesi (OpenStreetMap koordinatları)
                        _buildMarker(
                          LatLng(38.678917, 39.200517),
                          'Veteriner Fakültesi',
                          Icons.pets,
                          Colors.brown,
                        ),
                        // Su Bilimleri (OpenStreetMap koordinatları)
                        _buildMarker(
                          LatLng(38.680748, 39.200329),
                          'Su Bilimleri',
                          Icons.water,
                          Colors.blue,
                        ),
                        // Teknoloji Fakültesi (Google Maps koordinatları)
                        _buildMarker(
                          LatLng(38.68101087241957, 39.19547874558061),
                          'Teknoloji Fakültesi',
                          Icons.computer,
                          Colors.indigo,
                        ),
                        // Kütüphane (Google Maps koordinatları)
                        _buildMarker(
                          LatLng(38.68025993076909, 39.196022344856615),
                          'Kütüphane',
                          Icons.library_books,
                          Colors.amber,
                        ),
                        // Yemekhane (OpenStreetMap koordinatları)
                        _buildMarker(
                          LatLng(38.679387, 39.196491),
                          'Yemekhane',
                          Icons.restaurant,
                          Colors.pink,
                        ),
                        // Bilgisayar Mühendisliği (OpenStreetMap koordinatları)
                        _buildMarker(
                          LatLng(38.672824, 39.188200),
                          'Bilgisayar Mühendisliği',
                          Icons.computer,
                          Colors.deepPurple,
                        ),
                        // Atatürk Kongre Merkezi (OpenStreetMap koordinatları)
                        _buildMarker(
                          LatLng(38.674130, 39.189793),
                          'Atatürk Kongre Merkezi',
                          Icons.business,
                          Colors.deepOrange,
                        ),
                        // Spor Bilimleri Fakültesi (OpenStreetMap koordinatları)
                        _buildMarker(
                          LatLng(38.682151, 39.193130),
                          'Spor Bilimleri Fakültesi',
                          Icons.fitness_center,
                          Colors.green,
                        ),
                        // ATMler (OpenStreetMap koordinatları)
                        _buildMarker(
                          LatLng(38.678901, 39.201322),
                          'ATMler',
                          Icons.atm,
                          Colors.grey,
                        ),
                        // Teknik Bilimler MYO (OpenStreetMap koordinatları)
                        _buildMarker(
                          LatLng(38.686029, 39.190121),
                          'Teknik Bilimler MYO',
                          Icons.school,
                          Colors.indigo,
                        ),
                        // Sağlık Bilimleri Fakültesi (OpenStreetMap koordinatları)
                        _buildMarker(
                          LatLng(38.684637, 39.192213),
                          'Sağlık Bilimleri Fakültesi',
                          Icons.local_hospital,
                          Colors.pink,
                        ),
                        // İlahiyat Fakültesi (OpenStreetMap koordinatları)
                        _buildMarker(
                          LatLng(38.676278, 39.189016),
                          'İlahiyat Fakültesi',
                          Icons.church,
                          Colors.brown,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 16),
            
            // Harita Açıklaması
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Kampüs Haritası',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Haritada gösterilen işaretler:\n'
                    'Mavi: Ana Giriş (Otobüs Durağı)\n'
                    'Kırmızı: Mühendislik Fakültesi\n'
                    'Yeşil: Tıp Fakültesi\n'
                    'Turuncu: Eğitim Fakültesi\n'
                    'Mor: Fen Fakültesi\n'
                    'Turkuaz: İİBF\n'
                    'Kahverengi: Veteriner Fakültesi\n'
                    'Mavi: Su Bilimleri\n'
                    'İndigo: Teknoloji Fakültesi\n'
                    'Amber: Kütüphane\n'
                    'Pembe: Yemekhane\n'
                    'Kırmızı: Rektörlük\n'
                    'Mor: Bilgisayar Mühendisliği\n'
                    'Turuncu: Atatürk Kongre Merkezi\n'
                    'Yeşil: Spor Bilimleri Fakültesi\n'
                    'Gri: ATMler\n'
                    'İndigo: Teknik Bilimler MYO\n'
                    'Pembe: Sağlık Bilimleri Fakültesi\n'
                    'Kahverengi: İlahiyat Fakültesi',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[600],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Ulaşım Seçenekleri
            Text(
              'Ulaşım Seçenekleri',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8B0000),
              ),
            ),
            
            SizedBox(height: 16),
            
            // Otobüs
            _buildTransportCard(
              context,
              'Otobüs',
              'Şehir merkezinden kampüse düzenli otobüs seferleri',
              Icons.directions_bus,
              Color(0xFF8B0000), // Bordo renk
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BusInfoPage()),
              ),
            ),
            
            SizedBox(height: 12),
            
            // Minibüs
            _buildTransportCard(
              context,
              'Minibüs',
              'Kampüse minibüs ile ulaşım seçenekleri',
              Icons.local_taxi,
              Color(0xFF8B0000), // Bordo renk
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MinibusInfoPage()),
              ),
            ),
            
            SizedBox(height: 12),
            
            // Alt boşluk
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildTransportCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8B0000),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF8B0000),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Marker _buildMarker(LatLng point, String title, IconData icon, Color color) {
    return Marker(
      point: point,
      width: 40,
      height: 40,
      child: GestureDetector(
        onTap: () {
          // Marker'a tıklandığında bilgi göster
        },
        child: Container(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class BusInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Otobüs Hatları'),
        backgroundColor: Color(0xFF8B0000),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                         _buildInfoSection(
               '5, 6, 7 Numaralı Otobüsler',
               'Şehir merkezinden üniversiteye düzenli seferler yapar. 5 numaralı otobüs kampüs içine girer.',
               Color(0xFF6B7280), // Professional grayish color
             ),
             SizedBox(height: 16),
             _buildInfoSection(
               '22 Numaralı Otobüs',
               'Ahmet Kabaklı KYK\'dan her saat başı kalkar, kampüsü dolanır ve tekrar Ahmet Kabaklı KYK\'ya döner.',
               Color(0xFF6B7280), // Professional grayish color
             ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF8B0000).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color(0xFF8B0000).withOpacity(0.3)),
              ),
              child: Text(
                'Şehir merkezinden üniversite otobüslerine binilmesi halinde üniversiteye ulaşabilirsiniz.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF8B0000),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String description, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class MinibusInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minibüs Hatları'),
        backgroundColor: Color(0xFF8B0000),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                         _buildInfoSection(
               'Aspirin Minibüsü',
               'Ahmet Kabaklı\'dan kalkar. Her iki kampüsün yakınında bırakır. Sabahları sadece Ahmet Kabaklı KYK\'dan kalkan minibüsler üniversiteye bırakır ve geri döner.',
               Color(0xFF6B7280), // Professional grayish color
             ),
             SizedBox(height: 16),
             _buildInfoSection(
               '2. Etap Minibüsü',
               'Ahmet Kabaklı\'dan kalkar. Mühendislik kampüsünün yakınında bırakır.',
               Color(0xFF6B7280), // Professional grayish color
             ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF8B0000).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color(0xFF8B0000).withOpacity(0.3)),
              ),
              child: Text(
                'Şehir merkezinden kalkan minibüsler üniversite yakınından geçer. Mühendislik kampüsünde öğrenci bırakabilir.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF8B0000),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Önemli Duraklar:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8B0000),
              ),
            ),
            SizedBox(height: 16),
            _buildStopInfo('Ahmet Kabaklı KYK', 'Ana kalkış noktası'),
            _buildStopInfo('Mühendislik Kampüsü', '2. Etap ve Aspirin minibüsleri'),
            _buildStopInfo('Rektörlük Kampüsü', 'Aspirin minibüsü'),
            _buildStopInfo('Şehir Merkezi', 'Genel minibüs hatları'),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String description, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStopInfo(String stopName, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(Icons.circle, color: Color(0xFF8B0000), size: 8),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stopName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
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
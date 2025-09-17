import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CanteenDetailPage extends StatelessWidget {
  final Map<String, String> canteen;

  const CanteenDetailPage({Key? key, required this.canteen}) : super(key: key);

  // Kantin koordinatlarını döndüren fonksiyon
  LatLng _getCanteenCoordinates(String canteenName) {
    switch (canteenName) {
      case '30. Yıl Kantini':
        return LatLng(38.681930, 39.196451);
      case 'Kütüphane Kantini':
        return LatLng(38.679818, 39.195845);
      case 'C Blok Kantini':
        return LatLng(38.682126, 39.195024);
      case 'Eğitim Fakültesi Kantini':
        return LatLng(38.680257, 39.194627);
      case 'Mühendislik Kantini':
        return LatLng(38.674881, 39.192696);
      case 'Harput Dibek Kafe':
        return LatLng(38.674659, 39.190357);
      case 'Bilgisayar Mühendislik Kantini':
        return LatLng(38.672672, 39.188308);
      case 'İlahiyat Fakültesi Kantini':
        return LatLng(38.677992, 39.188967);
      default:
        // Varsayılan olarak Fırat Üniversitesi merkezi
        return LatLng(38.677756871771706, 39.19938067573801);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(canteen['name']!),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Color(0xFF8B0000),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kantin görseli ve başlık
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF8B0000),
                    Color(0xFF8B0000).withOpacity(0.8),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Arka plan deseni
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.1,
                      child: Icon(
                        Icons.local_cafe,
                        size: 120,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // İçerik
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            Icons.local_cafe,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          canteen['name']!,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

                         // Kantin bilgileri
             Padding(
               padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Konum bilgisi
                  _buildInfoCard(
                    icon: Icons.location_on,
                    title: 'Konum',
                    content: canteen['location']!,
                    color: Colors.blue,
                  ),
                  
                                     SizedBox(height: 12),
                   
                   // Açılış saatleri
                   _buildInfoCard(
                     icon: Icons.access_time,
                     title: 'Açılış Saatleri',
                     content: canteen['openingHours']!,
                     color: Colors.green,
                   ),
                   
                                      SizedBox(height: 16),
                   
                                       // Harita
                    Container(
                      height: 240,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                     child: ClipRRect(
                       borderRadius: BorderRadius.circular(12),
                                               child: FlutterMap(
                          options: MapOptions(
                            initialCenter: _getCanteenCoordinates(canteen['name']!),
                            initialZoom: 16,
                          ),
                         children: [
                           TileLayer(
                             urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                             userAgentPackageName: 'com.example.kampusum_yeni',
                           ),
                           MarkerLayer(
                             markers: [
                                                               Marker(
                                  point: _getCanteenCoordinates(canteen['name']!),
                                  width: 60,
                                  height: 60,
                                 child: Column(
                                   children: [
                                                                           Icon(
                                        Icons.location_on,
                                        color: Color(0xFF8B0000),
                                        size: 30,
                                      ),
                                     Container(
                                                                               padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                       decoration: BoxDecoration(
                                         color: Colors.white,
                                         borderRadius: BorderRadius.circular(8),
                                         boxShadow: [
                                           BoxShadow(
                                             color: Colors.black.withOpacity(0.2),
                                             spreadRadius: 1,
                                             blurRadius: 3,
                                             offset: Offset(0, 2),
                                           ),
                                         ],
                                       ),
                                                                               child: Text(
                                          canteen['name']!,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF8B0000),
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
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
                  
                                     // Alt boşluk
                   SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
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
import 'package:flutter/material.dart';
import 'dart:convert';

class EventDetailPage extends StatelessWidget {
  final Map<String, String> event;

  const EventDetailPage({Key? key, required this.event}) : super(key: key);

  Widget _buildImageWidget(String imagePath) {
    // Base64 data URL kontrolü
    if (imagePath.startsWith('data:image/')) {
      try {
        final base64Data = imagePath.split(',')[1];
        final bytes = base64Decode(base64Data);
        return Image.memory(
          bytes,
          width: double.infinity,
          height: 250,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: double.infinity,
              height: 250,
              color: Colors.grey[300],
              child: Icon(
                Icons.image_not_supported,
                size: 80,
                color: Colors.grey[600],
              ),
            );
          },
        );
      } catch (e) {
        return Container(
          width: double.infinity,
          height: 250,
          color: Colors.grey[300],
          child: Icon(
            Icons.image_not_supported,
            size: 80,
            color: Colors.grey[600],
          ),
        );
      }
    }
    // URL kontrolü (http veya https ile başlıyorsa)
    else if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: double.infinity,
            height: 250,
            color: Colors.grey[300],
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: 250,
            color: Colors.grey[300],
            child: Icon(
              Icons.image_not_supported,
              size: 80,
              color: Colors.grey[600],
            ),
          );
        },
      );
    } else {
      // Assets resmi
      return Image.asset(
        imagePath.isNotEmpty ? imagePath : 'assets/placeholder.jpg',
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: 250,
            color: Colors.grey[300],
            child: Icon(
              Icons.image_not_supported,
              size: 80,
              color: Colors.grey[600],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event['title'] ?? 'Etkinlik Detayı'),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Color(0xFF8B0000),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                         // Etkinlik görseli ve başlık
             Container(
               width: double.infinity,
               height: 250,
               child: Stack(
                 children: [
                   // Etkinlik resmi
                   _buildImageWidget(event['image'] ?? ''),
                   // Gradient overlay
                   Container(
                     decoration: BoxDecoration(
                       gradient: LinearGradient(
                         begin: Alignment.topCenter,
                         end: Alignment.bottomCenter,
                         colors: [
                           Colors.transparent,
                           Colors.black.withOpacity(0.6),
                         ],
                       ),
                     ),
                   ),
                   // İçerik
                   Positioned(
                     bottom: 20,
                     left: 20,
                     right: 20,
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Container(
                           padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                           decoration: BoxDecoration(
                             color: _getCategoryColor(event['category']!),
                             borderRadius: BorderRadius.circular(20),
                           ),
                           child: Text(
                             event['category'] ?? 'Genel',
                             style: TextStyle(
                               fontSize: 12,
                               fontWeight: FontWeight.bold,
                               color: Colors.white,
                             ),
                           ),
                         ),
                         SizedBox(height: 8),
                         Text(
                           event['title'] ?? 'Başlık Yok',
                           style: TextStyle(
                             fontSize: 24,
                             fontWeight: FontWeight.bold,
                             color: Colors.white,
                             shadows: [
                               Shadow(
                                 offset: Offset(0, 2),
                                 blurRadius: 4,
                                 color: Colors.black.withOpacity(0.5),
                               ),
                             ],
                           ),
                         ),
                       ],
                     ),
                   ),
                 ],
               ),
             ),

            // Etkinlik bilgileri
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tarih ve saat
                  _buildInfoCard(
                    icon: Icons.calendar_today,
                    title: 'Tarih ve Saat',
                    content: '${event['date'] ?? 'Tarih belirtilmemiş'} • ${event['time'] ?? 'Saat belirtilmemiş'}',
                    color: Colors.blue,
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Konum
                  _buildInfoCard(
                    icon: Icons.location_on,
                    title: 'Konum',
                    content: event['location'] ?? 'Konum belirtilmemiş',
                    color: Colors.green,
                  ),
                  
                  SizedBox(height: 24),
                  
                                     // Açıklama
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Row(
                         children: [
                           Icon(
                             Icons.info_outline,
                             color: Color(0xFF8B0000),
                             size: 24,
                           ),
                           SizedBox(width: 8),
                           Text(
                             'Açıklama',
                             style: TextStyle(
                               fontSize: 18,
                               fontWeight: FontWeight.bold,
                               color: Color(0xFF8B0000),
                             ),
                           ),
                         ],
                       ),
                       SizedBox(height: 12),
                       Text(
                         event['description'] ?? 'Açıklama bulunmuyor',
                         style: TextStyle(
                           fontSize: 14,
                           color: Colors.grey[700],
                           height: 1.5,
                         ),
                       ),
                     ],
                   ),
                   
                   SizedBox(height: 24),
                   
                   // Detaylar
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Row(
                         children: [
                           Icon(
                             Icons.details,
                             color: Color(0xFF8B0000),
                             size: 24,
                           ),
                           SizedBox(width: 8),
                           Text(
                             'Detaylar',
                             style: TextStyle(
                               fontSize: 18,
                               fontWeight: FontWeight.bold,
                               color: Color(0xFF8B0000),
                             ),
                           ),
                         ],
                       ),
                       SizedBox(height: 12),
                       Text(
                         event['details'] ?? 'Detay bilgisi bulunmuyor',
                         style: TextStyle(
                           fontSize: 14,
                           color: Colors.grey[700],
                           height: 1.5,
                         ),
                       ),
                     ],
                   ),
                  
                  // Alt boşluk
                  SizedBox(height: 40),
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

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Akademik':
        return Colors.blue;
      case 'Kültür-Sanat':
        return Colors.purple;
      case 'Spor':
        return Colors.green;
      default:
        return Color(0xFF8B0000);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Akademik':
        return Icons.school;
      case 'Kültür-Sanat':
        return Icons.palette;
      case 'Spor':
        return Icons.sports_soccer;
      default:
        return Icons.event;
    }
  }
} 
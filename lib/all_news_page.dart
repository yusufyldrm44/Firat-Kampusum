import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllNewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tüm Haberler'),
        backgroundColor: Color(0xFF8B0000),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('news')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Haberler yüklenirken hata oluştu',
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.newspaper,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Henüz haber bulunmuyor',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length + 1, // +1 for bottom padding
            itemBuilder: (context, index) {
              // Son eleman için boşluk ekle
              if (index == snapshot.data!.docs.length) {
                return SizedBox(height: 32); // Alt boşluk
              }
              
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;
              
              return Card(
                margin: EdgeInsets.only(bottom: 16),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                                         // Haber resmi
                     if (data['image'] != null && data['image'].toString().isNotEmpty)
                       ClipRRect(
                         borderRadius: BorderRadius.only(
                           topLeft: Radius.circular(12),
                           topRight: Radius.circular(12),
                         ),
                         child: _buildImageWidget(data['image']),
                       ),
                    
                    // Haber içeriği
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Color(0xFF8B0000),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'HABER',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Text(
                                data['date'] ?? '',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Text(
                            data['title'] ?? 'Başlıksız',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            data['desc'] ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: 12),
                          if (data['detail'] != null && data['detail'].toString().isNotEmpty) ...[
                            Text(
                              data['detail'],
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                                height: 1.4,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 12),
                          ],
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: Colors.grey[500],
                              ),
                              SizedBox(width: 4),
                              Text(
                                _formatTimestamp(data['timestamp']),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildImageWidget(String imagePath) {
    // URL kontrolü (http veya https ile başlıyorsa)
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 200,
            width: double.infinity,
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
            height: 200,
            width: double.infinity,
            color: Colors.grey[300],
            child: Icon(
              Icons.image_not_supported,
              size: 50,
              color: Colors.grey[600],
            ),
          );
        },
      );
    } else {
      // Assets resmi
      return Image.asset(
        imagePath,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey[300],
            child: Icon(
              Icons.image_not_supported,
              size: 50,
              color: Colors.grey[600],
            ),
          );
        },
      );
    }
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'Bilinmiyor';
    
    try {
      if (timestamp is Timestamp) {
        final date = timestamp.toDate();
        return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
      }
    } catch (e) {
      print('Tarih formatlanırken hata: $e');
    }
    
    return 'Bilinmiyor';
  }
} 
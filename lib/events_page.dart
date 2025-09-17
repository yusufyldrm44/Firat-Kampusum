import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'event_detail_page.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedCategory = 'Tümü';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Etkinlikler',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF8B0000),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: 'Tümü'),
            Tab(text: 'Akademik'),
            Tab(text: 'Kültür-Sanat'),
            Tab(text: 'Spor'),
          ],
        ),
      ),
              body: TabBarView(
          controller: _tabController,
          children: [
            _buildEventsList('Tümü'),
            _buildEventsList('Akademik'),
            _buildEventsList('Kültür-Sanat'),
            _buildEventsList('Spor'),
          ],
        ),
    );
  }

  Widget _buildEventsList(String category) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('events')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Etkinlikler yüklenirken hata oluştu',
              style: TextStyle(color: Colors.red),
            ),
          );
        }
        
        List<Map<String, String>> events = [];
        
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          // Firestore'dan gelen verileri dönüştür
          events = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return <String, String>{
              'title': data['title']?.toString() ?? '',
              'category': data['category']?.toString() ?? '',
              'date': data['date']?.toString() ?? '',
              'time': data['time']?.toString() ?? '',
              'location': data['location']?.toString() ?? '',
              'description': data['description']?.toString() ?? '',
              'details': data['details']?.toString() ?? '',
              'image': data['image']?.toString() ?? 'assets/placeholder.jpg',
            };
          }).toList();
        }
        
        // Kategori filtreleme
        if (category != 'Tümü') {
          events = events.where((event) => event['category'] == category).toList();
        }
        
        if (events.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_busy,
                  size: 80,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16),
                Text(
                  'Bu kategoride etkinlik bulunmuyor',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Yakında yeni etkinlikler eklenecek',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: events.length + 1, // +1 for bottom padding
      itemBuilder: (context, index) {
        if (index == events.length) {
          // Alt boşluk
          return SizedBox(height: 80);
        }
        final event = events[index];
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Image
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        // Event image
                        _buildImageWidget(event['image'] ?? 'assets/placeholder.jpg'),
                        // Gradient overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.3),
                              ],
                            ),
                          ),
                        ),
                        // Category badge
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(event['category']),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              event['category'] ?? 'Genel',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Event Content
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        event['title'] ?? 'Başlık Yok',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      // Date and Time
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 16, color: Color(0xFF8B0000)),
                          SizedBox(width: 6),
                          Text(
                            event['date'] ?? 'Tarih belirtilmemiş',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 16),
                          Icon(Icons.access_time, size: 16, color: Color(0xFF8B0000)),
                          SizedBox(width: 6),
                          Text(
                            event['time'] ?? 'Saat belirtilmemiş',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      // Location
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 16, color: Color(0xFF8B0000)),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              event['location'] ?? 'Konum belirtilmemiş',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      // Description
                      Text(
                        event['description'] ?? 'Açıklama bulunmuyor',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 16),
                      // Action Button
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EventDetailPage(event: event),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF8B0000),
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Detayları Gör',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
      },
    );
  }



  Color _getCategoryColor(String? category) {
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

  IconData _getCategoryIcon(String? category) {
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

  Widget _buildImageWidget(String imagePath) {
    // Base64 data URL kontrolü
    if (imagePath.startsWith('data:image/')) {
      try {
        final base64Data = imagePath.split(',')[1];
        final bytes = base64Decode(base64Data);
        return Image.memory(
          bytes,
          width: double.infinity,
          height: 160,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: double.infinity,
              height: 160,
              color: Colors.grey[300],
              child: Icon(
                Icons.image_not_supported,
                size: 50,
                color: Colors.grey[600],
              ),
            );
          },
        );
      } catch (e) {
        return Container(
          width: double.infinity,
          height: 160,
          color: Colors.grey[300],
          child: Icon(
            Icons.image_not_supported,
            size: 50,
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
        height: 160,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: double.infinity,
            height: 160,
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
            height: 160,
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
        width: double.infinity,
        height: 160,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: 160,
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
}
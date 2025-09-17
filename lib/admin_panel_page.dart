import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_news_page.dart';
import 'admin_events_page.dart';
import 'admin_notifications_page.dart';
import 'admin_contact_page.dart';
import 'admin_classrooms_page.dart';

class AdminPanelPage extends StatefulWidget {
  @override
  _AdminPanelPageState createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  Key _refreshKey = UniqueKey();
  
  void _refreshStatistics() {
    setState(() {
      _refreshKey = UniqueKey();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Paneli'),
        backgroundColor: Color(0xFF8B0000),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hoşgeldin Kartı
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF8B0000), Color(0xFFB22222)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/firat.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Admin Paneli',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Fırat Üniversitesi Kampüsüm',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Uygulama yönetimi için aşağıdaki seçenekleri kullanabilirsiniz.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // İstatistikler
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hızlı İstatistikler',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B0000),
                  ),
                ),
                                  IconButton(
                    icon: Icon(Icons.refresh, color: Color(0xFF8B0000)),
                    onPressed: _refreshStatistics,
                    tooltip: 'Yenile',
                  ),
              ],
            ),
            
            SizedBox(height: 16),
            
            FutureBuilder<List<Map<String, dynamic>>>(
              key: _refreshKey,
              future: _getStatistics(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Row(
                    children: [
                      Expanded(child: _buildStatCard('Haberler', '...', Icons.newspaper, Colors.blue)),
                      SizedBox(width: 12),
                      Expanded(child: _buildStatCard('Bildirimler', '...', Icons.notifications, Colors.orange)),
                      SizedBox(width: 12),
                      Expanded(child: _buildStatCard('Mesajlar', '...', Icons.message, Colors.green)),
                    ],
                  );
                }
                
                final stats = snapshot.data ?? [
                  {'news': 0, 'notifications': 0, 'messages': 0}
                ];
                final data = stats.first;
                
                return Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Haberler',
                        data['news'].toString(),
                        Icons.newspaper,
                        Colors.blue,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Bildirimler',
                        data['notifications'].toString(),
                        Icons.notifications,
                        Colors.orange,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Mesajlar',
                        data['messages'].toString(),
                        Icons.message,
                        Colors.green,
                      ),
                    ),
                  ],
                );
              },
            ),
            
            SizedBox(height: 32),
            
            // Yönetim Menüsü
            Text(
              'Yönetim Menüsü',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8B0000),
              ),
            ),
            
            SizedBox(height: 16),
            
            // Haber Yönetimi
            _buildAdminCard(
              context,
              'Haber Yönetimi',
              'Haber ekle, düzenle veya sil',
              Icons.newspaper,
              Colors.blue,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminNewsPage()),
              ),
            ),
            
            SizedBox(height: 12),
            
            // Etkinlik Yönetimi
            _buildAdminCard(
              context,
              'Etkinlik Yönetimi',
              'Etkinlik ekle, düzenle veya sil',
              Icons.event,
              Colors.purple,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminEventsPage()),
              ),
            ),
            
            SizedBox(height: 12),
            
            // Bildirim Yönetimi
            _buildAdminCard(
              context,
              'Bildirim Gönder',
              'Kullanıcılara bildirim gönder',
              Icons.notifications_active,
              Colors.orange,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminNotificationsPage()),
              ),
            ),
            
            SizedBox(height: 12),
            
            // İletişim Mesajları
            _buildAdminCard(
              context,
              'İletişim Mesajları',
              'Kullanıcı mesajlarını görüntüle',
              Icons.message,
              Colors.green,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminContactPage()),
              ),
            ),
            
            SizedBox(height: 12),
            
            // Derslik Yönetimi
            _buildAdminCard(
              context,
              'Derslik Yönetimi',
              'Derslik bilgilerini düzenle',
              Icons.class_,
              Colors.purple,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminClassroomsPage()),
              ),
            ),
            
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }



  Future<List<Map<String, dynamic>>> _getStatistics() async {
    try {
      // Haber sayısını al
      final newsSnapshot = await FirebaseFirestore.instance
          .collection('news')
          .get();
      
      // Bildirim sayısını al
      final notificationsSnapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .get();
      
      // Mesaj sayısını al
      final messagesSnapshot = await FirebaseFirestore.instance
          .collection('contact_messages')
          .get();
      
      return [
        {
          'news': newsSnapshot.docs.length,
          'notifications': notificationsSnapshot.docs.length,
          'messages': messagesSnapshot.docs.length,
        }
      ];
    } catch (e) {
      print('İstatistikler alınırken hata: $e');
      return [
        {
          'news': 0,
          'notifications': 0,
          'messages': 0,
        }
      ];
    }
  }

  Widget _buildAdminCard(
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
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
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
} 
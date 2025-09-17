import 'package:flutter/material.dart';

class ClubDetailPage extends StatelessWidget {
  final Map<String, String> club;

  ClubDetailPage({required this.club});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(club['name']!),
        centerTitle: true,
        backgroundColor: Color(0xFF8B0000),
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kulüp başlığı
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF8B0000),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 40,
                    child: Icon(
                      Icons.group,
                      color: Color(0xFF8B0000),
                      size: 40,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    club['name']!,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      club['category']!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Kulüp bilgileri
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kulüp Bilgileri',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8B0000),
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    // Danışman bilgisi
                    _buildInfoRow(
                      icon: Icons.person,
                      title: 'Danışman',
                      value: club['advisor']!,
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Başkan bilgisi
                    _buildInfoRow(
                      icon: Icons.leaderboard,
                      title: 'Başkan',
                      value: club['president']!,
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Kategori bilgisi
                    _buildInfoRow(
                      icon: Icons.category,
                      title: 'Kategori',
                      value: club['category']!,
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 24),
            
            // Kulüp açıklaması
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kulüp Hakkında',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8B0000),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Bu kulüp ${club['category']!} kategorisinde yer almaktadır. Kulüp faaliyetleri ve etkinlikleri hakkında daha detaylı bilgi almak için kulüp danışmanı veya başkanı ile iletişime geçebilirsiniz.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Color(0xFF8B0000).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Color(0xFF8B0000),
            size: 20,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


} 
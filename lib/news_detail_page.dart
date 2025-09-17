import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class NewsDetailPage extends StatelessWidget {
  final Map<String, String> newsItem;

  const NewsDetailPage({Key? key, required this.newsItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Haber Detayı'),
        backgroundColor: Color(0xFF8B0000),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () => _shareNews(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Haber Resmi
            Container(
              width: double.infinity,
              height: 250,
              child: Image.asset(
                newsItem['image']!,
                fit: BoxFit.cover,
              ),
            ),
            
            // Haber İçeriği
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Haber Başlığı
                  Text(
                    newsItem['title']!,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Haber Meta Bilgileri
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Color(0xFF8B0000),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'HABER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Text(
                        newsItem['date']!,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.visibility, size: 16, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Text(
                        '1.2K görüntüleme',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Haber Açıklaması
                  Text(
                    newsItem['desc']!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.6,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Haber Detayı
                  Text(
                    newsItem['detail']!,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      height: 1.7,
                    ),
                  ),
                  

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  void _shareNews(BuildContext context) {
    final String shareText = '''
${newsItem['title']!}

${newsItem['desc']!}

${newsItem['detail']!}

Tarih: ${newsItem['date']!}

Fırat Üniversitesi Kampüsüm Uygulaması
''';

    Share.share(
      shareText,
      subject: newsItem['title']!,
    );
  }
} 
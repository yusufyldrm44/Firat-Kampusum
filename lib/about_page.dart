import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hakkımızda'),
        backgroundColor: Color(0xFF8B0000),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section - Üniversite Logosu ve Başlık
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF8B0000),
                    Color(0xFFB22222),
                  ],
                ),
              ),
              child: Column(
                children: [
                  // Üniversite Logosu
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/firat.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Fırat Üniversitesi',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '1975\'ten Günümüze',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            
            // Üniversite Hakkında
            Container(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Üniversitemiz Hakkında'),
                  SizedBox(height: 16),
                  Text(
                    'Fırat Üniversitesi, 1975 yılında Elazığ\'da kurulmuş, Türkiye\'nin önde gelen devlet üniversitelerinden biridir. '
                    'Kurulduğu günden bu yana eğitim, araştırma ve topluma hizmet alanlarında önemli başarılara imza atmıştır.\n\n'
                    'Üniversitemiz, modern eğitim anlayışı, güçlü akademik kadrosu ve gelişmiş altyapısı ile öğrencilerine kaliteli '
                    'bir eğitim ortamı sunmaktadır. 16 fakülte, 4 enstitü, 4 yüksekokul ve 12 meslek yüksekokulu ile '
                    '45.000\'den fazla öğrenciye hizmet vermektedir.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            
            // Misyon ve Vizyon
            Container(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Misyonumuz',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B0000),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Bilim, teknoloji ve sanat alanlarında evrensel standartlarda eğitim-öğretim, araştırma ve topluma hizmet faaliyetleri yürüterek, '
                    'ülkemizin ve insanlığın gelişimine katkı sağlayan, değer üreten ve değer katan bir üniversite olmaktır.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Vizyonumuz',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B0000),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Ulusal ve uluslararası düzeyde tanınan, tercih edilen, öncü ve yenilikçi bir üniversite olarak, '
                    'bilim dünyasında söz sahibi olmak ve toplumsal kalkınmaya öncülük etmektir.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 32),
            
            // İstatistikler
            Container(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Rakamlarla Fırat Üniversitesi'),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard('45,000+', 'Öğrenci', Icons.school),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard('1,200+', 'Akademisyen', Icons.person),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard('16', 'Fakülte', Icons.account_balance),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard('4', 'Enstitü', Icons.science),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard('4', 'Yüksekokul', Icons.school),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard('12', 'Meslek Yüksekokulu', Icons.work),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            

            
            // Başarılar
            Container(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Başarılarımız'),
                  SizedBox(height: 16),
                  _buildAchievementCard(
                    'Times Higher Education Sıralaması',
                    '201-250 bandında yer alma',
                    Icons.trending_up,
                    Colors.blue,
                  ),
                  SizedBox(height: 8),
                  _buildAchievementCard(
                    'Akademisyen Başarısı',
                    '46 akademisyen dünya listesinde',
                    Icons.star,
                    Colors.orange,
                  ),
                  SizedBox(height: 8),
                  _buildAchievementCard(
                    'Araştırma Projeleri',
                    'TÜBİTAK ve AB projeleri',
                    Icons.science,
                    Colors.green,
                  ),
                  SizedBox(height: 8),
                  _buildAchievementCard(
                    'Uluslararası İşbirlikleri',
                    'Erasmus+ ve diğer programlar',
                    Icons.public,
                    Colors.purple,
                  ),
                ],
              ),
            ),
            

            
            // Geliştirici Bilgileri
            Container(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Text(
                      'Bu uygulama BERA YAZILIM tarafından geliştirilmiştir',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Color(0xFF8B0000),
      ),
    );
  }



  Widget _buildStatCard(String value, String label, IconData icon) {
    return Container(
      height: 120,
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Color(0xFF8B0000), size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8B0000),
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
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



  Widget _buildAchievementCard(String title, String description, IconData icon, Color color) {
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
        ],
      ),
    );
  }


} 
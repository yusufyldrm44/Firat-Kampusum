import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Projeler'),
        backgroundColor: Color(0xFF8B0000),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
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
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.science,
                    size: 64,
                    color: Colors.white,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Bilimsel Araştırma Projeleri',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Fırat Üniversitesi Bilimsel Araştırma Projeleri Koordinasyon Birimi',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // FÜBAP Hakkında
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FÜBAP Hakkında',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B0000),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Fırat Üniversitesi Bilimsel Araştırma Projeleri (FÜBAP) Koordinasyon Birimi, '
                    'üniversitemizde yürütülen bilimsel araştırma projelerinin koordinasyonunu sağlamakta '
                    've akademisyenlerimizin araştırma faaliyetlerini desteklemektedir.\n\n'
                    'FÜBAP, TÜBİTAK, AB projeleri, ulusal ve uluslararası araştırma projelerinin '
                    'yönetimi, bütçe takibi ve raporlama süreçlerinde akademisyenlerimize destek vermektedir.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Proje Türleri
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Proje Türleri',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B0000),
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildProjectTypeCard(
                    'TÜBİTAK Projeleri',
                    'Türkiye Bilimsel ve Teknolojik Araştırma Kurumu destekli projeler',
                    Icons.science,
                    Colors.blue,
                  ),
                  SizedBox(height: 12),
                  _buildProjectTypeCard(
                    'AB Projeleri',
                    'Avrupa Birliği destekli araştırma ve geliştirme projeleri',
                    Icons.public,
                    Colors.green,
                  ),
                  SizedBox(height: 12),
                  _buildProjectTypeCard(
                    'Performans Projeleri',
                    'Üniversite içi performans değerlendirme projeleri',
                    Icons.assessment,
                    Colors.orange,
                  ),
                  SizedBox(height: 12),
                  _buildProjectTypeCard(
                    'Dış Kaynaklı Projeler',
                    'Kurum dışı kaynaklardan destek alan projeler',
                    Icons.business,
                    Colors.purple,
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Hizmetler
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FÜBAP Hizmetleri',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B0000),
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildServiceItem('Proje Başvuru Desteği', 'Proje önerilerinin hazırlanması ve sunulması'),
                  _buildServiceItem('Bütçe Yönetimi', 'Proje bütçelerinin planlanması ve takibi'),
                  _buildServiceItem('Raporlama', 'Proje ilerleme ve final raporlarının hazırlanması'),
                  _buildServiceItem('Harcama Takibi', 'Proje harcamalarının kontrolü ve denetimi'),
                  _buildServiceItem('Yasal Danışmanlık', 'Proje sözleşmeleri ve yasal süreçler'),
                  _buildServiceItem('Eğitim ve Seminerler', 'Proje yönetimi konusunda eğitimler'),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // FÜBAP Sistemine Erişim
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.computer, color: Colors.blue[700], size: 24),
                      SizedBox(width: 8),
                      Text(
                        'FÜBAP Sistemi',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'FÜBAP otomasyon sistemine erişim için aşağıdaki butona tıklayarak '
                    'resmi web sitesine yönlendirileceksiniz.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue[800],
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () => _launchFUBAP(context),
                      icon: Icon(Icons.open_in_new, size: 20),
                      label: Text(
                        'FÜBAP Sistemine Git',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // İletişim Bilgileri
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'İletişim',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B0000),
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildContactInfo(Icons.email, 'E-posta', 'fubap@firat.edu.tr'),
                  _buildContactInfo(Icons.phone, 'Telefon', '+90 424 237 00 00'),
                  _buildContactInfo(Icons.location_on, 'Adres', 'Fırat Üniversitesi, FÜBAP Birimi'),
                ],
              ),
            ),
            
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectTypeCard(String title, String description, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
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
                    color: color,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(String title, String description) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Color(0xFF8B0000), size: 20),
          SizedBox(width: 12),
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
                SizedBox(height: 2),
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

  Widget _buildContactInfo(IconData icon, String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Color(0xFF8B0000)),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _launchFUBAP(BuildContext context) async {
    const url = 'https://bap.firat.edu.tr/';
    try {
      final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('FÜBAP sitesi açılamadı. Lütfen internet bağlantınızı kontrol edin.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
} 
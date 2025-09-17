import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('İletişim'),
        backgroundColor: Color(0xFF8B0000),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // İletişim Bilgileri Kartı
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
                  Row(
                    children: [
                      Icon(Icons.contact_phone, color: Color(0xFF8B0000), size: 24),
                      SizedBox(width: 8),
                      Text(
                        'İletişim Bilgileri',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B0000),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  
                  // Adres
                  _buildContactItem(
                    Icons.location_on,
                    'Adres',
                    'Fırat Üniversitesi\nÜniversite, Fırat Ünv., 23119 Elâzığ Merkez/Elazığ Merkez/Elazığ',
                    () => _launchMaps(),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Telefon
                  _buildContactItem(
                    Icons.phone,
                    'Telefon',
                    '+90 424 237 00 00',
                    () => _launchPhone(),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // E-posta
                  _buildContactItem(
                    Icons.email,
                    'E-posta',
                    'info@firat.edu.tr',
                    () => _launchEmail(),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Web Sitesi
                  _buildContactItem(
                    Icons.web,
                    'Web Sitesi',
                    'www.firat.edu.tr',
                    () => _launchWebsite(),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Sosyal Medya Hesapları
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
                  Row(
                    children: [
                      Icon(Icons.share, color: Color(0xFF8B0000), size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Sosyal Medya',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B0000),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Bizi sosyal medyada takip edin',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  // X (Twitter)
                  _buildSocialMediaItem(
                    'X (Twitter)',
                    '@firatresmihesap',
                    Icons.close_rounded, // X logosu için close_rounded ikonu kullanıyoruz
                    Color(0xFF000000), // X'in siyah rengi
                    () => _launchSocialMedia('https://x.com/firatresmihesap'),
                  ),
                  
                  SizedBox(height: 12),
                  
                  // Facebook
                  _buildSocialMediaItem(
                    'Facebook',
                    '@frtbasinyayin',
                    Icons.facebook,
                    Color(0xFF1877F2), // Facebook'un mavi rengi
                    () => _launchSocialMedia('https://www.facebook.com/frtbasinyayin'),
                  ),
                  
                  SizedBox(height: 12),
                  
                  // YouTube
                  _buildSocialMediaItem(
                    'YouTube',
                    'Fırat Üniversitesi Resmi Hesabı',
                    Icons.play_circle_filled,
                    Color(0xFFFF0000), // YouTube'un kırmızı rengi
                    () => _launchSocialMedia('https://www.youtube.com/c/F%C4%B1rat%C3%9CniversitesiResmiHesab%C4%B1'),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // İletişim Formu
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
                  Row(
                    children: [
                      Icon(Icons.message, color: Color(0xFF8B0000), size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Bize Ulaşın',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B0000),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Sorularınız veya önerileriniz için aşağıdaki formu kullanabilirsiniz.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // İsim
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Ad Soyad *',
                            hintText: 'Adınızı ve soyadınızı girin',
                            prefixIcon: Icon(Icons.person, color: Color(0xFF8B0000)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Color(0xFF8B0000), width: 2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Lütfen adınızı girin';
                            }
                            return null;
                          },
                        ),
                        
                        SizedBox(height: 16),
                        
                        // E-posta
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'E-posta *',
                            hintText: 'E-posta adresinizi girin',
                            prefixIcon: Icon(Icons.email, color: Color(0xFF8B0000)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Color(0xFF8B0000), width: 2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Lütfen e-posta adresinizi girin';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                              return 'Geçerli bir e-posta adresi girin';
                            }
                            return null;
                          },
                        ),
                        
                        SizedBox(height: 16),
                        
                        // Konu
                        TextFormField(
                          controller: _subjectController,
                          decoration: InputDecoration(
                            labelText: 'Konu *',
                            hintText: 'Mesajınızın konusunu girin',
                            prefixIcon: Icon(Icons.subject, color: Color(0xFF8B0000)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Color(0xFF8B0000), width: 2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Lütfen konu girin';
                            }
                            return null;
                          },
                        ),
                        
                        SizedBox(height: 16),
                        
                        // Mesaj
                        TextFormField(
                          controller: _messageController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            labelText: 'Mesaj *',
                            hintText: 'Mesajınızı buraya yazın...',
                            alignLabelWithHint: true,
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(bottom: 60),
                              child: Icon(Icons.message, color: Color(0xFF8B0000)),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Color(0xFF8B0000), width: 2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Lütfen mesajınızı girin';
                            }
                            if (value.length < 10) {
                              return 'Mesajınız en az 10 karakter olmalıdır';
                            }
                            return null;
                          },
                        ),
                        
                        SizedBox(height: 24),
                        
                        // Gönder Butonu
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF8B0000),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.send, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Mesaj Gönder',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Çalışma Saatleri
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
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Color(0xFF8B0000), size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Çalışma Saatleri',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B0000),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildWorkingHours('Pazartesi - Cuma', '08:00 - 17:00'),
                  _buildWorkingHours('Cumartesi', '08:00 - 12:00'),
                  _buildWorkingHours('Pazar', 'Kapalı'),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // OpenStreetMap
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
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
                borderRadius: BorderRadius.circular(16),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(38.677756871771706, 39.19938067573801), // Fırat Üniversitesi koordinatları (Google Maps)
                    initialZoom: 15.0,
                    minZoom: 10.0,
                    maxZoom: 18.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.kampusum_yeni',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(38.677756871771706, 39.19938067573801), // Fırat Üniversitesi (Google Maps)
                          width: 40,
                          height: 40,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF8B0000),
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
                              Icons.location_on,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Alt boşluk - telefon navigasyon çubuğu için
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFF8B0000).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Color(0xFF8B0000), size: 20),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkingHours(String day, String hours) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          Text(
            hours,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF8B0000),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaItem(String platform, String handle, IconData icon, Color iconColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    platform,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    handle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.open_in_new, color: Colors.grey[400], size: 20),
          ],
        ),
      ),
    );
  }

  void _launchPhone() async {
    const phoneNumber = '+904242370000';
    final uri = Uri.parse('tel:$phoneNumber');
    try {
      await launchUrl(uri);
    } catch (e) {
      _showErrorDialog('Telefon açılamadı');
    }
  }

  void _launchEmail() async {
    const email = 'info@firat.edu.tr';
    final uri = Uri.parse('mailto:$email');
    try {
      await launchUrl(uri);
    } catch (e) {
      _showErrorDialog('E-posta uygulaması açılamadı');
    }
  }

  void _launchWebsite() async {
    const url = 'https://www.firat.edu.tr';
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      _showErrorDialog('Web sitesi açılamadı');
    }
  }

  void _launchMaps() async {
    const address = 'Fırat Üniversitesi, Elazığ';
    final uri = Uri.parse('https://maps.google.com/?q=${Uri.encodeComponent(address)}');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      _showErrorDialog('Harita açılamadı');
    }
  }

  void _launchSocialMedia(String url) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      _showErrorDialog('Sosyal medya hesabı açılamadı');
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Loading göster
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(
              color: Color(0xFF8B0000),
            ),
          );
        },
      );

      try {
        // Firestore'a mesajı kaydet
        await FirebaseFirestore.instance.collection('contact_messages').add({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'subject': _subjectController.text.trim(),
          'message': _messageController.text.trim(),
          'timestamp': FieldValue.serverTimestamp(),
          'userId': FirebaseAuth.instance.currentUser?.uid,
          'userEmail': FirebaseAuth.instance.currentUser?.email,
          'status': 'new', // new, read, replied
          'isRead': false,
        });

        // Loading dialog'u kapat
        Navigator.of(context).pop();

        // Başarı mesajı göster
        _showSuccessDialog();
        
        // Formu temizle
        _nameController.clear();
        _emailController.clear();
        _subjectController.clear();
        _messageController.clear();
        
      } catch (e) {
        // Loading dialog'u kapat
        Navigator.of(context).pop();
        
        // Hata mesajı göster
        _showErrorDialog('Mesaj gönderilirken bir hata oluştu: $e');
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 24),
              SizedBox(width: 8),
              Text('Başarılı'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Mesajınız başarıyla gönderildi!'),
              SizedBox(height: 8),
              Text(
                'Mesajınız veritabanımıza kaydedildi ve en kısa sürede size dönüş yapacağız.',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Tamam'),
            ),
          ],
        );
      },
    );
  }



  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red, size: 24),
              SizedBox(width: 8),
              Text('Hata'),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Tamam'),
            ),
          ],
        );
      },
    );
  }
} 
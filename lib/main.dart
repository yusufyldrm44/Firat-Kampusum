import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'splash_screen.dart';
import 'initialize_data.dart';
import 'theme_provider.dart';

import 'login_page.dart';
import 'profile_edit_page.dart';
import 'library_page.dart'; // Added import for LibraryPage
import 'academic_calendar_page.dart';
import 'clubs_page.dart'; // Added import for ClubsPage
import 'classrooms_page.dart'; // Added import for ClassroomsPage
import 'canteens_page.dart'; // Added import for CanteensPage
import 'transportation_page.dart'; // Added import for TransportationPage
import 'news_detail_page.dart'; // Added import for NewsDetailPage
import 'notifications_page.dart'; // Added import for NotificationsPage
import 'events_page.dart'; // Added import for EventsPage
import 'contact_page.dart'; // Added import for ContactPage
import 'about_page.dart'; // Added import for AboutPage
import 'projects_page.dart'; // Added import for ProjectsPage
import 'all_news_page.dart'; // Added import for AllNewsPage


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Statik verileri başlat (sadece ilk kez)
  await InitializeData.initializeAllData();
  
  // Yeni fakülte ve derslik verilerini yüklemek için geçici olarak aktif
  // await InitializeData.resetAndInitializeData();
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: KampusumApp(),
    ),
  );
}

class KampusumApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return MaterialApp(
      title: 'Fırat Üniversitesi Kampüsüm',
      theme: ThemeProvider.lightTheme,
      darkTheme: ThemeProvider.darkTheme,
      themeMode: themeProvider.themeMode,
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return HomePage();
        }
        return LoginPage();
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() async {
    _videoController = VideoPlayerController.asset('assets/firat_video.mp4');
    try {
      await _videoController!.initialize();
      await _videoController!.setLooping(true);
      setState(() {
        _isVideoInitialized = true;
      });
      // Video otomatik başlat
      await _videoController!.play();
    } catch (e) {
      print('Video yüklenirken hata: $e');
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 40,
          child: Image.asset(
            'assets/firat.png',
            fit: BoxFit.contain,
          ),
        ),
        centerTitle: true,
        actions: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('userNotifications')
                .where('isRead', isEqualTo: false)
                .snapshots(),
            builder: (context, snapshot) {
              int unreadCount = 0;
              if (snapshot.hasData) {
                unreadCount = snapshot.data!.docs.length;
              }
              
              return Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.notifications),
                    tooltip: 'Bildirimler',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => NotificationsPage()),
                      );
                    },
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          unreadCount > 99 ? '99+' : unreadCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.account_circle),
            tooltip: 'Profil',
            onSelected: (value) async {
              if (value == 'logout') {
                await FirebaseAuth.instance.signOut();
              } else if (value == 'profile') {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ProfileEditPage()),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'profile',
                child: Text('Profilim'),
              ),
              PopupMenuItem(
                value: 'logout',
                child: Text('Çıkış Yap'),
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.only(bottom: 100), // Alt kısımda boşluk bırak
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF8B0000), // Daha koyu kırmızı
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Fırat Üniversitesi Logosu
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/firat.png',
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                  'Kampüsüm Menü',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Menü',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            _drawerItem(context, Icons.restaurant, 'Kantinler', () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CanteensPage()),
              );
            }),
            _drawerItem(context, Icons.local_library, 'Kütüphane', () {}),
            _drawerItem(context, Icons.event, 'Etkinlikler', () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EventsPage()),
              );
            }),
            _drawerItem(context, Icons.group, 'Kulüpler', () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ClubsPage()),
              );
            }),
            _drawerItem(context, Icons.class_, 'Derslikler', () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ClassroomsPage()),
              );
            }),
            _drawerItem(context, Icons.directions_bus, 'Ulaşım', () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => TransportationPage()),
              );
            }),
            _drawerItem(context, Icons.computer, 'OBS', () {
              _launchOBS(context);
            }),
            Divider(),
            _drawerItem(context, Icons.info, 'Hakkımızda', () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
            }),
            _drawerItem(context, Icons.work, 'Projeler', () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ProjectsPage()),
              );
            }),
            _drawerItem(context, Icons.contact_mail, 'İletişim', () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ContactPage()),
              );
            }),
            _drawerItem(context, Icons.calendar_today, 'Akademik Takvim', () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AcademicCalendarPage()),
              );
            }),
            Divider(),
            // Tema Değiştirme
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return SwitchListTile(
                  title: Text('Koyu Tema'),
                  subtitle: Text('Karanlık mod açık/kapalı'),
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                  secondary: Icon(
                    themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
        children: [
            // Hero Section - Kampüs Resmi ve Karşılama
            Container(
              width: double.infinity,
              height: 250,
              child: Stack(
                children: [
                  // Kampüs videosu
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: _isVideoInitialized
                        ? Container(
                            width: double.infinity,
                            height: 250,
                            child: FittedBox(
              fit: BoxFit.cover,
                              child: SizedBox(
                                width: _videoController!.value.size.width,
                                height: _videoController!.value.size.height,
                                child: VideoPlayer(_videoController!),
                              ),
                            ),
                          )
                        : Container(
                            width: double.infinity,
                            height: 250,
                            color: Colors.grey[300],
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF8B0000),
                              ),
                            ),
                          ),
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  // Video play/pause button
                  if (_isVideoInitialized)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_videoController!.value.isPlaying) {
                              _videoController!.pause();
                            } else {
                              _videoController!.play();
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _videoController!.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  // Karşılama metni
                  Positioned(
                    bottom: 20,
                    left: 24,
                    right: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fırat Üniversitesi',
                          style: TextStyle(
                            fontSize: 28,
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
                        SizedBox(height: 8),
                        Text(
                          'Kampüsüm Uygulamasına Hoş Geldiniz',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 1),
                                blurRadius: 2,
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
            
            // İstatistikler Bölümü
            Container(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  // İstatistik kartları
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Öğrenci',
                          '45,000+',
                          Icons.school,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Akademisyen',
                          '1,200+',
                          Icons.person,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Fakülte',
                          '16',
                          Icons.account_balance,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 32),
                  
                  // Hızlı Erişim Menüsü
                  Container(
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
                            Icon(Icons.flash_on, color: Color(0xFF8B0000), size: 24),
                            SizedBox(width: 8),
                            Text(
                              'Hızlı Erişim',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF8B0000),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Container(
                          height: 100,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildQuickAccessItem(Icons.restaurant, 'Kantinler', () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => CanteensPage()));
                                }),
                                SizedBox(width: 12),
                                _buildQuickAccessItem(Icons.class_, 'Derslikler', () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ClassroomsPage()));
                                }),
                                SizedBox(width: 12),
                                _buildQuickAccessItem(Icons.computer, 'OBS', () {
                                  _launchOBS(context);
                                }),
                                SizedBox(width: 12),
                                _buildQuickAccessItem(Icons.group, 'Kulüpler', () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ClubsPage()));
                                }),
                                SizedBox(width: 12),
                                _buildQuickAccessItem(Icons.directions_bus, 'Ulaşım', () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => TransportationPage()));
                                }),
                                SizedBox(width: 12),
                                _buildQuickAccessItem(Icons.local_library, 'Kütüphane', () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => LibraryPage()));
                                }),
                                SizedBox(width: 12),
                                _buildQuickAccessItem(Icons.event, 'Etkinlikler', () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventsPage()));
                                }),
                                SizedBox(width: 12),
                                _buildQuickAccessItem(Icons.calendar_today, 'Akademik Takvim', () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => AcademicCalendarPage()));
                                }),
                                SizedBox(width: 12),

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 32),
                  
                  // Güncel Haberler Başlığı
                  Row(
                    children: [
                      Icon(Icons.newspaper, color: Color(0xFF8B0000), size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Güncel Haberler',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B0000),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Haberler listesi
          _newsList(context),
          
          // Alt boşluk
          SizedBox(height: 80),
        ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF8B0000)),
      title: Text(title, style: TextStyle(fontSize: 18)),
      onTap: () {
        Navigator.pop(context);
        if (title == 'Kütüphane') {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => LibraryPage()),
          );
        } else {
          onTap();
        }
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      height: 140,
      padding: EdgeInsets.all(12),
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
          Icon(icon, color: Color(0xFF8B0000), size: 28),
          SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8B0000),
            ),
          ),
          SizedBox(height: 6),
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessItem(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Color(0xFF8B0000), size: 24),
            SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF8B0000),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _newsList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('news')
          .orderBy('timestamp', descending: true)
          .limit(6)
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
                SizedBox(height: 8),
                Text(
                  'Yeni haberler eklendiğinde burada görünecek',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        
        final newsDocs = snapshot.data!.docs;
        return Column(
          children: [
            ...newsDocs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final item = <String, String>{
                'title': data['title']?.toString() ?? '',
                'desc': data['desc']?.toString() ?? '',
                'detail': data['detail']?.toString() ?? '',
                'date': data['date']?.toString() ?? '',
                'image': data['image']?.toString() ?? 'assets/siralama.jpg',
              };
              return _buildNewsCard(context, item);
            }).toList(),
            // Daha Fazla Haber Butonu
            SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllNewsPage(),
                    ),
                  );
                },
                icon: Icon(Icons.newspaper, color: Colors.white),
                label: Text(
                  'Tüm Haberleri Gör',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8B0000),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
            SizedBox(height: 32),
          ],
        );
      },
    );
  }
  
  Widget _buildNewsCard(BuildContext context, Map<String, String> item) {
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
            // Haber resmi
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: _buildImageWidget(item['image']!),
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
                        item['date']!,
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
                    item['title']!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    item['desc']!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NewsDetailPage(newsItem: item),
            ),
          );
        },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Color(0xFF8B0000),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Devamını Oku',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
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
  }

  Widget _buildImageWidget(String imagePath) {
    // URL kontrolü (http veya https ile başlıyorsa)
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        height: 160,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 160,
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
            height: 160,
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
        height: 160,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 160,
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

  void _launchOBS(BuildContext context) async {
    const url = 'https://obs.firat.edu.tr';
    try {
      final uri = Uri.parse(url);
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      print('Error launching OBS: $e');
      // Kullanıcıya hata mesajı göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('OBS açılamadı. Lütfen internet bağlantınızı kontrol edin.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


}
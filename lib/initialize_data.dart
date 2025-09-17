import 'package:cloud_firestore/cloud_firestore.dart';

class InitializeData {
  static Future<void> initializeNews() async {
    try {
      // Önce mevcut haberleri kontrol et
      final existingNews = await FirebaseFirestore.instance
          .collection('news')
          .get();
      
      // Eğer hiç haber yoksa, statik haberleri ekle
      if (existingNews.docs.isEmpty) {
        final staticNews = [
          {
            'title': 'Fırat Üniversitesi 2025 Dünya Sıralamasında Yükseldi',
            'desc': 'Üniversitemiz, Times Higher Education sıralamasında 201-250 bandında yer aldı.',
            'detail': 'Fırat Üniversitesi, 2025 yılında Times Higher Education sıralamasında büyük bir başarıya imza atarak 201-250 bandında yer aldı. Bu başarı üniversitemizin uluslararası alandaki saygınlığını artırdı.',
            'date': '2025-06-01',
            'image': 'assets/siralama.jpg',
            'timestamp': Timestamp.fromDate(DateTime(2025, 6, 1, 10, 0)),
          },
          {
            'title': 'Kampüste Bahar Şenlikleri Coşkusu',
            'desc': '2025 Bahar şenlikleri kapsamında konserler, turnuvalar ve çeşitli etkinlikler düzenleniyor.',
            'detail': 'Fırat Üniversitesi kampüsünde 2025 Bahar Şenlikleri büyük bir coşkuyla başladı. Öğrenciler konserler, spor turnuvaları ve çeşitli etkinliklerle eğlenceli vakit geçiriyor.',
            'date': '2025-05-20',
            'image': 'assets/senlik.jpg',
            'timestamp': Timestamp.fromDate(DateTime(2025, 5, 20, 14, 30)),
          },
          {
            'title': 'Yeni Kütüphane Binası Hizmete Açıldı',
            'desc': 'Modern donanımlı yeni kütüphane binası 2025 yılında öğrencilerin hizmetine sunuldu.',
            'detail': 'Fırat Üniversitesi\'nin yeni kütüphane binası, 2025 yılında modern imkanlarla donatılarak öğrencilerin ve akademisyenlerin kullanımına açıldı.',
            'date': '2025-04-10',
            'image': 'assets/kutuphane.jpg',
            'timestamp': Timestamp.fromDate(DateTime(2025, 4, 10, 9, 15)),
          },
          {
            'title': 'Fırat Üniversitesi Akademisyenleri Dünya Listesinde',
            'desc': '2025 yılında 46 akademisyenimiz dünyanın en etkili bilim insanları listesine girdi.',
            'detail': 'Stanford Üniversitesi tarafından hazırlanan 2025 yılı "Dünyanın En Etkili Bilim İnsanları" listesine Fırat Üniversitesi\'nden 46 akademisyen dahil oldu.',
            'date': '2025-03-15',
            'image': 'assets/akademisyen.jpg',
            'timestamp': Timestamp.fromDate(DateTime(2025, 3, 15, 16, 45)),
          },
        ];

        // Batch işlemi ile tüm haberleri ekle
        final batch = FirebaseFirestore.instance.batch();
        
        for (var news in staticNews) {
          final docRef = FirebaseFirestore.instance.collection('news').doc();
          batch.set(docRef, news);
        }
        
        await batch.commit();
        print('Statik haberler başarıyla eklendi!');
      } else {
        print('Haberler zaten mevcut, statik haberler eklenmedi.');
      }
    } catch (e) {
      print('Statik haberler eklenirken hata: $e');
    }
  }

  static Future<void> initializeNotifications() async {
    try {
      // Önce mevcut bildirimleri kontrol et
      final existingNotifications = await FirebaseFirestore.instance
          .collection('notifications')
          .get();
      
      // Eğer hiç bildirim yoksa, örnek bildirimler ekle
      if (existingNotifications.docs.isEmpty) {
        final staticNotifications = [
          {
            'title': 'Hoş Geldiniz!',
            'body': 'Fırat Üniversitesi Kampüsüm uygulamasına hoş geldiniz. Güncel haberler ve etkinlikler için bizi takip edin.',
            'timestamp': Timestamp.fromDate(DateTime.now().subtract(Duration(days: 1))),
            'isRead': false,
          },
          {
            'title': 'Uygulama Güncellemesi',
            'body': 'Kampüsüm uygulaması yeni özelliklerle güncellendi. Daha iyi bir deneyim için uygulamanızı güncelleyin.',
            'timestamp': Timestamp.fromDate(DateTime.now().subtract(Duration(hours: 6))),
            'isRead': false,
          },
        ];

        // Batch işlemi ile tüm bildirimleri ekle
        final batch = FirebaseFirestore.instance.batch();
        
        for (var notification in staticNotifications) {
          final docRef = FirebaseFirestore.instance.collection('notifications').doc();
          batch.set(docRef, notification);
        }
        
        await batch.commit();
        print('Statik bildirimler başarıyla eklendi!');
      } else {
        print('Bildirimler zaten mevcut, statik bildirimler eklenmedi.');
      }
    } catch (e) {
      print('Statik bildirimler eklenirken hata: $e');
    }
  }

  static Future<void> initializeEvents() async {
    try {
      // Önce mevcut etkinlikleri kontrol et
      final existingEvents = await FirebaseFirestore.instance
          .collection('events')
          .get();
      
      // Eğer hiç etkinlik yoksa, statik etkinlikleri ekle
      if (existingEvents.docs.isEmpty) {
        final staticEvents = [
          {
            'title': 'Fırat Bahar Şenliği 2025',
            'category': 'Kültür-Sanat',
            'date': '2025-05-15',
            'time': '14:00',
            'location': 'Merkez Kampüs Amfi',
            'description': 'Geleneksel bahar şenliğimizde konserler, dans gösterileri ve çeşitli etkinlikler',
            'details': 'Fırat Üniversitesi\'nin geleneksel bahar şenliği bu yıl da büyük bir coşkuyla kutlanacak. Konserler, dans gösterileri, şiir dinletileri ve çeşitli sanat etkinlikleri ile dolu bir program hazırlandı.',
            'image': 'assets/firatbaharsenlik.jpg',
            'timestamp': Timestamp.fromDate(DateTime(2025, 5, 15, 14, 0)),
          },
          {
            'title': 'Akademik Sempozyum: Geleceğin Teknolojileri',
            'category': 'Akademik',
            'date': '2025-04-20',
            'time': '09:00',
            'location': 'Mühendislik Fakültesi Konferans Salonu',
            'description': 'Yapay zeka, robotik ve sürdürülebilir teknolojiler konulu akademik sempozyum',
            'details': 'Geleceğin teknolojileri konulu akademik sempozyumda, yapay zeka, robotik, sürdürülebilir teknolojiler ve dijital dönüşüm konuları ele alınacak. Alanında uzman akademisyenler ve sektör temsilcileri katılacak.',
            'image': 'assets/sempozyum.jpg',
            'timestamp': Timestamp.fromDate(DateTime(2025, 4, 20, 9, 0)),
          },
          {
            'title': 'Üniversiteler Arası Futbol Turnuvası',
            'category': 'Spor',
            'date': '2025-06-10',
            'time': '16:00',
            'location': 'Merkez Kampüs Spor Sahası',
            'description': 'Doğu Anadolu bölgesi üniversiteleri arası futbol turnuvası final maçı',
            'details': 'Doğu Anadolu bölgesi üniversiteleri arasında düzenlenen futbol turnuvasının final maçı Fırat Üniversitesi ev sahipliğinde gerçekleşecek. Turnuvaya 8 üniversite katılıyor.',
            'image': 'assets/futbol.jpg',
            'timestamp': Timestamp.fromDate(DateTime(2025, 6, 10, 16, 0)),
          },
          {
            'title': 'Fotoğraf Sergisi: Kampüs Hayatı',
            'category': 'Kültür-Sanat',
            'date': '2025-05-05',
            'time': '09:00',
            'location': 'Kültür Merkezi',
            'description': 'Öğrencilerin çektiği fotoğraflardan oluşan "Kampüs Hayatı" temalı fotoğraf sergisi',
            'details': 'Öğrencilerin çektiği fotoğraflardan oluşan "Kampüs Hayatı" temalı fotoğraf sergisi. 50+ fotoğraf sergilenecek, öğrenci çalışmaları, kampüs hayatından kesitler, günlük hayat, etkinlikler ve doğa konuları ele alınacak.',
            'image': 'assets/sergi.jpg',
            'timestamp': Timestamp.fromDate(DateTime(2025, 5, 5, 9, 0)),
          },
          {
            'title': 'Kariyer Günü 2025',
            'category': 'Akademik',
            'date': '2025-04-30',
            'time': '10:00',
            'location': 'Kongre Merkezi',
            'description': 'Öğrencilerin kariyer planlaması için şirket temsilcileriyle buluşacağı kariyer günü etkinliği',
            'details': 'Öğrencilerin kariyer planlaması için şirket temsilcileriyle buluşacağı kariyer günü etkinliği. Şirket stantları, panel oturumları, kariyer planlaması ve mülakat simülasyonları gerçekleştirilecek.',
            'image': 'assets/kariyer.jpg',
            'timestamp': Timestamp.fromDate(DateTime(2025, 4, 30, 10, 0)),
          },
          {
            'title': 'Basketbol Turnuvası Finali',
            'category': 'Spor',
            'date': '2025-05-25',
            'time': '19:00',
            'location': 'Spor Kompleksi',
            'description': 'Fakülteler arası basketbol turnuvasının final maçı',
            'details': 'Fakülteler arası basketbol turnuvasının final maçı. Mühendislik Fakültesi vs Tıp Fakültesi arasında gerçekleşecek heyecan dolu final maçı. Tüm öğrenciler davetlidir.',
            'image': 'assets/basketbol.jpg',
            'timestamp': Timestamp.fromDate(DateTime(2025, 5, 25, 19, 0)),
          },
          {
            'title': 'Müzik Gecesi: Kampüs Sanatçıları',
            'category': 'Kültür-Sanat',
            'date': '2025-06-05',
            'time': '20:00',
            'location': 'Açık Hava Amfi',
            'description': 'Kampüs sanatçılarının performans sergileyeceği müzik gecesi',
            'details': 'Kampüs sanatçılarının performans sergileyeceği müzik gecesi. Öğrenci grupları, solo performanslar ve özel konuklar ile dolu bir program. Rock, pop, folk ve klasik müzik performansları.',
            'image': 'assets/muzik.jpg',
            'timestamp': Timestamp.fromDate(DateTime(2025, 6, 5, 20, 0)),
          },
          {
            'title': 'Bilim ve Teknoloji Fuarı',
            'category': 'Akademik',
            'date': '2025-05-12',
            'time': '10:00',
            'location': 'Mühendislik Fakültesi',
            'description': 'Öğrenci projelerinin sergileneceği bilim ve teknoloji fuarı',
            'details': 'Öğrenci projelerinin sergileneceği bilim ve teknoloji fuarı. Robotik, yapay zeka, yenilenebilir enerji, mobil uygulama ve web projeleri sergilenecek. Jüri değerlendirmesi ve ödül töreni.',
            'image': 'assets/fuar.jpg',
            'timestamp': Timestamp.fromDate(DateTime(2025, 5, 12, 10, 0)),
          },
        ];

        // Batch işlemi ile tüm etkinlikleri ekle
        final batch = FirebaseFirestore.instance.batch();
        
        for (var event in staticEvents) {
          final docRef = FirebaseFirestore.instance.collection('events').doc();
          batch.set(docRef, event);
        }
        
        await batch.commit();
        print('Statik etkinlikler başarıyla eklendi!');
      } else {
        print('Etkinlikler zaten mevcut, statik etkinlikler eklenmedi.');
      }
    } catch (e) {
      print('Statik etkinlikler eklenirken hata: $e');
    }
  }

  static Future<void> initializeClassrooms() async {
    try {
      // Önce mevcut fakülteleri kontrol et
      final existingFaculties = await FirebaseFirestore.instance
          .collection('faculties')
          .get();
      
      // Eğer hiç fakülte yoksa, statik fakülteleri ekle
      if (existingFaculties.docs.isEmpty) {
        final staticFaculties = [
          'Eğitim Fakültesi',
          'İnsan ve Toplum Bilimleri Fakültesi',
          'Mühendislik Fakültesi',
          'Teknoloji Fakültesi',
          'Sağlık Bilimleri Fakültesi',
          'İletişim Fakültesi',
          'Spor Bilimleri Fakültesi',
          'Diş Hekimliği Fakültesi',
          'Eczacılık Fakültesi',
          'İlahiyat Fakültesi',
          'Mimarlık Fakültesi',
          'Su Ürünleri Fakültesi',
          'Tıp Fakültesi',
          'Veterinerlik Fakültesi',
        ];

        // Batch işlemi ile fakülteleri ekle
        final batch1 = FirebaseFirestore.instance.batch();
        
        for (var faculty in staticFaculties) {
          final docRef = FirebaseFirestore.instance.collection('faculties').doc();
          batch1.set(docRef, {
            'name': faculty,
            'timestamp': Timestamp.fromDate(DateTime(2025, 1, 1, 0, 0)),
          });
        }
        
        await batch1.commit();
        print('Statik fakülteler başarıyla eklendi!');

        // Bölümleri ekle
        final departments = {
          'Eğitim Fakültesi': [
            'Fen Bilgisi Öğretmenliği',
            'İlköğretim Matematik Öğretmenliği',
            'İngilizce Öğretmenliği',
            'Okul Öncesi Öğretmenliği',
            'Rehberlik ve Psikolojik Danışmanlık',
            'Sınıf Öğretmenliği',
            'Sosyal Bilgiler Öğretmenliği',
            'Türkçe Öğretmenliği'
          ],
          'İnsan ve Toplum Bilimleri Fakültesi': [
            'Alman Dili ve Edebiyatı',
            'Coğrafya',
            'Çağdaş Türk Lehçeleri ve Edebiyatları',
            'İngiliz Dili ve Edebiyatı',
            'Sanat Tarihi',
            'Sosyoloji',
            'Tarih',
            'Türk Dili ve Edebiyatı'
          ],
          'Mühendislik Fakültesi': [
            'Bilgisayar Mühendisliği',
            'Çevre Mühendisliği',
            'Elektrik-Elektronik Mühendisliği',
            'İnşaat Mühendisliği',
            'Jeoloji Mühendisliği',
            'Kimya Mühendisliği',
            'Makine Mühendisliği',
            'Mekatronik Mühendisliği',
            'Yapay Zeka ve Veri Mühendisliği'
          ],
          'Teknoloji Fakültesi': [
            'Adli Bilişim Mühendisliği',
            'Enerji Sistemleri Mühendisliği',
            'İnşaat Mühendisliği',
            'Makine Mühendisliği',
            'Metalurji ve Malzeme Mühendisliği',
            'Otomotiv Mühendisliği',
            'Yazılım Mühendisliği'
          ],
          'Sağlık Bilimleri Fakültesi': [
            'Beslenme ve Diyetetik',
            'Ebelik',
            'Fizyoterapi ve Rehabilitasyon',
            'Hemşirelik'
          ],
          'İletişim Fakültesi': [
            'Gazetecilik',
            'Görsel İletişim Tasarımı',
            'Halkla İlişkiler ve Tanıtım',
            'Radyo, Televizyon ve Sinema'
          ],
          'Spor Bilimleri Fakültesi': [
            'Spor Yöneticiliği'
          ],
          'Diş Hekimliği Fakültesi': [
            'Diş Hekimliği'
          ],
          'Eczacılık Fakültesi': [
            'Eczacılık'
          ],
          'İlahiyat Fakültesi': [
            'İlahiyat'
          ],
          'Mimarlık Fakültesi': [
            'Mimarlık',
            'İç Mimarlık',
            'Şehir ve Bölge Planlama'
          ],
          'Su Ürünleri Fakültesi': [
            'Su Ürünleri Mühendisliği'
          ],
          'Tıp Fakültesi': [
            'Tıp'
          ],
          'Veterinerlik Fakültesi': [
            'Veterinerlik'
          ],
        };

        final batch2 = FirebaseFirestore.instance.batch();
        
        for (var faculty in departments.keys) {
          for (var department in departments[faculty]!) {
            final docRef = FirebaseFirestore.instance.collection('departments').doc();
            batch2.set(docRef, {
              'name': department,
              'faculty': faculty,
              'timestamp': Timestamp.fromDate(DateTime(2025, 1, 1, 0, 0)),
            });
          }
        }
        
        await batch2.commit();
        print('Statik bölümler başarıyla eklendi!');

        // Derslikleri ekle (her fakülte için örnek derslikler)
        final classrooms = [
          // Eğitim Fakültesi Derslikleri
          {
            'name': 'E-101',
            'capacity': 60,
            'building': 'Eğitim Fakültesi A Blok',
            'faculty': 'Eğitim Fakültesi',
            'department': 'Fen Bilgisi Öğretmenliği',
            'features': ['Projeksiyon', 'Klima', 'Akıllı Tahta', 'Laboratuvar'],
            'timestamp': Timestamp.fromDate(DateTime(2025, 1, 1, 0, 0)),
          },
          {
            'name': 'E-102',
            'capacity': 50,
            'building': 'Eğitim Fakültesi A Blok',
            'faculty': 'Eğitim Fakültesi',
            'department': 'İlköğretim Matematik Öğretmenliği',
            'features': ['Projeksiyon', 'Klima', 'Akıllı Tahta'],
            'timestamp': Timestamp.fromDate(DateTime(2025, 1, 1, 0, 0)),
          },
          {
            'name': 'E-201',
            'capacity': 45,
            'building': 'Eğitim Fakültesi B Blok',
            'faculty': 'Eğitim Fakültesi',
            'department': 'İngilizce Öğretmenliği',
            'features': ['Projeksiyon', 'Klima', 'Ses Sistemi'],
            'timestamp': Timestamp.fromDate(DateTime(2025, 1, 1, 0, 0)),
          },
          
          // İnsan ve Toplum Bilimleri Fakültesi Derslikleri
          {
            'name': 'IT-101',
            'capacity': 70,
            'building': 'İnsan ve Toplum Bilimleri A Blok',
            'faculty': 'İnsan ve Toplum Bilimleri Fakültesi',
            'department': 'Türk Dili ve Edebiyatı',
            'features': ['Projeksiyon', 'Klima', 'Akıllı Tahta'],
            'timestamp': Timestamp.fromDate(DateTime(2025, 1, 1, 0, 0)),
          },
          {
            'name': 'IT-102',
            'capacity': 55,
            'building': 'İnsan ve Toplum Bilimleri A Blok',
            'faculty': 'İnsan ve Toplum Bilimleri Fakültesi',
            'department': 'Tarih',
            'features': ['Projeksiyon', 'Klima'],
            'timestamp': Timestamp.fromDate(DateTime(2025, 1, 1, 0, 0)),
          },
          
          // Mühendislik Fakültesi Derslikleri
          {
            'name': 'M-101',
            'capacity': 80,
            'building': 'Mühendislik Fakültesi A Blok',
            'faculty': 'Mühendislik Fakültesi',
            'department': 'Bilgisayar Mühendisliği',
            'features': ['Projeksiyon', 'Klima', 'Akıllı Tahta', 'Bilgisayar Laboratuvarı'],
            'timestamp': Timestamp.fromDate(DateTime(2025, 1, 1, 0, 0)),
          },
          {
            'name': 'M-102',
            'capacity': 75,
            'building': 'Mühendislik Fakültesi A Blok',
            'faculty': 'Mühendislik Fakültesi',
            'department': 'Elektrik-Elektronik Mühendisliği',
            'features': ['Projeksiyon', 'Klima', 'Akıllı Tahta', 'Elektronik Laboratuvarı'],
            'timestamp': Timestamp.fromDate(DateTime(2025, 1, 1, 0, 0)),
          },
          {
            'name': 'M-201',
            'capacity': 90,
            'building': 'Mühendislik Fakültesi B Blok',
            'faculty': 'Mühendislik Fakültesi',
            'department': 'Makine Mühendisliği',
            'features': ['Projeksiyon', 'Klima', 'Akıllı Tahta', 'Makine Laboratuvarı'],
            'timestamp': Timestamp.fromDate(DateTime(2025, 1, 1, 0, 0)),
          },
          
          // Teknoloji Fakültesi Derslikleri
          {
            'name': 'T-101',
            'capacity': 65,
            'building': 'Teknoloji Fakültesi A Blok',
            'faculty': 'Teknoloji Fakültesi',
            'department': 'Yazılım Mühendisliği',
            'features': ['Projeksiyon', 'Klima', 'Akıllı Tahta', 'Yazılım Laboratuvarı'],
            'timestamp': Timestamp.fromDate(DateTime(2025, 1, 1, 0, 0)),
          },
          {
            'name': 'T-102',
            'capacity': 60,
            'building': 'Teknoloji Fakültesi A Blok',
            'faculty': 'Teknoloji Fakültesi',
            'department': 'Adli Bilişim Mühendisliği',
            'features': ['Projeksiyon', 'Klima', 'Akıllı Tahta', 'Adli Bilişim Laboratuvarı'],
            'timestamp': Timestamp.fromDate(DateTime(2025, 1, 1, 0, 0)),
          },
          
          // Sağlık Bilimleri Fakültesi Derslikleri
          {
            'name': 'SB-101',
            'capacity': 70,
            'building': 'Sağlık Bilimleri Fakültesi A Blok',
            'faculty': 'Sağlık Bilimleri Fakültesi',
            'department': 'Hemşirelik',
            'features': ['Projeksiyon', 'Klima', 'Akıllı Tahta', 'Simülasyon Laboratuvarı'],
            'timestamp': Timestamp.fromDate(DateTime(2025, 1, 1, 0, 0)),
          },
          {
            'name': 'SB-102',
            'capacity': 50,
            'building': 'Sağlık Bilimleri Fakültesi A Blok',
            'faculty': 'Sağlık Bilimleri Fakültesi',
            'department': 'Beslenme ve Diyetetik',
            'features': ['Projeksiyon', 'Klima', 'Akıllı Tahta', 'Beslenme Laboratuvarı'],
            'timestamp': Timestamp.fromDate(DateTime(2025, 1, 1, 0, 0)),
          },
          
          // İletişim Fakültesi Derslikleri
          {
            'name': 'İ-101',
            'capacity': 55,
            'building': 'İletişim Fakültesi A Blok',
            'faculty': 'İletişim Fakültesi',
            'department': 'Gazetecilik',
            'features': ['Projeksiyon', 'Klima', 'Akıllı Tahta', 'Medya Laboratuvarı'],
            'timestamp': Timestamp.fromDate(DateTime(2025, 1, 1, 0, 0)),
          },
          {
            'name': 'İ-102',
            'capacity': 45,
            'building': 'İletişim Fakültesi A Blok',
            'faculty': 'İletişim Fakültesi',
            'department': 'Radyo, Televizyon ve Sinema',
            'features': ['Projeksiyon', 'Klima', 'Akıllı Tahta', 'Stüdyo'],
            'timestamp': Timestamp.fromDate(DateTime(2025, 1, 1, 0, 0)),
          },
          
          // Spor Bilimleri Fakültesi Derslikleri
          {
            'name': 'SP-101',
            'capacity': 80,
            'building': 'Spor Bilimleri Fakültesi A Blok',
            'faculty': 'Spor Bilimleri Fakültesi',
            'department': 'Spor Yöneticiliği',
            'features': ['Projeksiyon', 'Klima', 'Akıllı Tahta', 'Spor Salonu'],
            'timestamp': Timestamp.fromDate(DateTime(2025, 1, 1, 0, 0)),
          },
          
          // Diş Hekimliği Fakültesi Derslikleri
          {
            'name': 'DH-101',
            'capacity': 60,
            'building': 'Diş Hekimliği Fakültesi A Blok',
            'faculty': 'Diş Hekimliği Fakültesi',
            'department': 'Diş Hekimliği',
            'features': ['Projeksiyon', 'Klima', 'Akıllı Tahta', 'Diş Hekimliği Laboratuvarı'],
            'timestamp': Timestamp.fromDate(DateTime(2025, 1, 1, 0, 0)),
          },
          
          // Eczacılık Fakültesi Derslikleri
          {
            'name': 'EC-101',
            'capacity': 70,
            'building': 'Eczacılık Fakültesi A Blok',
            'faculty': 'Eczacılık Fakültesi',
            'department': 'Eczacılık',
            'features': ['Projeksiyon', 'Klima', 'Akıllı Tahta', 'Eczacılık Laboratuvarı'],
            'timestamp': Timestamp.fromDate(DateTime(2025, 1, 1, 0, 0)),
          },
          
          // İlahiyat Fakültesi Derslikleri
          {
            'name': 'İL-101',
            'capacity': 90,
            'building': 'İlahiyat Fakültesi A Blok',
            'faculty': 'İlahiyat Fakültesi',
            'department': 'İlahiyat',
            'features': ['Projeksiyon', 'Klima', 'Akıllı Tahta'],
            'timestamp': Timestamp.fromDate(DateTime(2025, 1, 1, 0, 0)),
          },
          
          // Mimarlık Fakültesi Derslikleri
          {
            'name': 'Mİ-101',
            'capacity': 50,
            'building': 'Mimarlık Fakültesi A Blok',
            'faculty': 'Mimarlık Fakültesi',
            'department': 'Mimarlık',
            'features': ['Projeksiyon', 'Klima', 'Akıllı Tahta', 'Çizim Atölyesi'],
            'timestamp': Timestamp.fromDate(DateTime(2025, 1, 1, 0, 0)),
          },
          
          // Su Ürünleri Fakültesi Derslikleri
          {
            'name': 'SU-101',
            'capacity': 60,
            'building': 'Su Ürünleri Fakültesi A Blok',
            'faculty': 'Su Ürünleri Fakültesi',
            'department': 'Su Ürünleri Mühendisliği',
            'features': ['Projeksiyon', 'Klima', 'Akıllı Tahta', 'Su Ürünleri Laboratuvarı'],
            'timestamp': Timestamp.fromDate(DateTime(2025, 1, 1, 0, 0)),
          },
          
          // Tıp Fakültesi Derslikleri
          {
            'name': 'Tİ-101',
            'capacity': 120,
            'building': 'Tıp Fakültesi A Blok',
            'faculty': 'Tıp Fakültesi',
            'department': 'Tıp',
            'features': ['Projeksiyon', 'Klima', 'Akıllı Tahta', 'Anatomi Laboratuvarı'],
            'timestamp': Timestamp.fromDate(DateTime(2025, 1, 1, 0, 0)),
          },
          
          // Veterinerlik Fakültesi Derslikleri
          {
            'name': 'VE-101',
            'capacity': 80,
            'building': 'Veterinerlik Fakültesi A Blok',
            'faculty': 'Veterinerlik Fakültesi',
            'department': 'Veterinerlik',
            'features': ['Projeksiyon', 'Klima', 'Akıllı Tahta', 'Veterinerlik Laboratuvarı'],
            'timestamp': Timestamp.fromDate(DateTime(2025, 1, 1, 0, 0)),
          },
        ];

        final batch3 = FirebaseFirestore.instance.batch();
        
        for (var classroom in classrooms) {
          final docRef = FirebaseFirestore.instance.collection('classrooms').doc();
          batch3.set(docRef, classroom);
        }
        
        await batch3.commit();
        print('Statik derslikler başarıyla eklendi!');
      } else {
        print('Fakülteler zaten mevcut, statik veriler eklenmedi.');
      }
    } catch (e) {
      print('Statik derslik verileri eklenirken hata: $e');
    }
  }

  static Future<void> initializeAllData() async {
    await initializeNews();
    await initializeNotifications();
    await initializeEvents();
    await initializeClassrooms();
  }

  // Mevcut verileri temizleyip yeniden eklemek için (sadece geliştirme aşamasında kullanın)
  static Future<void> resetAndInitializeData() async {
    try {
      // Mevcut haberleri sil
      final newsSnapshot = await FirebaseFirestore.instance.collection('news').get();
      final batch1 = FirebaseFirestore.instance.batch();
      for (var doc in newsSnapshot.docs) {
        batch1.delete(doc.reference);
      }
      await batch1.commit();
      print('Mevcut haberler silindi');

      // Mevcut bildirimleri sil
      final notificationsSnapshot = await FirebaseFirestore.instance.collection('notifications').get();
      final batch2 = FirebaseFirestore.instance.batch();
      for (var doc in notificationsSnapshot.docs) {
        batch2.delete(doc.reference);
      }
      await batch2.commit();
      print('Mevcut bildirimler silindi');

      // Mevcut etkinlikleri sil
      final eventsSnapshot = await FirebaseFirestore.instance.collection('events').get();
      final batch3 = FirebaseFirestore.instance.batch();
      for (var doc in eventsSnapshot.docs) {
        batch3.delete(doc.reference);
      }
      await batch3.commit();
      print('Mevcut etkinlikler silindi');

      // Mevcut derslikleri sil
      final classroomsSnapshot = await FirebaseFirestore.instance.collection('classrooms').get();
      final batch4 = FirebaseFirestore.instance.batch();
      for (var doc in classroomsSnapshot.docs) {
        batch4.delete(doc.reference);
      }
      await batch4.commit();
      print('Mevcut derslikler silindi');

      // Mevcut bölümleri sil
      final departmentsSnapshot = await FirebaseFirestore.instance.collection('departments').get();
      final batch5 = FirebaseFirestore.instance.batch();
      for (var doc in departmentsSnapshot.docs) {
        batch5.delete(doc.reference);
      }
      await batch5.commit();
      print('Mevcut bölümler silindi');

      // Mevcut fakülteleri sil
      final facultiesSnapshot = await FirebaseFirestore.instance.collection('faculties').get();
      final batch6 = FirebaseFirestore.instance.batch();
      for (var doc in facultiesSnapshot.docs) {
        batch6.delete(doc.reference);
      }
      await batch6.commit();
      print('Mevcut fakülteler silindi');

      // Yeniden ekle
      await initializeNews();
      await initializeNotifications();
      await initializeEvents();
      await initializeClassrooms();
      print('Tüm veriler yeniden eklendi!');
    } catch (e) {
      print('Veri sıfırlama sırasında hata: $e');
    }
  }
} 
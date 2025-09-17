import 'package:cloud_firestore/cloud_firestore.dart';

class SampleData {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Örnek fakülte ve bölüm verilerini Firestore'a ekle
  static Future<void> addSampleData() async {
    try {
      // Fakülteler
      final faculties = [
        {
          'name': 'Eğitim Fakültesi',
          'code': 'EGT',
          'departments': [
            'Bilgisayar ve Öğretim Teknolojileri Eğitimi',
            'Eğitim Bilimleri',
            'İlköğretim',
            'Ortaöğretim Fen ve Matematik Alanları Eğitimi',
            'Ortaöğretim Sosyal Alanlar Eğitimi',
            'Türkçe ve Sosyal Bilimler Eğitimi',
            'Yabancı Diller Eğitimi',
          ]
        },
        {
          'name': 'Eczacılık Fakültesi',
          'code': 'ECZ',
          'departments': [
            'Eczacılık',
          ]
        },
        {
          'name': 'Fen Fakültesi',
          'code': 'FEN',
          'departments': [
            'Biyoloji',
            'Fizik',
            'İstatistik',
            'Kimya',
            'Matematik',
          ]
        },
        {
          'name': 'İnsani ve Sosyal Bilimler Fakültesi',
          'code': 'ISB',
          'departments': [
            'Arkeoloji',
            'Coğrafya',
            'Felsefe',
            'Psikoloji',
            'Sosyoloji',
            'Tarih',
            'Türk Dili ve Edebiyatı',
          ]
        },
        {
          'name': 'İktisadi ve İdari Bilimler Fakültesi',
          'code': 'IIB',
          'departments': [
            'Ekonometri',
            'İktisat',
            'İşletme',
            'Maliye',
            'Uluslararası İlişkiler',
            'Yönetim Bilişim Sistemleri',
          ]
        },
        {
          'name': 'İlahiyat Fakültesi',
          'code': 'ILH',
          'departments': [
            'İlahiyat',
          ]
        },
        {
          'name': 'İletişim Fakültesi',
          'code': 'ILT',
          'departments': [
            'Gazetecilik',
            'Halkla İlişkiler ve Tanıtım',
            'Radyo, Televizyon ve Sinema',
          ]
        },
        {
          'name': 'Mühendislik Fakültesi',
          'code': 'MUH',
          'departments': [
            'Bilgisayar Mühendisliği',
            'Çevre Mühendisliği',
            'Elektrik-Elektronik Mühendisliği',
            'Endüstri Mühendisliği',
            'Gıda Mühendisliği',
            'Harita Mühendisliği',
            'İnşaat Mühendisliği',
            'Jeoloji Mühendisliği',
            'Jeofizik Mühendisliği',
            'Kimya Mühendisliği',
            'Maden Mühendisliği',
            'Makine Mühendisliği',
            'Petrol ve Doğalgaz Mühendisliği',
            'Tekstil Mühendisliği',
          ]
        },
        {
          'name': 'Su Ürünleri Fakültesi',
          'code': 'SUU',
          'departments': [
            'Su Ürünleri Mühendisliği',
            'Su Ürünleri Temel Bilimler',
          ]
        },
        {
          'name': 'Teknik Eğitim Fakültesi',
          'code': 'TEK',
          'departments': [
            'Bilgisayar Sistemleri Öğretmenliği',
            'Elektrik Öğretmenliği',
            'Elektronik Öğretmenliği',
            'İnşaat Öğretmenliği',
            'Makine Öğretmenliği',
            'Metal Öğretmenliği',
            'Mobilya ve Dekorasyon Öğretmenliği',
            'Tesisat Öğretmenliği',
            'Tesisat Teknolojisi Öğretmenliği',
          ]
        },
        {
          'name': 'Teknoloji Fakültesi',
          'code': 'TEKNO',
          'departments': [
            'Adli Bilişim Mühendisliği',
            'Elektrik-Elektronik Mühendisliği',
            'Enerji Sistemleri Mühendisliği',
            'İnşaat Mühendisliği',
            'Makine Mühendisliği',
            'Mekatronik Mühendisliği',
            'Metalurji ve Malzeme Mühendisliği',
            'Otomotiv Mühendisliği',
            'Yazılım Mühendisliği',
          ]
        },
        {
          'name': 'Mimarlık Fakültesi',
          'code': 'MIM',
          'departments': [
            'İç Mimarlık',
            'Mimarlık',
            'Şehir ve Bölge Planlama',
          ]
        },
        {
          'name': 'Diş Hekimliği Fakültesi',
          'code': 'DIS',
          'departments': [
            'Diş Hekimliği',
          ]
        },
        {
          'name': 'Tıp Fakültesi',
          'code': 'TIP',
          'departments': [
            'Tıp',
          ]
        },
        {
          'name': 'Sağlık Bilimleri Fakültesi',
          'code': 'SBK',
          'departments': [
            'Beslenme ve Diyetetik',
            'Çocuk Gelişimi',
            'Ebelik',
            'Fizyoterapi ve Rehabilitasyon',
            'Hemşirelik',
            'Odyoloji',
            'Sağlık Yönetimi',
            'Sosyal Hizmet',
          ]
        },
        {
          'name': 'Veterinerlik Fakültesi',
          'code': 'VET',
          'departments': [
            'Veterinerlik',
          ]
        },
        {
          'name': 'Spor Bilimleri Fakültesi',
          'code': 'SPOR',
          'departments': [
            'Antrenörlük Eğitimi',
            'Beden Eğitimi ve Spor Öğretmenliği',
            'Spor Yöneticiliği',
            'Rekreasyon',
          ]
        },
      ];

      // Her fakülte için
      for (var facultyData in faculties) {
        // Fakülteyi ekle
        final facultyRef = await _firestore.collection('faculties').add({
          'name': facultyData['name'],
          'code': facultyData['code'],
          'createdAt': FieldValue.serverTimestamp(),
        });

                 // Bölümleri ekle
         for (var departmentName in (facultyData['departments'] as List<dynamic>)) {
          final departmentRef = await _firestore.collection('departments').add({
            'name': departmentName,
            'code': _generateDepartmentCode(departmentName),
            'facultyId': facultyRef.id,
            'createdAt': FieldValue.serverTimestamp(),
          });

          // Her bölüm için örnek derslikler ekle
          await _addSampleClassrooms(departmentRef.id, departmentName);
        }
      }

      print('Örnek veriler başarıyla eklendi!');
    } catch (e) {
      print('Örnek veriler eklenirken hata: $e');
    }
  }

  // Bölüm kodu oluştur
  static String _generateDepartmentCode(String departmentName) {
    final words = departmentName.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else if (words.length == 1) {
      return words[0].substring(0, 2).toUpperCase();
    }
    return 'DP';
  }

  // Örnek derslikler ekle
  static Future<void> _addSampleClassrooms(String departmentId, String departmentName) async {
    final classroomNames = ['101', '102', '201', '202', '301', '302'];
    final buildings = ['A Blok', 'B Blok', 'C Blok', 'D Blok'];
    final features = [
      ['Projeksiyon', 'Klima'],
      ['Projeksiyon', 'Bilgisayar'],
      ['Klima', 'Ses Sistemi'],
      ['Projeksiyon', 'Klima', 'Bilgisayar'],
      ['Klima'],
      ['Projeksiyon', 'Ses Sistemi'],
    ];

    for (int i = 0; i < classroomNames.length; i++) {
      await _firestore.collection('classrooms').add({
        'name': classroomNames[i],
        'building': buildings[i % buildings.length],
        'capacity': 30 + (i * 5), // 30, 35, 40, 45, 50, 55
        'departmentId': departmentId,
        'features': features[i % features.length],
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Tüm verileri sil (test için)
  static Future<void> clearAllData() async {
    try {
      // Derslikleri sil
      final classroomSnapshot = await _firestore.collection('classrooms').get();
      for (var doc in classroomSnapshot.docs) {
        await doc.reference.delete();
      }

      // Bölümleri sil
      final departmentSnapshot = await _firestore.collection('departments').get();
      for (var doc in departmentSnapshot.docs) {
        await doc.reference.delete();
      }

      // Fakülteleri sil
      final facultySnapshot = await _firestore.collection('faculties').get();
      for (var doc in facultySnapshot.docs) {
        await doc.reference.delete();
      }

      print('Tüm veriler silindi!');
    } catch (e) {
      print('Veriler silinirken hata: $e');
    }
  }
} 
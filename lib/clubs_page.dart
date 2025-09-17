import 'package:flutter/material.dart';
import 'club_detail_page.dart';

class ClubsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Kulüpler'),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            labelPadding: EdgeInsets.symmetric(horizontal: 16),
            indicatorPadding: EdgeInsets.symmetric(horizontal: 16),
            tabs: [
              Tab(text: 'Bilimsel'),
              Tab(text: 'Kültürel'),
              Tab(text: 'Sosyal'),
              Tab(text: 'Sağlık'),
            ],
          ),
        ),
        body: Stack(
          children: [
            TabBarView(
              children: [
                _buildClubList(scientificClubs),
                _buildClubList(culturalClubs),
                _buildClubList(socialClubs),
                _buildClubList(healthClubs),
              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildClubList(List<Map<String, String>> clubs) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: clubs.length + 1, // +1 for bottom padding
      itemBuilder: (context, index) {
        if (index == clubs.length) {
          // Alt boşluk
          return SizedBox(height: 80);
        }
        final club = clubs[index];
        return _buildClubCard(context, club);
      },
    );
  }

  Widget _buildClubCard(BuildContext context, Map<String, String> club) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color(0xFF8B0000),
          child: Icon(Icons.group, color: Colors.white),
          radius: 25,
        ),
        title: Text(
          club['name']!,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Danışman: ${club['advisor']!}'),
            Text('Başkan: ${club['president']!}'),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClubDetailPage(club: club),
            ),
          );
        },
      ),
    );
  }
}

// Bilimsel Kulüpler
final List<Map<String, String>> scientificClubs = [
  {'name': 'Adli Bilişim Öğrenci Topluluğu', 'advisor': 'Doç. Dr. Türker TUNCER', 'president': 'Yusuf Emir ŞAHİN', 'category': 'Bilimsel'},
  {'name': 'Akıllı Sistemler ve Milli Savunma Teknolojileri Öğrenci Topluluğu (ASİMSAV)', 'advisor': 'Arş.Gör. Muhammet E. ÇOLAK', 'president': 'Mehmet GEÇİCİ', 'category': 'Bilimsel'},
  {'name': 'Biyomühendislik Öğrenci Topluluğu', 'advisor': 'Arş. Gör. Kübra KOÇAK', 'president': 'Ayşenur TÜFENKÇİ', 'category': 'Bilimsel'},
  {'name': 'Field Programmable Gate Array Öğrenci Topluluğu (FPGA)', 'advisor': 'Prof. Dr. Hasan KÜRÜM', 'president': 'Anıl Ömer PARLAK', 'category': 'Bilimsel'},
  {'name': 'Bilim ve Fen Öğrenci Topluluğu', 'advisor': 'Doç. Dr.Gonca KEÇECİ', 'president': 'Nurten AKDEMİR', 'category': 'Bilimsel'},
  {'name': 'Google Developer Students Club Fırat University', 'advisor': 'Prof. Dr. Mehmet KARAKÖSE', 'president': 'Nurgül Bedir', 'category': 'Bilimsel'},
  {'name': 'Gök Bilimi ve Uydu Teknolojileri Öğrenci Topluluğu', 'advisor': 'Doç. Dr. İlyas SOMUNKIRAN', 'president': 'Aysun DEMİRCAN', 'category': 'Bilimsel'},
  {'name': 'Fırat Elektronik ve Bilişim Teknolojileri Öğrenci Topluluğu', 'advisor': 'Doç. Dr. Özal YILDIRIM', 'president': 'Merve CİN', 'category': 'Bilimsel'},
  {'name': 'Veterinerlik Bilimsel Araştırma Yayın Öğrenci Topluluğu', 'advisor': 'Prof. Dr. Kazım ŞAHİN', 'president': 'Ahmet Selim ÖZKAN', 'category': 'Bilimsel'},
  {'name': 'International Veterinary Students Association Öğrenci Topluluğu', 'advisor': 'Prof. Dr. Pınar TATLI SEVEN', 'president': 'Oğulcan DURU', 'category': 'Bilimsel'},
  {'name': 'Teknoloji Öğrenci Topluluğu', 'advisor': 'Prof. Dr. Orhan ÇAKAR', 'president': 'Ali ERTAŞ', 'category': 'Bilimsel'},
  {'name': 'Havacılık ve Uzay Teknolojileri Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Ü. Ukbe Üsame UÇAR', 'president': 'Hazar Diyar SARİ', 'category': 'Bilimsel'},
  {'name': 'Savunma Teknolojileri ve Nitelikli Mühendisler Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Üyesi. Burak Tanyeri', 'president': 'Yılmaz UZUN', 'category': 'Bilimsel'},
  {'name': 'Institute of Engineers and Everybody Else Öğrenci Topluluğu (IEEE)', 'advisor': 'Doç. Dr. Turgay KAYA', 'president': 'İrfan Efe Atagün', 'category': 'Bilimsel'},
  {'name': 'Moleküler Biyoloji ve Genetik Öğrenci Topluluğu', 'advisor': 'Prof. Dr. Eyüp BAĞCI', 'president': 'Ceren GÜNEŞ', 'category': 'Bilimsel'},
  {'name': 'Makine Mühendisliği Öğrenci Topluluğu', 'advisor': 'Doç. Dr. Nevin ÇELİK', 'president': 'Eren ALTINIŞIK', 'category': 'Bilimsel'},
  {'name': 'Erasmus Öğrenci Topluluğu', 'advisor': 'Arş. Gör. Murat KATAR', 'president': 'Bilgesu BARIŞ', 'category': 'Bilimsel'},
  {'name': 'Teknoloji Ar-Ge ve Girişimcilik Öğrenci Topluluğu (FÜTAG)', 'advisor': 'Prof. Dr. Bilal ALATAŞ', 'president': 'Mert Ömer BAKAR', 'category': 'Bilimsel'},
  {'name': 'İnşaat Mühendisliği Öğrenci Topluluğu (FİMÜ)', 'advisor': 'Arş. Gör. Dr. Mustafa TUNÇ', 'president': 'Hatip KARATAŞ', 'category': 'Bilimsel'},
  {'name': 'Veteriner Öğrenci Topluluğu (FıratÜniVet)', 'advisor': 'Prof. Dr. Gör. Ülkü Gülcihan ŞİMŞEK', 'president': 'Uğur DAĞTEKİN', 'category': 'Bilimsel'},
  {'name': 'ACM Öğrenci Topluluğu', 'advisor': 'Prof. Dr. Mehmet KARAKÖSE', 'president': 'Yusuf AÇIK', 'category': 'Bilimsel'},
  {'name': 'Elektro Teknoloji Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Ü. Yavuz EROL', 'president': 'Emre DURAK', 'category': 'Bilimsel'},
  {'name': 'Siber Güvenlik Öğrenci Topluluğu', 'advisor': 'Doç. Dr. Erhan AKBAL', 'president': 'Eda GÜN', 'category': 'Bilimsel'},
  {'name': 'Sosyal Ar-Ge Öğrenci Topluluğu', 'advisor': 'Prof. Dr Oğuz YAKUT', 'president': 'Hasan ÇAĞLI', 'category': 'Bilimsel'},
  {'name': 'Yapay Zeka Görüntü İşleme ve İnovasyon Öğrenci Topluluğu', 'advisor': 'Prof. Dr. Mustafa ULAŞ', 'president': 'Yunus Emre GÜMÜŞ', 'category': 'Bilimsel'},
  {'name': 'Fırat Üniversitesi Kalite Öğrenci Topluluğu', 'advisor': 'Prof. Dr. Mehmet YILMAZ', 'president': 'Erenalp POLAT', 'category': 'Bilimsel'},
  {'name': 'İklim Değişikliği ve Sıfır Atık Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Ü. Dilek ARSLAN ATEŞŞAHİN', 'president': 'Furkan UTKU', 'category': 'Bilimsel'},
  {'name': 'Huawei Geliştirici Öğrenciler Öğrenci Topluluğu', 'advisor': 'Doç. Dr. Fatih ÖZYURT', 'president': 'İnanç ÇOLAK', 'category': 'Bilimsel'},
  {'name': 'Analitik Düşünce Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Ü. Ebru KÜKEY', 'president': 'Sefa GÜNAY', 'category': 'Bilimsel'},
  {'name': 'Fırat Üniversitesi Yapı-Tasarım Öğrenci Topluluğu', 'advisor': 'Doç. Dr. Ayça GÜLTEN', 'president': 'Ahmet Fazıl ORHAN', 'category': 'Bilimsel'},
  {'name': 'Fırat Blockchain Öğrenci Topluluğu', 'advisor': 'Prof. Dr. İbrahim TÜRKOĞLU', 'president': 'Onur ÇAKIR', 'category': 'Bilimsel'},
  {'name': 'Bilişim ve Eğitim Öğrenci Topluluğu', 'advisor': 'Doç. Dr. Muhammet BAYKARA', 'president': 'Onur Eren EJDER', 'category': 'Bilimsel'},
  {'name': 'Matematik ve Teknoloji Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Üyesi Hatice ASLAN', 'president': 'İbrahim ALTIN', 'category': 'Bilimsel'},
  {'name': 'Lego Öğrenci Topluluğu', 'advisor': 'Doç. Dr. Zülfü GENÇ', 'president': 'Ebru BAYKAN', 'category': 'Bilimsel'},
  {'name': 'Finansal Teknolojiler Öğrenci Topluluğu', 'advisor': 'Doç. Dr. Yunus SANTUR', 'president': 'Muhammet E. ULAŞ', 'category': 'Bilimsel'},
  {'name': 'Mikro Mühendisler Öğrenci Topluluğu', 'advisor': 'Arş. Gör. Kıvanç DOĞAN', 'president': 'Berke SEVİNÇ', 'category': 'Bilimsel'},
  {'name': 'Veri Bilimi ve İstatistik Öğrenci Topluluğu', 'advisor': 'Arş. Gör. Mine DOĞAN', 'president': 'Erol İLHAN', 'category': 'Bilimsel'},
  {'name': 'Bilim ve Kimya Öğrenci Topluluğu', 'advisor': 'Doç Dr. Mustafa Ersin PEDEMİR', 'president': 'Mürüvvet K. BAYRAM', 'category': 'Bilimsel'},
  {'name': 'Bulut Bilişim ve Büyük Veri Öğrenci Topluluğu', 'advisor': 'Arş. Gör. Mehmet ARZU', 'president': 'Recep BÜLBÜL', 'category': 'Bilimsel'},
  {'name': 'Fırat Üniversitesi Yönetim ve Bilişim Öğrenci Topluluğu', 'advisor': 'Doç. Dr. Mesut TOĞAÇAR', 'president': 'Erhan ARPACI', 'category': 'Bilimsel'},
  {'name': 'Yeniler Öğrenci Topluluğu', 'advisor': 'Öğr. Gr. Yusuf Ziya ÖLÇÜCÜ', 'president': 'Yasin KILIÇ', 'category': 'Bilimsel'},
  {'name': 'TEKNOFEST Öğrenci Topluluğu', 'advisor': 'Doç. Dr. Ferhat UÇAR', 'president': 'Muhammed Talha DOĞAN', 'category': 'Bilimsel'},
  {'name': 'Finans Öğrenci Topluluğu', 'advisor': 'Arş. Gör. Nasibe TÜRKYILMAZ', 'president': 'Abdullah Sefa ARIKAN', 'category': 'Bilimsel'},
  {'name': 'İnsansız Araçlar Öğrenci Topluluğu', 'advisor': 'Arş. Gör. Şule KAYA', 'president': 'Onur Can SARI', 'category': 'Bilimsel'},
  {'name': 'Fizik ve Bilim Öğrenci Topluluğu', 'advisor': 'Arş. Gör. Oğuzhan ORHAN', 'president': 'Elif ASLAN', 'category': 'Bilimsel'},
  {'name': 'Araştırma Üniversiteleri Proje Geliştirme Öğrenci Topluluğu', 'advisor': 'Arş. Gör. Yusuf DONAT', 'president': 'Buğra Turan TANRIVERDİ', 'category': 'Bilimsel'},
  {'name': 'Jeoloji Mühendisliği Öğrenci Topluluğu', 'advisor': 'Doç. Dr. Mehmet KÖKÜM', 'president': 'Ismaıl MARI', 'category': 'Bilimsel'},
  {'name': 'FUTURE Öğrenci Topluluğu', 'advisor': 'Arş. Gör. Çağrı ŞAHİN', 'president': 'İbrahim Kerem GÜVEN', 'category': 'Bilimsel'},
  {'name': 'El Cezeri Teknoloji Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Üyesi Mahmut KAYA', 'president': 'Mehmet Veysel BİNGÖL', 'category': 'Bilimsel'},
];

// Kültürel Kulüpler
final List<Map<String, String>> culturalClubs = [
  {'name': 'Akademik Düşünce Eğitim Medeniyet Öğrenci Topluluğu', 'advisor': 'Doç.Dr. Gökhan GÖKDERE', 'president': 'Emirhan KILIÇ', 'category': 'Kültürel'},
  {'name': 'Mavera Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Üy. Necmettin TAN', 'president': 'Mutlu YILDIRIM', 'category': 'Kültürel'},
  {'name': 'Fotoğrafçılık Öğrenci Topluluğu', 'advisor': 'Öğr. Gör. Recep BAĞCI', 'president': 'Mehmet Salih AKNAR', 'category': 'Kültürel'},
  {'name': 'Medya İletişim Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Üy. Feridun NİZAM', 'president': 'Enes Burak GÖVÜTAŞ', 'category': 'Kültürel'},
  {'name': 'Müzik Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Ü.Mustafa ÖZTÜRK', 'president': 'Esra DAĞ', 'category': 'Kültürel'},
  {'name': 'Radyo Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Üy. Mustafa DEMİR', 'president': 'Nadir GÜR', 'category': 'Kültürel'},
  {'name': 'Kitap Severler Öğrenci Topluluğu', 'advisor': 'Doç. Dr. Birol BULUT', 'president': 'Neslihan YILMAZ', 'category': 'Kültürel'},
  {'name': 'Geleneksel Türk Savaş Sanatları Öğrenci Topluluğu', 'advisor': 'Arş. Gör. Berkay Yekta ÖZER', 'president': 'Efe Cihan KILAVUZ', 'category': 'Kültürel'},
  {'name': 'Sinema Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Üyesi Yunus NAMAZ', 'president': 'Tuncay KESER', 'category': 'Kültürel'},
  {'name': 'Yabancı Dil Öğrenci Topluluğu', 'advisor': 'Öğr. Gör. Yavuzcan DERE', 'president': 'Endam Adar ŞEŞEROĞULLARI', 'category': 'Kültürel'},
  {'name': 'İlim ve Kültür Öğrenci Topluluğu', 'advisor': 'Doç. Dr. Mustafa UĞRAŞ', 'president': 'İ. Alperen BEŞİROĞLU', 'category': 'Kültürel'},
  {'name': 'Tiyatro Öğrenci Topluluğu', 'advisor': 'Arş. Gör. Bilgit SAĞLAM', 'president': 'Hasan Furkan POLAT', 'category': 'Kültürel'},
  {'name': 'Türk Dünyası ve İletişim Öğrenci Topluluğu', 'advisor': 'Öğr. Gör.Recep BAĞCI', 'president': 'Tural HATAMLI', 'category': 'Kültürel'},
  {'name': 'Sanat ve Kültür Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Üy.Melike BAŞPINAR', 'president': 'Barış KANDENİZ', 'category': 'Kültürel'},
  {'name': 'Daru\'l-Hadis (Hadis Evi) Öğrenci Topluluğu', 'advisor': 'Doç. Dr. Ekrem YÜCEL', 'president': 'Beyza BAŞAK', 'category': 'Kültürel'},
  {'name': 'İngiliz Dili ve Edebiyatı Araştırmaları Öğrenci Topluluğu', 'advisor': 'Arş. Gör. G. Tuğçe ÇETİN', 'president': 'Murat İPEK', 'category': 'Kültürel'},
  {'name': 'Sınıf Eğitimi Öğrenci Topluluğu', 'advisor': 'Arş. Gör. Ebuzer DUYU', 'president': 'Esra YERLİKAYA', 'category': 'Kültürel'},
  {'name': 'Gastronomi Öğenci Topluluğu', 'advisor': 'Öğr. Gör. Olcay ERTUĞRUL', 'president': 'Melisa ÖZCAN', 'category': 'Kültürel'},
  {'name': 'Suffa Proje Akademi Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Ü. Rahime ÇELİK', 'president': 'Nisa Nur ŞEKER', 'category': 'Kültürel'},
  {'name': 'Fikir ve Medeniyet Öğrenci Topluluğu', 'advisor': 'Prof. Dr. Metin KAPLAN', 'president': 'Muhammet SÖNMEZ', 'category': 'Kültürel'},
  {'name': 'Düşünce Akademisi Öğrenci Topluluğu', 'advisor': 'Arş. Gör. Abdullah ÇAĞATAY', 'president': 'Cumali YILDIRIM', 'category': 'Kültürel'},
  {'name': 'Halkla İlişkiler ve Tanıtım Öğrenci Topluluğu', 'advisor': 'Arş. Gör. Tuba ALTUNBEY', 'president': 'Hakan BİLGİN', 'category': 'Kültürel'},
  {'name': 'Kürsübaşı ve Çaydaçıra Halk Oyunları Öğrenci Topluluğu', 'advisor': 'Doç. Dr. Fatih Mehmet UĞURLU', 'president': 'Fatma Gizem KUTLUSAN', 'category': 'Kültürel'},
  {'name': 'Dezerformasyonla Mücadele Öğrenci Topluluğu', 'advisor': 'Doç. Dr. Feridun NİZAM', 'president': 'Muhammed Yadin YILMAZ', 'category': 'Kültürel'},
  {'name': 'English Language Teaching Öğrenci Topluluğu', 'advisor': 'Arş. Gör. Özge KIRMIZIBAYRAK', 'president': 'Çağrı ACAR', 'category': 'Kültürel'},
  {'name': 'Görsel İletişim Atölyesi Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Ü. C. Sinan Altundağ', 'president': 'Ahmet MARKAN', 'category': 'Kültürel'},
];

// Sosyal Kulüpler
final List<Map<String, String>> socialClubs = [
  {'name': 'Damla Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Üy. Handan KARAKAYA', 'president': 'Muhammet KARABULUT', 'category': 'Sosyal'},
  {'name': 'Çalışma Ekonomisi ve Endistri İlişkileri Öğrenci Topluluğu', 'advisor': 'Doç. Dr. Hasan UZUN', 'president': 'Tuana ŞEN', 'category': 'Sosyal'},
  {'name': 'Toplum Gönüllüleri Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Ü. Mevlüt YILMAZ', 'president': 'Mihraç BİLEN', 'category': 'Sosyal'},
  {'name': 'İktisat Öğrenci Topluluğu', 'advisor': 'Doç. Dr. İzzet TAŞAR', 'president': 'Şeydanur NAMLI', 'category': 'Sosyal'},
  {'name': 'Genç Kızılay Öğrenci Topluluğu', 'advisor': 'Prof. Dr. Hatice ERÖKSÜZ', 'president': 'Meral YAVUZ', 'category': 'Sosyal'},
  {'name': 'Engelsiz Fırat Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Ü. Burcu GEZER ŞEN', 'president': 'Duygu ÖZER', 'category': 'Sosyal'},
  {'name': 'Farkındalık Atölyesi Öğrenci Topluluğu', 'advisor': 'Öğr. Gör. Hasan ÖZÇAM', 'president': 'Fırat ALGÜL', 'category': 'Sosyal'},
  {'name': 'Neşeli Adımlar Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Ü. Burcu GEZER ŞEN', 'president': 'Elif ALUŞTEKİN', 'category': 'Sosyal'},
  {'name': 'Genç Girişimciler Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Ü.Ayşe Esra PEKER', 'president': 'Merve ÇAK', 'category': 'Sosyal'},
  {'name': 'Genç TEMA Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Ü. F.Gül KOÇSOY', 'president': 'Gülşen AVŞAR', 'category': 'Sosyal'},
  {'name': 'Gezi ve Turizm Öğrenci Topluluğu', 'advisor': 'Prof. Dr. Mehmet Cengiz HAN', 'president': 'Talip DEMİROK', 'category': 'Sosyal'},
  {'name': 'İyiliğin Geleceği Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Ü. Yeliz POLAT', 'president': 'Filiz KOCAR', 'category': 'Sosyal'},
  {'name': 'Kamu Gözetimi ve Ombusdsmanlık Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Üyesi İsmail KAVAZ', 'president': 'Azra ÖRSDEMİR', 'category': 'Sosyal'},
  {'name': 'Psikolojik Danışmanlık ve Rehberlik Öğrenci Topluluğu', 'advisor': 'Arş.Gör. Yahya ŞAHİN', 'president': 'Ecem Sena ÇELİK', 'category': 'Sosyal'},
  {'name': 'Edebiyat Öğrenci Topluluğu', 'advisor': 'Arş. Gr. Sevda Çilem AYAR VARGÜN', 'president': 'Abdullah Abdurrahman IRMAK', 'category': 'Sosyal'},
  {'name': 'Hayvanları Koruma Öğrenci Topluluğu', 'advisor': 'Prof. Dr. Rahşan ÖZEN', 'president': 'Doğukan USLU', 'category': 'Sosyal'},
  {'name': 'Uluslararası Öğrenci Topluluğu', 'advisor': 'Doç. Dr. Yunus NAMAZ', 'president': 'Guldauryen NURBULAN', 'category': 'Sosyal'},
  {'name': 'Sosyal Hizmet Etkileşim Öğrenci Topluluğu', 'advisor': 'Doç. Dr. Rıfat BİLGİN', 'president': 'Buse YILDIRIM', 'category': 'Sosyal'},
  {'name': 'Tarih Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Ü. Cuma Ali YILMAZ', 'president': 'Tarkan Ömer BANKUR', 'category': 'Sosyal'},
  {'name': 'Yedi Kıta Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Üyesi Muhammet Fırat', 'president': 'Mehmet Salih Barman', 'category': 'Sosyal'},
  {'name': 'Eğitim Gönüllüleri Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Ü. Erdinç ARICI', 'president': 'Abdurrahman Yapıcı', 'category': 'Sosyal'},
  {'name': 'Akil Gençler Öğrenci Topluluğu', 'advisor': 'Prof. Dr. Kenan PEKER', 'president': 'Naser Ahmad AZİZİ', 'category': 'Sosyal'},
  {'name': 'Sosyal Bilgiler Etkin Vatandaşlar Öğrenci Topluluğu', 'advisor': 'Arş.Gör. M. Kürsat ÖKSÜZOĞLU', 'president': 'Muhammed Selim AKGÜN', 'category': 'Sosyal'},
  {'name': 'Sosyal Bilimlerde Teknoloji ve Araştırma Öğrenci Topluluğu', 'advisor': 'Doç. Dr. Ali Sırrı YILMAZ', 'president': 'Ayşegül DİK', 'category': 'Sosyal'},
  {'name': 'Vetakort Öğrenci Topluluğu', 'advisor': 'Prof. Dr. Ahmet ATEŞŞAHİN', 'president': 'Muhammet Fırat GÖKÇEN', 'category': 'Sosyal'},
  {'name': 'Türk Dünyası Araştırmaları Öğrenci Topluluğu', 'advisor': 'Prof. Dr. İbrahim YILMAZÇELİK', 'president': 'Hüseyin ERDOĞAN', 'category': 'Sosyal'},
  {'name': 'Kadın ve Demokrasi Gençlik Öğrenci Topluluğu', 'advisor': 'Doç.Dr. Yeliz POLAT', 'president': 'Kadriye SAMAK', 'category': 'Sosyal'},
  {'name': 'Psikoloji ve İnsan Öğrenci Topluluğu', 'advisor': 'Doç. Dr. Nusrullah OKAN', 'president': 'Yusuf UVUT', 'category': 'Sosyal'},
  {'name': 'Genç Bakış Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Üyesi Hasan YETİŞ', 'president': 'Elif ERGEN', 'category': 'Sosyal'},
  {'name': 'Sanat Tarihi Öğrenci Topluluğu', 'advisor': 'Doç. Dr. Korkmaz ŞEN', 'president': 'Zeynep ŞANLI', 'category': 'Sosyal'},
  {'name': 'Atçılık ve Binicilik Öğrenci Topluluğu', 'advisor': 'Doç. Dr. Mehmet Saltuk ARIKAN', 'president': 'Hacı İsmail DİŞÇEKEN', 'category': 'Sosyal'},
  {'name': 'Bi Dünya Oyuncak Öğrenci Topluluğu', 'advisor': 'Doç. Öğr. Üyesi Ahmet KÖSTEKÇİ', 'president': 'Fırat KAYA', 'category': 'Sosyal'},
  {'name': 'Güzel Sanatlar Öğrenci Topluluğu', 'advisor': 'Öğrt. Gr. Rüçhan KEÇECİ', 'president': 'Merve FIRAT', 'category': 'Sosyal'},
  {'name': 'NEFHA Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Ü. Zeynep ALİMOĞLU SÜRMELİ', 'president': 'Seval TAN', 'category': 'Sosyal'},
  {'name': 'İşletme ve İnovasyon Öğrenci Topluluğu', 'advisor': 'Doç. Dr. Nurdan YÜCEL', 'president': 'Ceren KAÇMAZ', 'category': 'Sosyal'},
  {'name': 'Rehber Öğrenci Topluluğu', 'advisor': 'Dr. Arş. Gr. Cemal URAL', 'president': 'Ahmet ERKILIÇ', 'category': 'Sosyal'},
  {'name': 'Satranç Öğrenci Topluluğu', 'advisor': 'Doç. Dr. Tüncay ATEŞŞAHİN', 'president': 'İsmail Mete KARASUBAŞI', 'category': 'Sosyal'},
  {'name': 'Sahne Düşleri Öğrenci Topluluğu', 'advisor': 'Arş. Gör. Tolgahan BAY', 'president': 'Ahmet Nedim EMRE', 'category': 'Sosyal'},
  {'name': 'Milli Gençlik Öğrenci Topluluğu', 'advisor': 'Doç. Dr. Mehmet ÖZTÜRK', 'president': 'İbrahim Halil TUNÇ', 'category': 'Sosyal'},
  {'name': 'Asr-ı Emare Öğrenci Topluluğu', 'advisor': 'Doç. Dr. Muhammet FIRAT', 'president': 'Hilal YAVUZ', 'category': 'Sosyal'},
  {'name': 'Türk Yurdu Öğrenci Topluluğu', 'advisor': 'Prof. Dr. Yavuz HAYKIR', 'president': 'Muhammet Eray YILDIZ', 'category': 'Sosyal'},
  {'name': 'Yeni Nesil Eğitim Öğrenci Topluluğu', 'advisor': 'Doç. Dr. Müslüm ALANOĞLU', 'president': 'Ayça YETGİN', 'category': 'Sosyal'},
  {'name': 'Su Üstü ve Su Altı Dalış Öğrenci Topluluğu', 'advisor': 'Prof. Dr. Kenan KÖPRÜCÜ', 'president': 'Mehmet Adil SARIBAŞ', 'category': 'Sosyal'},
  {'name': 'Milli Türk Talebe Birliği Öğrenci Topluluğu', 'advisor': 'Doç. Dr. Sevcan AYTAÇ', 'president': 'Metehan ALUÇLU', 'category': 'Sosyal'},
  {'name': 'Milli Kardeşlik Öğrenci Topluluğu', 'advisor': 'Prof. Dr. Mehmet ÇAVAŞ', 'president': 'Turan TURSUN', 'category': 'Sosyal'},
];

// Sağlık Kulüpleri
final List<Map<String, String>> healthClubs = [
  {'name': 'Genç Yeryüzü Doktorları Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Ü. Merve YILMAZ BOZOĞLAN', 'president': 'Dilan ÇELİK', 'category': 'Sağlık'},
  {'name': 'TURKMSİC-Fırat Türk Tıp Öğrenci Topluluğu', 'advisor': 'Prof. Dr. Ebru ÖNALAN', 'president': 'Muhammet Furkan YÜKSEL', 'category': 'Sağlık'},
  {'name': 'Uluslararası Doktorlar Birliği Öğrenci Topluluğu', 'advisor': 'Prof. Dr. Mehmet Ferit GÜRSU', 'president': 'Semih Eren BATIHAN', 'category': 'Sağlık'},
  {'name': 'Sağlıklı Yaşam ve Genç Diyetisyenler Öğrenci Topluluğu', 'advisor': 'Öğr. Gör. Dr. Kürşat KARGÜN', 'president': 'Yağmur GÜNEŞ', 'category': 'Sağlık'},
  {'name': 'Saha Veteriner Hekimliği Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Ü. Önder AYTEKİN', 'president': 'Muzaffer Can ARMAĞAN', 'category': 'Sağlık'},
  {'name': 'Fizyoterapi ve Rehabilitilasyon Öğrenci Topluluğu', 'advisor': 'Öğr. Gör. Mustafa BURAK', 'president': 'Uğur ERKUŞ', 'category': 'Sağlık'},
  {'name': 'Sosyal Hekimler Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Ü. Adem GÖK', 'president': 'Semi ATMACA', 'category': 'Sağlık'},
  {'name': 'Tıbbi Hizmetler ve Teknikerler Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Ü. Mehmet Ali Çiçek', 'president': 'İpek DEMİR', 'category': 'Sağlık'},
  {'name': 'Fırat Psiko-Sosyal Destek Öğrenci Topluluğu', 'advisor': 'Prof. Dr. Murad ATMACA', 'president': 'Ekin Cemal ASLAN', 'category': 'Sağlık'},
  {'name': 'Diş Hekimliği Öğrenciler Birliği Öğrenci Topluluğu', 'advisor': 'Prof. Dr. Abdullah ÖZEN', 'president': 'Burak CULFA', 'category': 'Sağlık'},
  {'name': 'Genç Yeşilay Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Üyesi Filiz ERSÖĞÜTÇÜ', 'president': 'Harun GÜNEŞ', 'category': 'Sağlık'},
  {'name': 'Eczacılık Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Üyesi Özge SOYLU ETER', 'president': 'İrem Solmaz AYHAN', 'category': 'Sağlık'},
  {'name': 'Çiftlik Hayvanları ve Tarımsal Araştırma Topluluğu', 'advisor': 'Prof. Dr. Cemal Georg Orhan', 'president': 'Hasan Mert KURT', 'category': 'Sağlık'},
  {'name': 'Ebelik Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Ü Ayşe Nur Yılmaz', 'president': 'Nesrin Biranger', 'category': 'Sağlık'},
  {'name': 'Anatomi Müzesi Geliştirme Öğrenci Topluluğu', 'advisor': 'Prof. Dr. Meryem KARAN', 'president': 'Gazi Mustafa ATAK', 'category': 'Sağlık'},
  {'name': 'Hemşirelik Öğrenci Topluluğu', 'advisor': 'Doç. Dr. Filiz ERSÖĞÜTÇÜ', 'president': 'Şevval ÇELİK', 'category': 'Sağlık'},
  {'name': 'Düşlerden Gülüşlere Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Ü. İrem BULUT', 'president': 'Hayrunnisa ARIKIZ', 'category': 'Sağlık'},
  {'name': 'Gülümseyen Yüzler Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Ü. Kevser TUNCER', 'president': 'Mehmet BOZKURT', 'category': 'Sağlık'},
  {'name': 'FARMAGENÇ Öğrenci Topluluğu', 'advisor': 'Dr. Öğr. Ü. Harun USLU', 'president': 'Müslüm Enes AY', 'category': 'Sağlık'},
  {'name': 'İlahinet Öğrenci Topluluğu', 'advisor': 'Doç. Dr. Tahsin KAZAN', 'president': 'Emirhan BÜYÜKBAŞ', 'category': 'Sağlık'},
  {'name': 'Klinik Beceriler Öğrenci Topluluğu', 'advisor': 'Prof. Dr. Ömer KIZIL', 'president': 'Arif EMRE', 'category': 'Sağlık'},
  {'name': 'Avrupa Tıp Öğrencileri Birliği (EMSA) Öğrenci Topluluğu', 'advisor': 'Prof. Dr. Nafiye Fulya İLHAN', 'president': 'Elif Betül OKTAY', 'category': 'Sağlık'},
];


import 'package:flutter/material.dart';

class AcademicCalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Akademik Takvim'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Etkinlik', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Güz Yarıyılı', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Bahar Yarıyılı', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: [
                  _row('Ders Dönemi', '08 Eylül 2025 - 23 Aralık 2025', '26 Ocak 2026 - 14 Mayıs 2026'),
                  _row('Ara Sınav Haftası', '01 Kasım 2025 - 09 Kasım 2025', '23 Mart 2026 - 29 Mart 2026'),
                  _row('Yarıyıl Sonu Sınav Dönemi', '24 Aralık 2025 - 04 Ocak 2026', '15 Mayıs 2026 - 24 Mayıs 2026'),
                  _row('Bütünleme Sınav Dönemi', '08 Ocak 2026 - 14 Ocak 2026', '04 Haziran 2026 - 12 Haziran 2026'),
                  _row('Mezuniyet Sınavı', '25 Ocak 2026', '20 Haziran 2026'),
                  _row('Azami Süre Sonu Sınavları', '31 Ağustos 2026 - 06 Eylül 2026', '14 Eylül 2026 - 20 Eylül 2026'),
                  _row('Öğrenci Ders Kayıtları', '29 Ağustos 2025 - 03 Eylül 2025', '20 Ocak 2026 - 22 Ocak 2026'),
                  _row('Danışman Onayı', '29 Ağustos 2025 - 03 Eylül 2025', '20 Ocak 2026 - 22 Ocak 2026'),
                  _row('Ders Ekle-Bırak', '08-12 Eylül 2025', '04-06 Şubat 2026'),
                  _row('Mazeretli Kayıt', '15-19 Eylül 2025', '08-12 Şubat 2026'),
                  _row('Geçici İzin Başvurusu', '15-19 Eylül 2025', '08-12 Şubat 2026'),
                  _row('İsteğe Bağlı İngilizce Hazırlık Sınavı', '12 Eylül 2025', '05 Şubat 2026'),
                  _row('Yabancı Dil Hazırlık Sınıfı Yeterlik Sınavı', '26-27 Ağustos 2025', '01 Haziran 2026'),
                  _row('Tez Teslimi', '24 Aralık 2025', '22 Mayıs 2026'),
                  _row('İlahiyat Tamamlama Sınavı', '24 Aralık 2025', '04 Haziran 2026'),
                  _row('Enstitülerde Seminer Sunumları', '10 Aralık 2025', '22 Mayıs 2026'),
                  _row('Veteriner Fakültesi Staj Sonu', '02 Ocak 2026', '12 Haziran 2026'),
                ],
              ),
            ),
            // Alt boşluk
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  DataRow _row(String event, String fall, String spring) {
    return DataRow(cells: [
      DataCell(Text(event)),
      DataCell(Text(fall)),
      DataCell(Text(spring)),
    ]);
  }
} 
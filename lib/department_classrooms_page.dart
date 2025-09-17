import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'classroom_detail_page.dart';

class DepartmentClassroomsPage extends StatefulWidget {
  final String faculty;
  final String department;

  DepartmentClassroomsPage({
    required this.faculty,
    required this.department,
  });

  @override
  _DepartmentClassroomsPageState createState() => _DepartmentClassroomsPageState();
}

class _DepartmentClassroomsPageState extends State<DepartmentClassroomsPage> {
  String selectedDay = 'Tümü';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.department),
        centerTitle: true,
        backgroundColor: Color(0xFF8B0000),
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Column(
        children: [
          // Gün filtreleme
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.filter_list, color: Color(0xFF8B0000), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Gün Filtreleme',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8B0000),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildDayChip('Tümü'),
                      SizedBox(width: 8),
                      _buildDayChip('Pazartesi'),
                      SizedBox(width: 8),
                      _buildDayChip('Salı'),
                      SizedBox(width: 8),
                      _buildDayChip('Çarşamba'),
                      SizedBox(width: 8),
                      _buildDayChip('Perşembe'),
                      SizedBox(width: 8),
                      _buildDayChip('Cuma'),
                      SizedBox(width: 8),
                      _buildDayChip('Cumartesi'),
                      SizedBox(width: 8),
                      _buildDayChip('Pazar'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Derslikler listesi
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('classrooms')
                  .where('faculty', isEqualTo: widget.faculty)
                  .where('department', isEqualTo: widget.department)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: Colors.red),
                        SizedBox(height: 16),
                        Text(
                          'Bir hata oluştu',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${snapshot.error}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Color(0xFF8B0000)),
                        SizedBox(height: 16),
                        Text(
                          'Derslikler yükleniyor...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.meeting_room_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Bu bölümde henüz derslik bulunmuyor',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Admin panelinden derslik ekleyebilirsiniz',
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

                // Gün filtreleme uygula
                List<QueryDocumentSnapshot> filteredDocs = snapshot.data!.docs;
                if (selectedDay != 'Tümü') {
                  filteredDocs = filteredDocs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return data['day'] == selectedDay;
                  }).toList();
                }

                if (filteredDocs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.filter_list,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Seçilen günde derslik bulunmuyor',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Başka bir gün seçmeyi deneyin',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedDay = 'Tümü';
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF8B0000),
                            foregroundColor: Colors.white,
                          ),
                          child: Text('Tümünü Göster'),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    // Filtreleme bilgisi
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: Colors.grey[50],
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                          SizedBox(width: 8),
                          Text(
                            selectedDay == 'Tümü' 
                                ? '${filteredDocs.length} derslik gösteriliyor'
                                : '$selectedDay gününde ${filteredDocs.length} derslik bulundu',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Derslikler listesi
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: filteredDocs.length,
                        itemBuilder: (context, index) {
                          final doc = filteredDocs[index];
                          final data = doc.data() as Map<String, dynamic>;
                          final isOccupied = data['isOccupied'] ?? false;
                          
                          return Container(
                            margin: EdgeInsets.only(bottom: 12),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ClassroomDetailPage(
                                        classroomData: data,
                                        classroomId: doc.id,
                                      ),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: isOccupied ? Colors.red : Colors.green,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          isOccupied ? Icons.block : Icons.check,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data['name'] ?? 'İsimsiz Derslik',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF8B0000),
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'Kapasite: ${data['capacity'] ?? 0} kişi | Bina: ${data['building'] ?? 'Belirtilmemiş'}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.blue.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                '${data['day'] ?? 'Gün belirtilmemiş'} ${data['time'] ?? 'Saat belirtilmemiş'} | ${data['grade'] ?? 'Sınıf belirtilmemiş'} ${data['section'] ?? 'Şube belirtilmemiş'}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            if (isOccupied) ...[
                                              SizedBox(height: 4),
                                              Text(
                                                'Ders: ${data['currentCourse'] ?? 'Belirtilmemiş'}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'Öğretim Üyesi: ${data['currentInstructor'] ?? 'Belirtilmemiş'}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ] else ...[
                                              SizedBox(height: 4),
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: Colors.green.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  'Durum: Boş',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.grey[400],
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayChip(String day) {
    final isSelected = selectedDay == day;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDay = day;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF8B0000) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          border: isSelected 
              ? Border.all(color: Color(0xFF8B0000), width: 2)
              : Border.all(color: Colors.grey[300]!),
        ),
        child: Text(
          day,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

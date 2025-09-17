import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'faculty_departments_page.dart';

class ClassroomsPage extends StatefulWidget {
  @override
  _ClassroomsPageState createState() => _ClassroomsPageState();
}

class _ClassroomsPageState extends State<ClassroomsPage> {
  List<String> faculties = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFaculties();
  }

  Future<void> _loadFaculties() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('faculties')
          .orderBy('name')
          .get();

      setState(() {
        faculties = snapshot.docs.map((doc) => doc.data()['name'] as String).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Fakülteler yüklenirken hata: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Derslikler'),
        centerTitle: true,
        backgroundColor: Color(0xFF8B0000),
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Fakülteler yükleniyor...'),
                ],
              ),
            )
          : ListView(
              padding: EdgeInsets.all(16),
              children: [
                // Başlık
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFF8B0000),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.school,
                        size: 48,
                        color: Colors.white,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Fakülte Seçiniz',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Derslik programını görüntülemek için fakültenizi seçin',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                
                // Fakülte listesi
                ..._buildFacultyList(context),
                
                // Alt boşluk
                SizedBox(height: 80),
              ],
            ),
    );
  }

  List<Widget> _buildFacultyList(BuildContext context) {
    if (faculties.isEmpty) {
      return [
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            children: [
              Icon(
                Icons.info_outline,
                size: 48,
                color: Colors.grey[600],
              ),
              SizedBox(height: 12),
              Text(
                'Henüz fakülte bulunmuyor',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Admin panelinden fakülte ekleyebilirsiniz',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ];
    }

    return faculties.map((faculty) {
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
                  builder: (context) => FacultyDepartmentsPage(faculty: faculty),
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
                      color: Color(0xFF8B0000),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.school,
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
                          faculty,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B0000),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Derslikleri görüntüle',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
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
    }).toList();
  }
}






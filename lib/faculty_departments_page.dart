import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'department_classrooms_page.dart';

class FacultyDepartmentsPage extends StatelessWidget {
  final String faculty;

  FacultyDepartmentsPage({required this.faculty});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(faculty),
        centerTitle: true,
        backgroundColor: Color(0xFF8B0000),
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('departments')
            .where('faculty', isEqualTo: faculty)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Bir hata oluştu: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Bu fakültede henüz bölüm bulunmuyor',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          final departments = snapshot.data!.docs
              .map((doc) => (doc.data() as Map<String, dynamic>)['name'] as String)
              .toList();

          return ListView(
            padding: EdgeInsets.all(16),
            children: [
              // Bölüm listesi
              ...departments.map((department) {
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
                            builder: (context) => DepartmentClassroomsPage(
                              faculty: faculty,
                              department: department,
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
                                color: Color(0xFF8B0000),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.business,
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
                                    department,
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
              }).toList(),
              
              // Alt boşluk - telefonun geri çıkma menüsüne denk gelmemesi için
              SizedBox(height: 100),
            ],
          );
        },
      ),
    );
  }
}

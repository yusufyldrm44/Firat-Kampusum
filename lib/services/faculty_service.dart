import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/faculty_department.dart';

class FacultyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Tüm fakülteleri getir
  Future<List<Faculty>> getAllFaculties() async {
    try {
      final QuerySnapshot facultySnapshot = await _firestore
          .collection('faculties')
          .orderBy('name')
          .get();

      List<Faculty> faculties = [];
      
      for (var doc in facultySnapshot.docs) {
        final facultyData = doc.data() as Map<String, dynamic>;
        facultyData['id'] = doc.id;
        
        // Her fakülte için bölümleri getir
        final departments = await getDepartmentsByFacultyId(doc.id);
        facultyData['departments'] = departments.map((dept) => dept.toMap()).toList();
        
        faculties.add(Faculty.fromMap(facultyData));
      }
      
      return faculties;
    } catch (e) {
      print('Fakülteler getirilirken hata: $e');
      return [];
    }
  }

  // Fakülte ID'sine göre bölümleri getir
  Future<List<Department>> getDepartmentsByFacultyId(String facultyId) async {
    try {
      final QuerySnapshot departmentSnapshot = await _firestore
          .collection('departments')
          .where('facultyId', isEqualTo: facultyId)
          .orderBy('name')
          .get();

      List<Department> departments = [];
      
      for (var doc in departmentSnapshot.docs) {
        final departmentData = doc.data() as Map<String, dynamic>;
        departmentData['id'] = doc.id;
        
        // Her bölüm için derslikleri getir
        final classrooms = await getClassroomsByDepartmentId(doc.id);
        departmentData['classrooms'] = classrooms.map((classroom) => classroom.toMap()).toList();
        
        departments.add(Department.fromMap(departmentData));
      }
      
      return departments;
    } catch (e) {
      print('Bölümler getirilirken hata: $e');
      return [];
    }
  }

  // Bölüm ID'sine göre derslikleri getir
  Future<List<Classroom>> getClassroomsByDepartmentId(String departmentId) async {
    try {
      final QuerySnapshot classroomSnapshot = await _firestore
          .collection('classrooms')
          .where('departmentId', isEqualTo: departmentId)
          .orderBy('name')
          .get();

      return classroomSnapshot.docs.map((doc) {
        final classroomData = doc.data() as Map<String, dynamic>;
        classroomData['id'] = doc.id;
        return Classroom.fromMap(classroomData);
      }).toList();
    } catch (e) {
      print('Derslikler getirilirken hata: $e');
      return [];
    }
  }

  // Tek bir fakülteyi getir
  Future<Faculty?> getFacultyById(String facultyId) async {
    try {
      final DocumentSnapshot facultyDoc = await _firestore
          .collection('faculties')
          .doc(facultyId)
          .get();

      if (facultyDoc.exists) {
        final facultyData = facultyDoc.data() as Map<String, dynamic>;
        facultyData['id'] = facultyDoc.id;
        
        final departments = await getDepartmentsByFacultyId(facultyDoc.id);
        facultyData['departments'] = departments.map((dept) => dept.toMap()).toList();
        
        return Faculty.fromMap(facultyData);
      }
      
      return null;
    } catch (e) {
      print('Fakülte getirilirken hata: $e');
      return null;
    }
  }

  // Tek bir bölümü getir
  Future<Department?> getDepartmentById(String departmentId) async {
    try {
      final DocumentSnapshot departmentDoc = await _firestore
          .collection('departments')
          .doc(departmentId)
          .get();

      if (departmentDoc.exists) {
        final departmentData = departmentDoc.data() as Map<String, dynamic>;
        departmentData['id'] = departmentDoc.id;
        
        final classrooms = await getClassroomsByDepartmentId(departmentDoc.id);
        departmentData['classrooms'] = classrooms.map((classroom) => classroom.toMap()).toList();
        
        return Department.fromMap(departmentData);
      }
      
      return null;
    } catch (e) {
      print('Bölüm getirilirken hata: $e');
      return null;
    }
  }

  // Derslik programını getir (gelecekte kullanım için)
  Future<Map<String, dynamic>?> getClassroomSchedule(String classroomId, String day, String time) async {
    try {
      final DocumentSnapshot scheduleDoc = await _firestore
          .collection('schedules')
          .doc('${classroomId}_${day}_$time')
          .get();

      if (scheduleDoc.exists) {
        return scheduleDoc.data() as Map<String, dynamic>;
      }
      
      return null;
    } catch (e) {
      print('Program getirilirken hata: $e');
      return null;
    }
  }
} 
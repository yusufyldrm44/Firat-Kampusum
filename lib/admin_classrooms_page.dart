import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'initialize_data.dart';

class AdminClassroomsPage extends StatefulWidget {
  @override
  _AdminClassroomsPageState createState() => _AdminClassroomsPageState();
}

class _AdminClassroomsPageState extends State<AdminClassroomsPage> {
  String? selectedFaculty;
  String? selectedDepartment;
  List<String> faculties = [];
  Map<String, List<String>> departments = {};
  bool isLoadingDepartments = false;

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
      });
    } catch (e) {
      print('Fakülteler yüklenirken hata: $e');
    }
  }

  Future<void> _loadDepartments(String faculty) async {
    setState(() {
      isLoadingDepartments = true;
    });
    
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('departments')
          .where('faculty', isEqualTo: faculty)
          .get();

      setState(() {
        departments[faculty] = snapshot.docs.map((doc) => doc.data()['name'] as String).toList();
        isLoadingDepartments = false;
      });
    } catch (e) {
      print('Bölümler yüklenirken hata: $e');
      setState(() {
        isLoadingDepartments = false;
      });
    }
  }

  Future<void> _addFaculty() async {
    final TextEditingController controller = TextEditingController();
    
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Yeni Fakülte Ekle'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Fakülte Adı',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                try {
                  await FirebaseFirestore.instance
                      .collection('faculties')
                      .add({
                    'name': controller.text.trim(),
                    'timestamp': FieldValue.serverTimestamp(),
                  });
                  
                  Navigator.of(context).pop();
                  _loadFaculties();
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Fakülte başarıyla eklendi!'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Fakülte eklenirken hata oluştu: $e'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
            child: Text('Ekle'),
          ),
        ],
      ),
    );
  }

  Future<void> _addDepartment() async {
    if (selectedFaculty == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Önce fakülte seçin!'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final TextEditingController controller = TextEditingController();
    
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Yeni Bölüm Ekle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Fakülte: $selectedFaculty'),
            SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Bölüm Adı',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                try {
                  await FirebaseFirestore.instance
                      .collection('departments')
                      .add({
                    'name': controller.text.trim(),
                    'faculty': selectedFaculty,
                    'timestamp': FieldValue.serverTimestamp(),
                  });
                  
                  Navigator.of(context).pop();
                  _loadDepartments(selectedFaculty!);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Bölüm başarıyla eklendi!'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Bölüm eklenirken hata oluştu: $e'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
            child: Text('Ekle'),
          ),
        ],
      ),
    );
  }

  Future<void> _addClassroom() async {
    if (selectedFaculty == null || selectedDepartment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Önce fakülte ve bölüm seçin!'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final TextEditingController nameController = TextEditingController();
    final TextEditingController capacityController = TextEditingController();
    final TextEditingController buildingController = TextEditingController();
    final TextEditingController courseController = TextEditingController();
    final TextEditingController instructorController = TextEditingController();
    bool isOccupied = false;
    
    // Yeni alanlar için değişkenler
    String selectedDay = 'Pazartesi';
    String selectedTime = '09:00';
    String selectedGrade = '1. Sınıf';
    String selectedSection = 'A';
    
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text('Yeni Derslik Ekle'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Fakülte: $selectedFaculty'),
                  Text('Bölüm: $selectedDepartment'),
                  SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Derslik Adı',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: capacityController,
                    decoration: InputDecoration(
                      labelText: 'Kapasite',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: buildingController,
                    decoration: InputDecoration(
                      labelText: 'Bina',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),
                  
                  // Gün seçimi
                  DropdownButtonFormField<String>(
                    value: selectedDay,
                    decoration: InputDecoration(
                      labelText: 'Gün',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      'Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar'
                    ].map((String day) {
                      return DropdownMenuItem<String>(
                        value: day,
                        child: Text(day),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        selectedDay = newValue;
                      }
                    },
                  ),
                  SizedBox(height: 12),
                  
                  // Saat seçimi
                  DropdownButtonFormField<String>(
                    value: selectedTime,
                    decoration: InputDecoration(
                      labelText: 'Saat',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      '08:00', '08:30', '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
                      '12:00', '12:30', '13:00', '13:30', '14:00', '14:30', '15:00', '15:30',
                      '16:00', '16:30', '17:00', '17:30', '18:00', '18:30', '19:00', '19:30'
                    ].map((String time) {
                      return DropdownMenuItem<String>(
                        value: time,
                        child: Text(time),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        selectedTime = newValue;
                      }
                    },
                  ),
                  SizedBox(height: 12),
                  
                  // Sınıf seviyesi seçimi
                  DropdownButtonFormField<String>(
                    value: selectedGrade,
                    decoration: InputDecoration(
                      labelText: 'Sınıf Seviyesi',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      '1. Sınıf', '2. Sınıf', '3. Sınıf', '4. Sınıf'
                    ].map((String grade) {
                      return DropdownMenuItem<String>(
                        value: grade,
                        child: Text(grade),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        selectedGrade = newValue;
                      }
                    },
                  ),
                  SizedBox(height: 12),
                  
                  // Şube seçimi
                  DropdownButtonFormField<String>(
                    value: selectedSection,
                    decoration: InputDecoration(
                      labelText: 'Şube',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      'A', 'B', 'C', 'D', 'E'
                    ].map((String section) {
                      return DropdownMenuItem<String>(
                        value: section,
                        child: Text(section),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        selectedSection = newValue;
                      }
                    },
                  ),
                  SizedBox(height: 12),
                  SwitchListTile(
                    title: Text('Dolu mu?'),
                    value: isOccupied,
                    onChanged: (value) {
                      setDialogState(() {
                        isOccupied = value;
                      });
                    },
                  ),
                  if (isOccupied) ...[
                    SizedBox(height: 12),
                    TextField(
                      controller: courseController,
                      decoration: InputDecoration(
                        labelText: 'Mevcut Ders',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: instructorController,
                      decoration: InputDecoration(
                        labelText: 'Öğretim Üyesi',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('İptal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (nameController.text.isNotEmpty && 
                      capacityController.text.isNotEmpty &&
                      buildingController.text.isNotEmpty) {
                    try {
                      await FirebaseFirestore.instance
                          .collection('classrooms')
                          .add({
                        'name': nameController.text.trim(),
                        'capacity': int.tryParse(capacityController.text) ?? 0,
                        'building': buildingController.text.trim(),
                        'faculty': selectedFaculty,
                        'department': selectedDepartment,
                        'day': selectedDay,
                        'time': selectedTime,
                        'grade': selectedGrade,
                        'section': selectedSection,
                        'features': ['Projeksiyon', 'Klima'],
                        'isOccupied': isOccupied,
                        'currentCourse': isOccupied ? courseController.text.trim() : null,
                        'currentInstructor': isOccupied ? instructorController.text.trim() : null,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                      
                      Navigator.of(context).pop();
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Derslik başarıyla eklendi!'),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Derslik eklenirken hata oluştu: $e'),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  }
                },
                child: Text('Ekle'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _editClassroom(Map<String, dynamic> classroomData, String classroomId) async {
    final TextEditingController nameController = TextEditingController(text: classroomData['name']);
    final TextEditingController capacityController = TextEditingController(text: classroomData['capacity'].toString());
    final TextEditingController buildingController = TextEditingController(text: classroomData['building']);
    final TextEditingController courseController = TextEditingController(text: classroomData['currentCourse'] ?? '');
    final TextEditingController instructorController = TextEditingController(text: classroomData['currentInstructor'] ?? '');
    bool isOccupied = classroomData['isOccupied'] ?? false;
    
    // Yeni alanlar için değişkenler
    String selectedDay = classroomData['day'] ?? 'Pazartesi';
    String selectedTime = classroomData['time'] ?? '09:00';
    String selectedGrade = classroomData['grade'] ?? '1. Sınıf';
    String selectedSection = classroomData['section'] ?? 'A';
    
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text('Derslik Düzenle'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Fakülte: ${classroomData['faculty']}'),
                  Text('Bölüm: ${classroomData['department']}'),
                  SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Derslik Adı',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: capacityController,
                    decoration: InputDecoration(
                      labelText: 'Kapasite',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: buildingController,
                    decoration: InputDecoration(
                      labelText: 'Bina',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),
                  
                  // Gün seçimi
                  DropdownButtonFormField<String>(
                    value: selectedDay,
                    decoration: InputDecoration(
                      labelText: 'Gün',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      'Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar'
                    ].map((String day) {
                      return DropdownMenuItem<String>(
                        value: day,
                        child: Text(day),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        selectedDay = newValue;
                      }
                    },
                  ),
                  SizedBox(height: 12),
                  
                  // Saat seçimi
                  DropdownButtonFormField<String>(
                    value: selectedTime,
                    decoration: InputDecoration(
                      labelText: 'Saat',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      '08:00', '08:30', '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
                      '12:00', '12:30', '13:00', '13:30', '14:00', '14:30', '15:00', '15:30',
                      '16:00', '16:30', '17:00', '17:30', '18:00', '18:30', '19:00', '19:30'
                    ].map((String time) {
                      return DropdownMenuItem<String>(
                        value: time,
                        child: Text(time),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        selectedTime = newValue;
                      }
                    },
                  ),
                  SizedBox(height: 12),
                  
                  // Sınıf seviyesi seçimi
                  DropdownButtonFormField<String>(
                    value: selectedGrade,
                    decoration: InputDecoration(
                      labelText: 'Sınıf Seviyesi',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      '1. Sınıf', '2. Sınıf', '3. Sınıf', '4. Sınıf'
                    ].map((String grade) {
                      return DropdownMenuItem<String>(
                        value: grade,
                        child: Text(grade),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        selectedGrade = newValue;
                      }
                    },
                  ),
                  SizedBox(height: 12),
                  
                  // Şube seçimi
                  DropdownButtonFormField<String>(
                    value: selectedSection,
                    decoration: InputDecoration(
                      labelText: 'Şube',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      'A', 'B', 'C', 'D', 'E'
                    ].map((String section) {
                      return DropdownMenuItem<String>(
                        value: section,
                        child: Text(section),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        selectedSection = newValue;
                      }
                    },
                  ),
                  SizedBox(height: 12),
                  SwitchListTile(
                    title: Text('Dolu mu?'),
                    value: isOccupied,
                    onChanged: (value) {
                      setDialogState(() {
                        isOccupied = value;
                      });
                    },
                  ),
                  if (isOccupied) ...[
                    SizedBox(height: 12),
                    TextField(
                      controller: courseController,
                      decoration: InputDecoration(
                        labelText: 'Mevcut Ders',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: instructorController,
                      decoration: InputDecoration(
                        labelText: 'Öğretim Üyesi',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('İptal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await FirebaseFirestore.instance
                        .collection('classrooms')
                        .doc(classroomId)
                        .update({
                      'name': nameController.text.trim(),
                      'capacity': int.tryParse(capacityController.text) ?? 0,
                      'building': buildingController.text.trim(),
                      'day': selectedDay,
                      'time': selectedTime,
                      'grade': selectedGrade,
                      'section': selectedSection,
                      'isOccupied': isOccupied,
                      'currentCourse': isOccupied ? courseController.text.trim() : null,
                      'currentInstructor': isOccupied ? instructorController.text.trim() : null,
                    });
                    
                    Navigator.of(context).pop();
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Derslik başarıyla güncellendi!'),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Derslik güncellenirken hata oluştu: $e'),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                child: Text('Güncelle'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Derslik Yönetimi'),
        backgroundColor: Color(0xFF8B0000),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fakülte ve Bölüm Seçimi
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fakülte ve Bölüm Seçimi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8B0000),
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    // Fakülte Seçimi
                    faculties.isEmpty
                        ? Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline, color: Colors.orange),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Henüz fakülte bulunmuyor. Önce fakülte ekleyin.',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : DropdownButtonFormField<String>(
                            value: selectedFaculty,
                            decoration: InputDecoration(
                              labelText: 'Fakülte Seçin',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: faculties.map((faculty) {
                              return DropdownMenuItem(
                                value: faculty,
                                child: Text(faculty),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedFaculty = value;
                                selectedDepartment = null;
                              });
                              if (value != null) {
                                _loadDepartments(value);
                              }
                            },
                          ),
                    
                    SizedBox(height: 12),
                    
                    // Bölüm Seçimi
                    isLoadingDepartments && selectedFaculty != null
                        ? Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                                SizedBox(width: 12),
                                Text('Bölümler yükleniyor...'),
                              ],
                            ),
                          )
                        : DropdownButtonFormField<String>(
                            value: selectedDepartment,
                            decoration: InputDecoration(
                              labelText: 'Bölüm Seçin',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: (departments[selectedFaculty] ?? []).isNotEmpty 
                                ? (departments[selectedFaculty] ?? []).map((department) {
                                    return DropdownMenuItem(
                                      value: department,
                                      child: Text(department),
                                    );
                                  }).toList() 
                                : [],
                            onChanged: selectedFaculty != null && (departments[selectedFaculty] ?? []).isNotEmpty 
                                ? (value) {
                                    setState(() {
                                      selectedDepartment = value;
                                    });
                                  } 
                                : null,
                          ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 16),
            
            // Derslik Ekle Butonu
            Center(
              child: ElevatedButton.icon(
                onPressed: _addClassroom,
                icon: Icon(Icons.add),
                label: Text('Derslik Ekle'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8B0000),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 24),
            
            // Derslikler Listesi
            if (selectedFaculty != null && selectedDepartment != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Derslikler',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B0000),
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'reset') {
                        try {
                          // Tüm derslik verilerini sil
                          await FirebaseFirestore.instance
                              .collection('classrooms')
                              .get()
                              .then((snapshot) {
                            final batch1 = FirebaseFirestore.instance.batch();
                            for (var doc in snapshot.docs) {
                              batch1.delete(doc.reference);
                            }
                            return batch1.commit();
                          });
                          
                          await FirebaseFirestore.instance
                              .collection('departments')
                              .get()
                              .then((snapshot) {
                            final batch2 = FirebaseFirestore.instance.batch();
                            for (var doc in snapshot.docs) {
                              batch2.delete(doc.reference);
                            }
                            return batch2.commit();
                          });
                          
                          await FirebaseFirestore.instance
                              .collection('faculties')
                              .get()
                              .then((snapshot) {
                            final batch3 = FirebaseFirestore.instance.batch();
                            for (var doc in snapshot.docs) {
                              batch3.delete(doc.reference);
                            }
                            return batch3.commit();
                          });
                          
                          // Statik derslik verilerini yeniden yükle
                          await InitializeData.initializeClassrooms();
                          
                          // Fakülteleri yeniden yükle
                          _loadFaculties();
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Derslik verileri sıfırlandı ve statik veriler yeniden yüklendi!'),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Hata oluştu: $e'),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'reset',
                        child: Row(
                          children: [
                            Icon(Icons.refresh, color: Colors.orange),
                            SizedBox(width: 8),
                            Text('Verileri Sıfırla'),
                          ],
                        ),
                      ),
                    ],
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.more_vert, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('classrooms')
                    .where('faculty', isEqualTo: selectedFaculty)
                    .where('department', isEqualTo: selectedDepartment)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Bir hata oluştu: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Bu bölümde henüz derslik bulunmuyor.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final doc = snapshot.data!.docs[index];
                      final data = doc.data() as Map<String, dynamic>;
                      final isOccupied = data['isOccupied'] ?? false;
                      
                      return Card(
                        margin: EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isOccupied ? Colors.red : Colors.green,
                            child: Icon(
                              isOccupied ? Icons.block : Icons.check,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            data['name'] ?? 'İsimsiz Derslik',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kapasite: ${data['capacity'] ?? 0} kişi | Bina: ${data['building'] ?? 'Belirtilmemiş'}',
                              ),
                              Text(
                                '${data['day'] ?? 'Gün belirtilmemiş'} ${data['time'] ?? 'Saat belirtilmemiş'} | ${data['grade'] ?? 'Sınıf belirtilmemiş'} ${data['section'] ?? 'Şube belirtilmemiş'}',
                                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
                              ),
                              if (isOccupied) ...[
                                Text(
                                  'Ders: ${data['currentCourse'] ?? 'Belirtilmemiş'}',
                                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Öğretim Üyesi: ${data['currentInstructor'] ?? 'Belirtilmemiş'}',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ] else ...[
                                Text(
                                  'Durum: Boş',
                                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _editClassroom(data, doc.id),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Derslik Sil'),
                                      content: Text('Bu dersliği silmek istediğinizden emin misiniz?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(),
                                          child: Text('İptal'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            try {
                                              await FirebaseFirestore.instance
                                                  .collection('classrooms')
                                                  .doc(doc.id)
                                                  .delete();
                                              
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('Derslik başarıyla silindi!'),
                                                  backgroundColor: Colors.green,
                                                  behavior: SnackBarBehavior.floating,
                                                ),
                                              );
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('Derslik silinirken hata oluştu: $e'),
                                                  backgroundColor: Colors.red,
                                                  behavior: SnackBarBehavior.floating,
                                                ),
                                              );
                                            }
                                          },
                                          child: Text('Sil', style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
} 
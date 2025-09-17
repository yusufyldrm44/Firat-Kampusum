class Faculty {
  final String id;
  final String name;
  final String code;
  final List<Department> departments;

  Faculty({
    required this.id,
    required this.name,
    required this.code,
    required this.departments,
  });

  factory Faculty.fromMap(Map<String, dynamic> map) {
    return Faculty(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      code: map['code'] ?? '',
      departments: (map['departments'] as List<dynamic>?)
          ?.map((dept) => Department.fromMap(dept))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'departments': departments.map((dept) => dept.toMap()).toList(),
    };
  }
}

class Department {
  final String id;
  final String name;
  final String code;
  final String facultyId;
  final List<Classroom> classrooms;

  Department({
    required this.id,
    required this.name,
    required this.code,
    required this.facultyId,
    required this.classrooms,
  });

  factory Department.fromMap(Map<String, dynamic> map) {
    return Department(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      code: map['code'] ?? '',
      facultyId: map['facultyId'] ?? '',
      classrooms: (map['classrooms'] as List<dynamic>?)
          ?.map((classroom) => Classroom.fromMap(classroom))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'facultyId': facultyId,
      'classrooms': classrooms.map((classroom) => classroom.toMap()).toList(),
    };
  }
}

class Classroom {
  final String id;
  final String name;
  final String building;
  final int capacity;
  final String departmentId;
  final List<String> features; // Örn: ["Projeksiyon", "Klima", "Bilgisayar"]

  Classroom({
    required this.id,
    required this.name,
    required this.building,
    required this.capacity,
    required this.departmentId,
    required this.features,
  });

  factory Classroom.fromMap(Map<String, dynamic> map) {
    return Classroom(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      building: map['building'] ?? '',
      capacity: map['capacity'] ?? 0,
      departmentId: map['departmentId'] ?? '',
      features: (map['features'] as List<dynamic>?)
          ?.map((feature) => feature.toString())
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'building': building,
      'capacity': capacity,
      'departmentId': departmentId,
      'features': features,
    };
  }
} 
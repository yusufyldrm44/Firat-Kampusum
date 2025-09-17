class ScheduleData {
  final String classroomId;
  final String classroomName;
  final String day;
  final String time;
  final String courseName;
  final String instructor;
  final String department;
  final String faculty;
  final bool isOccupied;

  ScheduleData({
    required this.classroomId,
    required this.classroomName,
    required this.day,
    required this.time,
    required this.courseName,
    required this.instructor,
    required this.department,
    required this.faculty,
    required this.isOccupied,
  });

  factory ScheduleData.fromMap(Map<String, dynamic> map) {
    return ScheduleData(
      classroomId: map['classroomId'] ?? '',
      classroomName: map['classroomName'] ?? '',
      day: map['day'] ?? '',
      time: map['time'] ?? '',
      courseName: map['courseName'] ?? '',
      instructor: map['instructor'] ?? '',
      department: map['department'] ?? '',
      faculty: map['faculty'] ?? '',
      isOccupied: map['isOccupied'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'classroomId': classroomId,
      'classroomName': classroomName,
      'day': day,
      'time': time,
      'courseName': courseName,
      'instructor': instructor,
      'department': department,
      'faculty': faculty,
      'isOccupied': isOccupied,
    };
  }
}

class ClassroomSchedule {
  final String classroomId;
  final String classroomName;
  final String building;
  final int capacity;
  final List<String> features;
  final Map<String, List<ScheduleData>> weeklySchedule;

  ClassroomSchedule({
    required this.classroomId,
    required this.classroomName,
    required this.building,
    required this.capacity,
    required this.features,
    required this.weeklySchedule,
  });

  // Belirli gün ve saatte derslik durumunu kontrol et
  bool isOccupied(String day, String time) {
    final daySchedule = weeklySchedule[day];
    if (daySchedule == null) return false;
    
    return daySchedule.any((schedule) => schedule.time == time);
  }

  // Belirli gün ve saatteki ders bilgisini getir
  ScheduleData? getSchedule(String day, String time) {
    final daySchedule = weeklySchedule[day];
    if (daySchedule == null) return null;
    
    try {
      return daySchedule.firstWhere((schedule) => schedule.time == time);
    } catch (e) {
      return null;
    }
  }

  // Dersliğin boş olduğu saatleri getir
  List<String> getAvailableTimes(String day, List<String> allTimes) {
    final daySchedule = weeklySchedule[day] ?? [];
    final occupiedTimes = daySchedule.map((s) => s.time).toList();
    
    return allTimes.where((time) => !occupiedTimes.contains(time)).toList();
  }

  // Dersliğin dolu olduğu saatleri getir
  List<ScheduleData> getOccupiedSchedules(String day) {
    return weeklySchedule[day] ?? [];
  }
}

// Örnek ders programı verileri
class SampleScheduleData {
  static List<ScheduleData> getSampleSchedules() {
    return [
      // Pazartesi dersleri
      ScheduleData(
        classroomId: '101',
        classroomName: 'Derslik 101',
        day: 'Pazartesi',
        time: '08:00-09:00',
        courseName: 'Matematik I',
        instructor: 'Dr. Ahmet Yılmaz',
        department: 'Bilgisayar Mühendisliği',
        faculty: 'Mühendislik Fakültesi',
        isOccupied: true,
      ),
      ScheduleData(
        classroomId: '101',
        classroomName: 'Derslik 101',
        day: 'Pazartesi',
        time: '09:00-10:00',
        courseName: 'Fizik I',
        instructor: 'Dr. Mehmet Demir',
        department: 'Bilgisayar Mühendisliği',
        faculty: 'Mühendislik Fakültesi',
        isOccupied: true,
      ),
      ScheduleData(
        classroomId: '101',
        classroomName: 'Derslik 101',
        day: 'Pazartesi',
        time: '10:00-11:00',
        courseName: 'Programlama',
        instructor: 'Dr. Ayşe Kaya',
        department: 'Bilgisayar Mühendisliği',
        faculty: 'Mühendislik Fakültesi',
        isOccupied: true,
      ),
      ScheduleData(
        classroomId: '102',
        classroomName: 'Derslik 102',
        day: 'Pazartesi',
        time: '08:00-09:00',
        courseName: 'Kimya',
        instructor: 'Dr. Fatma Özkan',
        department: 'Kimya Mühendisliği',
        faculty: 'Mühendislik Fakültesi',
        isOccupied: true,
      ),
      ScheduleData(
        classroomId: '102',
        classroomName: 'Derslik 102',
        day: 'Pazartesi',
        time: '09:00-10:00',
        courseName: 'İstatistik',
        instructor: 'Dr. Ali Çelik',
        department: 'İstatistik',
        faculty: 'Fen Fakültesi',
        isOccupied: true,
      ),
      
      // Salı dersleri
      ScheduleData(
        classroomId: '101',
        classroomName: 'Derslik 101',
        day: 'Salı',
        time: '08:00-09:00',
        courseName: 'Veri Yapıları',
        instructor: 'Dr. Zeynep Arslan',
        department: 'Bilgisayar Mühendisliği',
        faculty: 'Mühendislik Fakültesi',
        isOccupied: true,
      ),
      ScheduleData(
        classroomId: '101',
        classroomName: 'Derslik 101',
        day: 'Salı',
        time: '09:00-10:00',
        courseName: 'Algoritma',
        instructor: 'Dr. Mustafa Şahin',
        department: 'Bilgisayar Mühendisliği',
        faculty: 'Mühendislik Fakültesi',
        isOccupied: true,
      ),
      ScheduleData(
        classroomId: '201',
        classroomName: 'Derslik 201',
        day: 'Salı',
        time: '10:00-11:00',
        courseName: 'Mikroişlemciler',
        instructor: 'Dr. Emine Yıldız',
        department: 'Elektrik-Elektronik Mühendisliği',
        faculty: 'Mühendislik Fakültesi',
        isOccupied: true,
      ),
      
      // Çarşamba dersleri
      ScheduleData(
        classroomId: '101',
        classroomName: 'Derslik 101',
        day: 'Çarşamba',
        time: '13:00-14:00',
        courseName: 'Veritabanı Sistemleri',
        instructor: 'Dr. Hasan Özkan',
        department: 'Bilgisayar Mühendisliği',
        faculty: 'Mühendislik Fakültesi',
        isOccupied: true,
      ),
      ScheduleData(
        classroomId: '202',
        classroomName: 'Derslik 202',
        day: 'Çarşamba',
        time: '14:00-15:00',
        courseName: 'İşletim Sistemleri',
        instructor: 'Dr. Seda Demir',
        department: 'Bilgisayar Mühendisliği',
        faculty: 'Mühendislik Fakültesi',
        isOccupied: true,
      ),
      
      // Perşembe dersleri
      ScheduleData(
        classroomId: '301',
        classroomName: 'Derslik 301',
        day: 'Perşembe',
        time: '15:00-16:00',
        courseName: 'Ağ Teknolojileri',
        instructor: 'Dr. Kemal Yılmaz',
        department: 'Bilgisayar Mühendisliği',
        faculty: 'Mühendislik Fakültesi',
        isOccupied: true,
      ),
      
      // Cuma dersleri
      ScheduleData(
        classroomId: '101',
        classroomName: 'Derslik 101',
        day: 'Cuma',
        time: '16:00-17:00',
        courseName: 'Yazılım Mühendisliği',
        instructor: 'Dr. Elif Kaya',
        department: 'Bilgisayar Mühendisliği',
        faculty: 'Mühendislik Fakültesi',
        isOccupied: true,
      ),
    ];
  }

  // Derslik ID'sine göre program oluştur
  static ClassroomSchedule createClassroomSchedule(String classroomId, String classroomName, String building, int capacity, List<String> features) {
    final allSchedules = getSampleSchedules();
    final classroomSchedules = allSchedules.where((s) => s.classroomId == classroomId).toList();
    
    Map<String, List<ScheduleData>> weeklySchedule = {
      'Pazartesi': classroomSchedules.where((s) => s.day == 'Pazartesi').toList(),
      'Salı': classroomSchedules.where((s) => s.day == 'Salı').toList(),
      'Çarşamba': classroomSchedules.where((s) => s.day == 'Çarşamba').toList(),
      'Perşembe': classroomSchedules.where((s) => s.day == 'Perşembe').toList(),
      'Cuma': classroomSchedules.where((s) => s.day == 'Cuma').toList(),
      'Cumartesi': classroomSchedules.where((s) => s.day == 'Cumartesi').toList(),
      'Pazar': classroomSchedules.where((s) => s.day == 'Pazar').toList(),
    };

    return ClassroomSchedule(
      classroomId: classroomId,
      classroomName: classroomName,
      building: building,
      capacity: capacity,
      features: features,
      weeklySchedule: weeklySchedule,
    );
  }
} 
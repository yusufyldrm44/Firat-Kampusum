import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  bool isLoading = false;
  String? editingField;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController facultyController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() { isLoading = true; });
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();
      if (data != null && mounted) {
        nameController.text = data['name'] ?? '';
        surnameController.text = data['surname'] ?? '';
        phoneController.text = data['phone'] ?? '';
        birthdateController.text = data['birthdate'] ?? '';
        facultyController.text = data['faculty'] ?? '';
        departmentController.text = data['department'] ?? '';
      }
    }
    if (mounted) {
      setState(() { isLoading = false; });
    }
  }

  Future<void> _saveSingleField(String field, TextEditingController controller) async {
    if (!_validateField(field, controller.text)) return;
    setState(() { isLoading = true; });
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        field: controller.text.trim(),
      }, SetOptions(merge: true));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profil güncellendi!'),
            backgroundColor: Color(0xFF8B0000),
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() {
          editingField = null;
        });
      }
    }
    if (mounted) {
      setState(() { isLoading = false; });
    }
  }

  bool _validateField(String field, String value) {
    if (field == 'name' && value.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ad giriniz'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }
    if (field == 'surname' && value.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Soyad giriniz'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }
    if (field == 'phone') {
      if (value.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Telefon giriniz'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return false;
      }
      if (!value.startsWith('05')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Telefon 05 ile başlamalı'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return false;
      }
      if (value.length != 11) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Telefon 11 haneli olmalı'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return false;
      }
    }
    if (field == 'birthdate') {
      // GG/AA/YYYY formatı ve geçerli tarih kontrolü
      if (!RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(value)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Doğum tarihi GG/AA/YYYY formatında olmalı'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return false;
      }
      try {
        final parts = value.split('/');
        if (parts.length != 3) throw Exception();
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        final date = DateTime(year, month, day);
        if (date.year != year || date.month != month || date.day != day) {
          throw Exception();
        }
      } catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Geçerli bir doğum tarihi giriniz'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return false;
      }
    }
    return true;
  }

  Widget _buildProfileField({
    required String label,
    required String value,
    required String field,
    required TextEditingController controller,
    required TextInputType keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? hintText,
    IconData? icon,
  }) {
    final isThisEditing = editingField == field;
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: Color(0xFF8B0000), size: 20),
                  SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                Spacer(),
                if (!isThisEditing)
                  IconButton(
                    icon: Icon(Icons.edit_outlined, color: Color(0xFF8B0000), size: 20),
                    onPressed: () => setState(() => editingField = field),
                  ),
              ],
            ),
            SizedBox(height: 12),
            if (isThisEditing)
              Column(
                children: [
                  TextFormField(
                    controller: controller,
                    autofocus: true,
                    keyboardType: keyboardType,
                    inputFormatters: inputFormatters,
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Color(0xFF8B0000), width: 2),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => setState(() => editingField = null),
                        child: Text(
                          'İptal',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _saveSingleField(field, controller),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF8B0000),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('Kaydet'),
                      ),
                    ],
                  ),
                ],
              )
            else
              Text(
                value.isNotEmpty ? value : '-',
                style: TextStyle(
                  fontSize: 16,
                  color: value.isNotEmpty ? Colors.black87 : Colors.grey[500],
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Profilim',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Color(0xFF8B0000),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B0000)),
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  // Profil Fotoğrafı Alanı
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Color(0xFF8B0000).withOpacity(0.1),
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Color(0xFF8B0000),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '${nameController.text} ${surnameController.text}'.trim().isNotEmpty 
                              ? '${nameController.text} ${surnameController.text}'
                              : 'Profil Bilgilerinizi Doldurun',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B0000),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Fırat Üniversitesi',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  
                  // Profil Bilgileri
                  _buildProfileField(
                    label: 'Ad',
                    value: nameController.text,
                    field: 'name',
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    icon: Icons.person_outline,
                  ),
                  _buildProfileField(
                    label: 'Soyad',
                    value: surnameController.text,
                    field: 'surname',
                    controller: surnameController,
                    keyboardType: TextInputType.text,
                    icon: Icons.person_outline,
                  ),
                  _buildProfileField(
                    label: 'Telefon',
                    value: phoneController.text,
                    field: 'phone',
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                    ],
                    hintText: '05XXXXXXXXX',
                    icon: Icons.phone_outlined,
                  ),
                  _buildProfileField(
                    label: 'Doğum Tarihi',
                    value: birthdateController.text,
                    field: 'birthdate',
                    controller: birthdateController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                      _DateInputFormatter(),
                    ],
                    hintText: 'GG/AA/YYYY',
                    icon: Icons.calendar_today_outlined,
                  ),
                  _buildProfileField(
                    label: 'Fakülte',
                    value: facultyController.text,
                    field: 'faculty',
                    controller: facultyController,
                    keyboardType: TextInputType.text,
                    icon: Icons.school_outlined,
                  ),
                  _buildProfileField(
                    label: 'Bölüm',
                    value: departmentController.text,
                    field: 'department',
                    controller: departmentController,
                    keyboardType: TextInputType.text,
                    icon: Icons.book_outlined,
                  ),
                  
                  // Alt boşluk
                  SizedBox(height: 80),
                ],
              ),
            ),
    );
  }
}

// Doğum tarihi için otomatik '/' ekleyen input formatter
class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    if (text.length == 2 && oldValue.text.length == 1) {
      text += '/';
    } else if (text.length == 5 && oldValue.text.length == 4) {
      text += '/';
    }
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
} 
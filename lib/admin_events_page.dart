import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'initialize_data.dart';

class AdminEventsPage extends StatefulWidget {
  const AdminEventsPage({Key? key}) : super(key: key);
  
  @override
  _AdminEventsPageState createState() => _AdminEventsPageState();
}

class _AdminEventsPageState extends State<AdminEventsPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _detailsController = TextEditingController();
  final _imageController = TextEditingController();
  bool _isLoading = false;
  String _selectedCategory = 'Akademik';
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  final List<String> _categories = ['Akademik', 'Kültür-Sanat', 'Spor'];

  @override
  void initState() {
    super.initState();
    _dateController.text = _formatDate(DateTime.now());
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _detailsController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _imageController.text = image.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Resim seçilirken hata oluştu: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<String?> _uploadImage() async {
    if (_selectedImage == null) {
      return _imageController.text.isNotEmpty ? _imageController.text : null;
    }

    try {
      // Yükleme başladı mesajı
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Resim işleniyor...'),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );

      // Resmi base64'e çevir
      final bytes = await _selectedImage!.readAsBytes();
      final base64String = base64Encode(bytes);
      
      // Başarı mesajı
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Resim başarıyla işlendi!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      
      print('Image processed successfully. Size: ${bytes.length} bytes');
      return 'data:image/jpeg;base64,$base64String';
    } catch (e) {
      print('Image processing error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Resim işlenirken hata oluştu: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 5),
        ),
      );
      return null;
    }
  }

  Future<void> _addEvent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Resim yükle
      String? imageUrl;
      if (_selectedImage != null) {
        print('Starting image upload...');
        imageUrl = await _uploadImage();
        print('Image upload result: $imageUrl');
      } else if (_imageController.text.isNotEmpty) {
        imageUrl = _imageController.text;
        print('Using URL from text field: $imageUrl');
      }
      
      print('Adding event to Firestore with image: $imageUrl');
      
      await FirebaseFirestore.instance.collection('events').add({
        'title': _titleController.text,
        'category': _selectedCategory,
        'date': _dateController.text,
        'time': _timeController.text,
        'location': _locationController.text,
        'description': _descriptionController.text,
        'details': _detailsController.text,
        'image': imageUrl ?? '',
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Etkinlik başarıyla eklendi!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Formu temizle
      _formKey.currentState!.reset();
      _titleController.clear();
      _timeController.clear();
      _locationController.clear();
      _descriptionController.clear();
      _detailsController.clear();
      _imageController.clear();
      _dateController.text = _formatDate(DateTime.now());
      setState(() {
        _selectedCategory = 'Akademik';
        _selectedImage = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Etkinlik eklenirken hata oluştu: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteEvent(String eventId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Etkinlik Sil'),
          content: Text('Bu etkinliği silmek istediğinizden emin misiniz?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('İptal'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await FirebaseFirestore.instance.collection('events').doc(eventId).delete();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Etkinlik başarıyla silindi!'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Etkinlik silinirken hata oluştu: $e'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: Text('Sil'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Etkinlik Yönetimi'),
        backgroundColor: Color(0xFF8B0000),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Yeni Etkinlik Ekleme Formu
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Yeni Etkinlik Ekle',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B0000),
                        ),
                      ),
                      SizedBox(height: 16),
                      
                      // Başlık
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Etkinlik Başlığı',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.title),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Başlık gerekli';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      
                      // Kategori
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: InputDecoration(
                          labelText: 'Kategori',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.category),
                        ),
                        items: _categories.map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCategory = newValue!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kategori gerekli';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      
                      // Tarih ve Saat
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(Duration(days: 365)),
                                );
                                if (picked != null) {
                                  setState(() {
                                    _dateController.text = _formatDate(picked);
                                  });
                                }
                              },
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: _dateController,
                                  decoration: InputDecoration(
                                    labelText: 'Tarih (GG/AA/YYYY)',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.calendar_today),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Tarih gerekli';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _timeController,
                              decoration: InputDecoration(
                                labelText: 'Saat',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.access_time),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Saat gerekli';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      
                      // Konum
                      TextFormField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          labelText: 'Konum',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_on),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Konum gerekli';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      
                      // Kısa Açıklama
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Kısa Açıklama',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.description),
                        ),
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kısa açıklama gerekli';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      
                      // Detaylı Açıklama
                      TextFormField(
                        controller: _detailsController,
                        decoration: InputDecoration(
                          labelText: 'Detaylı Açıklama',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.article),
                        ),
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Detaylı açıklama gerekli';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      
                      // Resim Seçme
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Etkinlik Resmi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF8B0000),
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _pickImage,
                                  icon: Icon(Icons.photo_library),
                                  label: Text('Galeriden Fotoğraf Seç'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF8B0000),
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (_selectedImage != null) ...[
                            SizedBox(height: 12),
                            Container(
                              height: 120,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _imageController,
                            decoration: InputDecoration(
                              labelText: 'Resim URL (Opsiyonel)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.link),
                              helperText: 'Galeriden fotoğraf seçmezseniz URL girebilirsiniz',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      
                      // Ekle Butonu
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _addEvent,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF8B0000),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(
                                  'Etkinlik Ekle',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 24),
            
            // Mevcut Etkinlikler
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mevcut Etkinlikler',
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
                        await FirebaseFirestore.instance
                            .collection('events')
                            .get()
                            .then((snapshot) {
                          final batch = FirebaseFirestore.instance.batch();
                          for (var doc in snapshot.docs) {
                            batch.delete(doc.reference);
                          }
                          return batch.commit();
                        });
                        
                        // Statik etkinlikleri yeniden yükle
                        await InitializeData.initializeEvents();
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Etkinlikler sıfırlandı ve statik veriler yeniden yüklendi!'),
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
                  .collection('events')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Etkinlikler yüklenirken hata oluştu',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }
                
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Henüz etkinlik eklenmemiş',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                final events = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    final data = event.data() as Map<String, dynamic>;
                    
                    return Card(
                      margin: EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getCategoryColor(data['category']),
                          child: Icon(
                            _getCategoryIcon(data['category']),
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          data['title'] ?? 'Başlık Yok',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${data['category']} • ${data['date']}'),
                            Text(data['location'] ?? ''),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteEvent(event.id),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String? category) {
    switch (category) {
      case 'Akademik':
        return Colors.blue;
      case 'Kültür-Sanat':
        return Colors.purple;
      case 'Spor':
        return Colors.green;
      default:
        return Color(0xFF8B0000);
    }
  }

  IconData _getCategoryIcon(String? category) {
    switch (category) {
      case 'Akademik':
        return Icons.school;
      case 'Kültür-Sanat':
        return Icons.palette;
      case 'Spor':
        return Icons.sports_soccer;
      default:
        return Icons.event;
    }
  }
} 
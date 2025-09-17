import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminNewsPage extends StatefulWidget {
  @override
  _AdminNewsPageState createState() => _AdminNewsPageState();
}

class _AdminNewsPageState extends State<AdminNewsPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _detailController = TextEditingController();
  final _dateController = TextEditingController();
  final _imageController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _dateController.text = DateTime.now().toString().split(' ')[0];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _detailController.dispose();
    _dateController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _addNews() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('news').add({
        'title': _titleController.text,
        'desc': _descController.text,
        'detail': _detailController.text,
        'date': _dateController.text,
        'image': _imageController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Haber başarıyla eklendi!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Formu temizle
      _formKey.currentState!.reset();
      _titleController.clear();
      _descController.clear();
      _detailController.clear();
      _imageController.clear();
      _dateController.text = DateTime.now().toString().split(' ')[0];
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Haber eklenirken hata oluştu: $e'),
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

  Future<void> _deleteNews(String newsId) async {
    try {
      await FirebaseFirestore.instance.collection('news').doc(newsId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Haber başarıyla silindi!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Haber silinirken hata oluştu: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Haber Yönetimi'),
        backgroundColor: Color(0xFF8B0000),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Yeni Haber Ekleme Formu
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Yeni Haber Ekle',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B0000),
                        ),
                      ),
                      SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Başlık',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Başlık gerekli';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12),
                      
                      TextFormField(
                        controller: _descController,
                        decoration: InputDecoration(
                          labelText: 'Kısa Açıklama',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kısa açıklama gerekli';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12),
                      
                      TextFormField(
                        controller: _detailController,
                        decoration: InputDecoration(
                          labelText: 'Detaylı Açıklama',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Detaylı açıklama gerekli';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12),
                      
                      TextFormField(
                        controller: _dateController,
                        decoration: InputDecoration(
                          labelText: 'Tarih (YYYY-MM-DD)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Tarih gerekli';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12),
                      
                      TextFormField(
                        controller: _imageController,
                        decoration: InputDecoration(
                          labelText: 'Resim URL (Opsiyonel)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _addNews,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF8B0000),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text('Haber Ekle'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 24),
            
            // Mevcut Haberler
            Text(
              'Mevcut Haberler',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8B0000),
              ),
            ),
            SizedBox(height: 16),
            
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('news')
                  .orderBy('timestamp', descending: true)
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
                        'Henüz haber bulunmuyor.',
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
                    
                    return Card(
                      margin: EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(
                          data['title'] ?? 'Başlıksız',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['desc'] ?? ''),
                            SizedBox(height: 4),
                            Text(
                              'Tarih: ${data['date'] ?? ''}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Haber Sil'),
                                content: Text('Bu haberi silmek istediğinizden emin misiniz?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: Text('İptal'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      _deleteNews(doc.id);
                                    },
                                    child: Text('Sil', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
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
} 
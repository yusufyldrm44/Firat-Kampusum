import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminNotificationsPage extends StatefulWidget {
  @override
  _AdminNotificationsPageState createState() => _AdminNotificationsPageState();
}

class _AdminNotificationsPageState extends State<AdminNotificationsPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _sendNotification() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Bildirimi hem notifications hem de userNotifications koleksiyonlarına kaydet
      final notificationData = {
        'title': _titleController.text,
        'message': _bodyController.text, // body yerine message kullanıyoruz
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      };

      // Ana notifications koleksiyonuna kaydet (admin paneli için)
      await FirebaseFirestore.instance.collection('notifications').add(notificationData);

      // userNotifications koleksiyonuna kaydet (kullanıcı uygulaması için)
      await FirebaseFirestore.instance.collection('userNotifications').add(notificationData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bildirim başarıyla gönderildi!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Formu temizle
      _formKey.currentState!.reset();
      _titleController.clear();
      _bodyController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bildirim gönderilirken hata oluştu: $e'),
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

  Future<void> _deleteNotification(String notificationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(notificationId)
          .delete();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bildirim başarıyla silindi!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bildirim silinirken hata oluştu: $e'),
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
        title: Text('Bildirim Yönetimi'),
        backgroundColor: Color(0xFF8B0000),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Yeni Bildirim Gönderme Formu
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
                        'Yeni Bildirim Gönder',
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
                          labelText: 'Bildirim Başlığı',
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
                        controller: _bodyController,
                        decoration: InputDecoration(
                          labelText: 'Bildirim İçeriği',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'İçerik gerekli';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _sendNotification,
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
                              : Text('Bildirim Gönder'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 24),
            
            // Gönderilen Bildirimler
            Text(
              'Gönderilen Bildirimler',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8B0000),
              ),
            ),
            SizedBox(height: 16),
            
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('notifications')
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
                        'Henüz bildirim bulunmuyor.',
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
                    final timestamp = data['timestamp'] as Timestamp?;
                    final date = timestamp?.toDate();
                    
                    return Card(
                      margin: EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color(0xFF8B0000),
                          child: Icon(Icons.notifications, color: Colors.white),
                        ),
                        title: Text(
                          data['title'] ?? 'Başlıksız',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['message'] ?? ''), // message yerine body kullanıyoruz
                            SizedBox(height: 4),
                            Text(
                              'Tarih: ${date != null ? '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}' : 'Bilinmiyor'}',
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
                                title: Text('Bildirim Sil'),
                                content: Text('Bu bildirimi silmek istediğinizden emin misiniz?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: Text('İptal'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      _deleteNotification(doc.id);
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
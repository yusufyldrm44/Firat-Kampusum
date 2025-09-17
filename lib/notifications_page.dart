import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String selectedFilter = 'Tümü';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bildirimler'),
        backgroundColor: Color(0xFF8B0000),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.done_all),
            onPressed: _markAllAsRead,
            tooltip: 'Tümünü Okundu İşaretle',
          ),
          IconButton(
            icon: Icon(Icons.delete_sweep),
            onPressed: _clearAllNotifications,
            tooltip: 'Tümünü Temizle',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtreler
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildFilterChip('Tümü', selectedFilter == 'Tümü', () {
                    setState(() {
                      selectedFilter = 'Tümü';
                    });
                  }),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _buildFilterChip('Okunmamış', selectedFilter == 'Okunmamış', () {
                    setState(() {
                      selectedFilter = 'Okunmamış';
                    });
                  }),
                ),
              ],
            ),
          ),
          
          // Bildirimler Listesi
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('userNotifications')
                  .orderBy('timestamp', descending: true)
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
                  return _buildEmptyState();
                }

                List<QueryDocumentSnapshot> filteredDocs = snapshot.data!.docs;
                
                // Filtreleme
                if (selectedFilter == 'Okunmamış') {
                  filteredDocs = filteredDocs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return data['isRead'] == false;
                  }).toList();
                }

                return ListView.builder(
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final doc = filteredDocs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    return _buildNotificationItem(doc.id, data);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF8B0000) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildNotificationItem(String id, Map<String, dynamic> notification) {
    final isRead = notification['isRead'] ?? false;
    final timestamp = notification['timestamp'] as Timestamp?;
    final timeAgo = _getTimeAgo(timestamp);
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isRead ? Colors.white : Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isRead ? Colors.grey[200]! : Colors.blue[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF8B0000).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.notifications,
            color: Color(0xFF8B0000),
            size: 20,
          ),
        ),
        title: Text(
          notification['title'] ?? 'Bildirim',
          style: TextStyle(
            fontSize: 16,
            fontWeight: isRead ? FontWeight.w500 : FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              notification['message'] ?? '',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.3,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 12, color: Colors.grey[500]),
                SizedBox(width: 4),
                Text(
                  timeAgo,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                Spacer(),
                if (!isRead)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ],
        ),
        onTap: () => _markAsRead(id),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: Colors.grey[600]),
          onSelected: (value) {
            if (value == 'delete') {
              _deleteNotification(id);
            } else if (value == 'mark_read') {
              _markAsRead(id);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'mark_read',
              child: Text('Okundu İşaretle'),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Text('Sil'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'Bildirim Yok',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Yeni bildirimler geldiğinde burada görünecek',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _markAsRead(String id) {
    FirebaseFirestore.instance
        .collection('userNotifications')
        .doc(id)
        .update({'isRead': true});
  }

  void _markAllAsRead() {
    FirebaseFirestore.instance
        .collection('userNotifications')
        .where('isRead', isEqualTo: false)
        .get()
        .then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.update({'isRead': true});
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tüm bildirimler okundu olarak işaretlendi'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _deleteNotification(String id) {
    FirebaseFirestore.instance
        .collection('userNotifications')
        .doc(id)
        .delete();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bildirim silindi'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _clearAllNotifications() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tüm Bildirimleri Temizle'),
          content: Text('Tüm bildirimleri silmek istediğinizden emin misiniz?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('userNotifications')
                    .get()
                    .then((snapshot) {
                  for (var doc in snapshot.docs) {
                    doc.reference.delete();
                  }
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Tüm bildirimler temizlendi'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: Text('Temizle'),
            ),
          ],
        );
      },
    );
  }

  String _getTimeAgo(Timestamp? timestamp) {
    if (timestamp == null) return 'Bilinmeyen zaman';
    
    final now = DateTime.now();
    final time = timestamp.toDate();
    final difference = now.difference(time);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} gün önce';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} saat önce';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} dakika önce';
    } else {
      return 'Az önce';
    }
  }
} 
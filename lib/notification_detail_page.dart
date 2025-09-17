import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationDetailPage extends StatefulWidget {
  final String notificationId;
  final Map<String, dynamic> notificationData;

  const NotificationDetailPage({
    Key? key,
    required this.notificationId,
    required this.notificationData,
  }) : super(key: key);

  @override
  _NotificationDetailPageState createState() => _NotificationDetailPageState();
}

class _NotificationDetailPageState extends State<NotificationDetailPage> {
  bool _isRead = false;

  @override
  void initState() {
    super.initState();
    _isRead = widget.notificationData['isRead'] ?? false;
    // Bildirimi okundu olarak işaretle
    if (!_isRead) {
      _markAsRead();
    }
  }

  Future<void> _markAsRead() async {
    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(widget.notificationId)
          .update({'isRead': true});
      
      setState(() {
        _isRead = true;
      });
    } catch (e) {
      print('Bildirim okundu işaretlenirken hata: $e');
    }
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'Bilinmiyor';
    
    if (timestamp is Timestamp) {
      final date = timestamp.toDate();
      final now = DateTime.now();
      final difference = now.difference(date);
      
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
    
    return 'Bilinmiyor';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bildirim Detayı'),
        backgroundColor: Color(0xFF8B0000),
        foregroundColor: Colors.white,
        actions: [
          if (!_isRead)
            IconButton(
              icon: Icon(Icons.mark_email_read),
              onPressed: _markAsRead,
              tooltip: 'Okundu İşaretle',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                         // Bildirim Başlığı
             Container(
               width: double.infinity,
               padding: EdgeInsets.all(20),
               decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.circular(12),
                 boxShadow: [
                   BoxShadow(
                     color: Colors.grey.withOpacity(0.2),
                     spreadRadius: 2,
                     blurRadius: 8,
                     offset: Offset(0, 2),
                   ),
                 ],
               ),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Row(
                     children: [
                       Container(
                         padding: EdgeInsets.all(12),
                         decoration: BoxDecoration(
                           color: Color(0xFF8B0000).withOpacity(0.1),
                           borderRadius: BorderRadius.circular(12),
                         ),
                         child: Icon(
                           Icons.notifications,
                           color: Color(0xFF8B0000),
                           size: 24,
                         ),
                       ),
                       SizedBox(width: 16),
                       Expanded(
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(
                               widget.notificationData['title'] ?? 'Başlıksız',
                               style: TextStyle(
                                 fontSize: 20,
                                 fontWeight: FontWeight.bold,
                                 color: Colors.black87,
                               ),
                             ),
                             SizedBox(height: 4),
                             Row(
                               children: [
                                 Icon(
                                   Icons.access_time,
                                   size: 14,
                                   color: Colors.grey[600],
                                 ),
                                 SizedBox(width: 4),
                                 Text(
                                   _formatTimestamp(widget.notificationData['timestamp']),
                                   style: TextStyle(
                                     fontSize: 14,
                                     color: Colors.grey[600],
                                   ),
                                 ),
                                 SizedBox(width: 16),
                                 Container(
                                   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                   decoration: BoxDecoration(
                                     color: _isRead ? Colors.green[100] : Colors.red[100],
                                     borderRadius: BorderRadius.circular(12),
                                   ),
                                   child: Text(
                                     _isRead ? 'Okundu' : 'Okunmadı',
                                     style: TextStyle(
                                       fontSize: 12,
                                       color: _isRead ? Colors.green[700] : Colors.red[700],
                                       fontWeight: FontWeight.w500,
                                     ),
                                   ),
                                 ),
                               ],
                             ),
                           ],
                         ),
                       ),
                     ],
                   ),
                 ],
               ),
             ),
            
            SizedBox(height: 20),
            
                         // Bildirim İçeriği
             Container(
               width: double.infinity,
               padding: EdgeInsets.all(20),
               decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.circular(12),
                 boxShadow: [
                   BoxShadow(
                     color: Colors.grey.withOpacity(0.2),
                     spreadRadius: 2,
                     blurRadius: 8,
                     offset: Offset(0, 2),
                   ),
                 ],
               ),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(
                     'Bildirim İçeriği',
                     style: TextStyle(
                       fontSize: 18,
                       fontWeight: FontWeight.bold,
                       color: Color(0xFF8B0000),
                     ),
                   ),
                   SizedBox(height: 16),
                   Text(
                     widget.notificationData['body'] ?? 'İçerik bulunamadı',
                     style: TextStyle(
                       fontSize: 16,
                       color: Colors.black87,
                       height: 1.5,
                     ),
                   ),
                 ],
               ),
             ),
            
            SizedBox(height: 20),
            
                         // Bildirim Bilgileri
             Container(
               width: double.infinity,
               padding: EdgeInsets.all(20),
               decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.circular(12),
                 boxShadow: [
                   BoxShadow(
                     color: Colors.grey.withOpacity(0.2),
                     spreadRadius: 2,
                     blurRadius: 8,
                     offset: Offset(0, 2),
                   ),
                 ],
               ),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(
                     'Bildirim Bilgileri',
                     style: TextStyle(
                       fontSize: 18,
                       fontWeight: FontWeight.bold,
                       color: Color(0xFF8B0000),
                     ),
                   ),
                   SizedBox(height: 16),
                   _buildInfoRow('Bildirim ID', widget.notificationId),
                   _buildInfoRow('Durum', _isRead ? 'Okundu' : 'Okunmadı'),
                   _buildInfoRow('Gönderilme Zamanı', _formatTimestamp(widget.notificationData['timestamp'])),
                   _buildInfoRow('Tür', 'Sistem Bildirimi'),
                 ],
               ),
             ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Text(
            ': ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 
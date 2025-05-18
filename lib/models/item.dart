import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String id;
  final String title;
  final String createdBy;
  final Timestamp createdAt;

  Item({
    required this.id,
    required this.title,
    required this.createdBy,
    required this.createdAt,
  });

  factory Item.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Item(
      id: doc.id,
      title: data['title'] as String,
      createdBy: data['createdBy'] as String,
      createdAt: data['createdAt'] as Timestamp,
    );
  }

  Map<String, dynamic> toMap() => {
    'title': title,
    'createdBy': createdBy,
    'createdAt': createdAt,
  };
}

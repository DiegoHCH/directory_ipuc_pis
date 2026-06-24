import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SupportContact {
  final String name;
  final String phone;

  const SupportContact({required this.name, required this.phone});

  factory SupportContact.fromMap(Map<String, dynamic> map) => SupportContact(
        name: map['name'] as String? ?? '',
        phone: map['phone'] as String? ?? '',
      );
}

final supportContactProvider = FutureProvider<SupportContact>((ref) async {
  final doc = await FirebaseFirestore.instance
      .collection('config')
      .doc('support')
      .get();
  return SupportContact.fromMap(doc.data() ?? {});
});

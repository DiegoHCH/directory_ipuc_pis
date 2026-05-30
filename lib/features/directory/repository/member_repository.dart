import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/member.dart';

class MemberRepository {
  MemberRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('members');

  /// Stream en tiempo real de todos los miembros visibles, ordenados por nombre.
  Stream<List<Member>> watchVisibleMembers() => _col
      .where('visible', isEqualTo: true)
      .snapshots()
      .map((snap) => snap.docs
          .map((d) => Member.fromMap(d.id, d.data()))
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name)));

  /// Todos los miembros (uso admin).
  Stream<List<Member>> watchAllMembers() => _col
      .snapshots()
      .map((snap) => snap.docs
          .map((d) => Member.fromMap(d.id, d.data()))
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name)));

  Future<void> add(Member member) => _col.add({
        ...member.toMap(),
        'visible': true,
        'createdAt': FieldValue.serverTimestamp(),
      });

  Future<void> update(Member member) =>
      _col.doc(member.id).update(member.toMap());

  Future<void> setVisible(String id, {required bool visible}) =>
      _col.doc(id).update({'visible': visible});

  Future<void> delete(String id) => _col.doc(id).delete();
}

// ── Providers ─────────────────────────────────────────────────────────────────

final memberRepositoryProvider = Provider<MemberRepository>(
  (ref) => MemberRepository(FirebaseFirestore.instance),
);

final membersStreamProvider = StreamProvider<List<Member>>((ref) {
  return ref.watch(memberRepositoryProvider).watchVisibleMembers();
});

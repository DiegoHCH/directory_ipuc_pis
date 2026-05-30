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

  /// Crea el perfil del hermano ya verificado. Usa el uid de Auth como id
  /// del documento, para vincular sesión ↔ perfil. Retorna el Member guardado.
  Future<Member> add(Member member, {required String uid}) async {
    await _col.doc(uid).set({
      ...member.toMap(),
      'visible': true,
      'verified': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return member.copyWith(id: uid, verified: true);
  }

  /// True si ya existe un perfil con ese número de teléfono.
  Future<bool> phoneExists(String phone) async {
    final snap = await _col.where('phone', isEqualTo: phone).limit(1).get();
    return snap.docs.isNotEmpty;
  }

  /// Busca el perfil asociado a un uid (null si no existe).
  Future<Member?> getByUid(String uid) async {
    final doc = await _col.doc(uid).get();
    if (!doc.exists) return null;
    return Member.fromMap(doc.id, doc.data()!);
  }

  /// Stream en vivo del perfil de un uid (null si no existe).
  Stream<Member?> watchByUid(String uid) =>
      _col.doc(uid).snapshots().map((doc) =>
          doc.exists ? Member.fromMap(doc.id, doc.data()!) : null);

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

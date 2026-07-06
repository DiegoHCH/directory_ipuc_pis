import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/repository/auth_repository.dart';
import '../../directory/model/member.dart';
import '../../directory/repository/member_repository.dart';

/// Perfil del hermano con sesión activa.
/// - `null` mientras carga o si no hay sesión / perfil.
/// - Reacciona a cambios de sesión y a ediciones del perfil en vivo.
final currentMemberProvider = StreamProvider<Member?>((ref) {
  final authState = ref.watch(authStateProvider);
  final user = authState.value;

  if (user == null) return Stream.value(null);

  return ref.watch(memberRepositoryProvider).watchByUid(user.uid);
});

/// True si hay un hermano autenticado con perfil.
final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).value != null;
});

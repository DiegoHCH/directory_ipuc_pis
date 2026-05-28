import '../../directory/model/member.dart';

class RegisterForm {
  final String name;
  final MemberCategory category;
  final String bio;
  final List<String> offers;
  final String phone;

  const RegisterForm({
    required this.name,
    required this.category,
    required this.bio,
    required this.offers,
    required this.phone,
  });
}

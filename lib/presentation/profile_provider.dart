import 'package:flutter_riverpod/legacy.dart';

// 5. Profil PROOVIDER (stateProvider)
class UserProfile {
  final String name;
  final String email;

  UserProfile({required this.name, required this.email});
}

final userProfileProvider = StateProvider<UserProfile>((ref) {
  return UserProfile(name: 'Maniga Tokpa', email: 'maniga.tokpa@example.com');
});

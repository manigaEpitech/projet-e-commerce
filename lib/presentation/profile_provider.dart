import 'package:flutter_riverpod/legacy.dart';
import '../../domain/user_profile.dart';

class ProfileNotifier extends StateNotifier<UserProfile> {
  ProfileNotifier()
    : super(
        UserProfile(
          name: 'Maniga Tokpa',
          email: 'maniga.tokpa@example.com',
          avatarUrl: 'assets/images/profile.jpg',
        ),
      );

  void updateName(String newName) {
    state = UserProfile(
      name: newName,
      email: state.email,
      avatarUrl: state.avatarUrl,
    );
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, UserProfile>((
  ref,
) {
  return ProfileNotifier();
});

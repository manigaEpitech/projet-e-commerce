import 'package:flutter/foundation.dart';

@immutable
class UserProfile {
  final String name;
  final String email;
  final String avatarUrl;

  const UserProfile({
    required this.name,
    required this.email,
    required this.avatarUrl,
  });

  UserProfile copyWith({String? name, String? email, String? avatarUrl}) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfile &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          email == other.email &&
          avatarUrl == other.avatarUrl;

  @override
  int get hashCode => name.hashCode ^ email.hashCode ^ avatarUrl.hashCode;
}

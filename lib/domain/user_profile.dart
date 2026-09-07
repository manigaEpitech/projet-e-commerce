/// Modèle de données pour le profil utilisateur exigé par le cahier des charges.
class UserProfile {
  final String name;
  final String email;
  final String avatarUrl;

  UserProfile({
    required this.name,
    required this.email,
    required this.avatarUrl,
  });
}

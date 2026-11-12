import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfile {
  final String id;
  final String email;
  final String name;
  final String role; // seeker | owner | admin

  const UserProfile({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });

  bool get isSeeker => role == 'seeker';
  bool get isOwner => role == 'owner';
  bool get isAdmin => role == 'admin';

  String get roleLabel {
    switch (role) {
      case 'owner':
        return 'Dosen / Pengelola (owner)';
      case 'admin':
        return 'Administrator (admin)';
      default:
        return 'Mahasiswa (seeker)';
    }
  }

  factory UserProfile.fromMap(Map<String, dynamic> m) => UserProfile(
        id: m['id'] as String,
        email: (m['email'] ?? '') as String,
        name: (m['name'] ?? '') as String,
        role: (m['role'] ?? 'seeker') as String,
      );
}

class ProfileService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<UserProfile?> getMyProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    final data = await _client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (data == null) {
      return UserProfile(
        id: user.id,
        email: user.email ?? '-',
        name: (user.userMetadata?['name'] ?? 'Jamilatul Amalia') as String,
        role: (user.userMetadata?['role'] ?? 'seeker') as String,
      );
    }
    return UserProfile.fromMap(data);
  }
}
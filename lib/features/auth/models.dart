/// Appartenance de l'utilisateur à une organisation, telle que renvoyée par `GET /me`.
class Membership {
  const Membership({
    required this.organisationId,
    required this.slug,
    required this.name,
    required this.role,
    required this.roleLabel,
    required this.allFarms,
    required this.farmIds,
    required this.permissions,
  });

  factory Membership.fromJson(Map<String, dynamic> json) => Membership(
    organisationId: json['id'] as int,
    slug: json['slug'] as String,
    name: json['name'] as String,
    role: json['role'] as String? ?? '',
    roleLabel: json['role_label'] as String? ?? '',
    allFarms: json['all_farms'] as bool? ?? false,
    farmIds: (json['farm_ids'] as List<dynamic>? ?? const [])
        .map((id) => id as int)
        .toList(),
    permissions: (json['permissions'] as List<dynamic>? ?? const [])
        .map((p) => p as String)
        .toSet(),
  );

  final int organisationId;
  final String slug;
  final String name;
  final String role;
  final String roleLabel;
  final bool allFarms;
  final List<int> farmIds;
  final Set<String> permissions;

  bool can(String permission) => permissions.contains(permission);

  Map<String, dynamic> toJson() => {
    'id': organisationId,
    'slug': slug,
    'name': name,
    'role': role,
    'role_label': roleLabel,
    'all_farms': allFarms,
    'farm_ids': farmIds,
    'permissions': permissions.toList(),
  };
}

/// Utilisateur connecté et ses organisations.
class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.memberships,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'] as int,
    name: json['name'] as String,
    email: json['email'] as String,
    memberships: (json['organisations'] as List<dynamic>? ?? const [])
        .map((m) => Membership.fromJson(m as Map<String, dynamic>))
        .toList(),
  );

  final int id;
  final String name;
  final String email;
  final List<Membership> memberships;

  Membership? membershipFor(int organisationId) =>
      memberships.where((m) => m.organisationId == organisationId).firstOrNull;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'organisations': memberships.map((m) => m.toJson()).toList(),
  };
}

/// Ferme accessible, telle que renvoyée par `GET /organisations/{slug}/farms`.
class FarmSummary {
  const FarmSummary({required this.id, required this.code, required this.name});

  factory FarmSummary.fromJson(Map<String, dynamic> json) => FarmSummary(
    id: json['id'] as int,
    code: json['code'] as String? ?? '',
    name: json['name'] as String,
  );

  final int id;
  final String code;
  final String name;

  Map<String, dynamic> toJson() => {'id': id, 'code': code, 'name': name};
}

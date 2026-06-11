// lib/models/user_model.dart

enum UserRole { student, organizer }

extension UserRoleLabel on UserRole {
  String get label {
    switch (this) {
      case UserRole.student:
        return 'Student';
      case UserRole.organizer:
        return 'Organizer';
    }
  }

  String get description {
    switch (this) {
      case UserRole.student:
        return 'Discover opportunities, join clubs & RSVP to events';
      case UserRole.organizer:
        return 'Post events, manage communities & track RSVPs';
    }
  }

  String get icon {
    switch (this) {
      case UserRole.student:
        return 'S';
      case UserRole.organizer:
        return 'O';
    }
  }
}

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final UserRole role;
  final String? program;
  final String? classYear;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    this.program,
    this.classYear,
  });
}
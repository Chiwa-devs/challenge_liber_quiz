import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String name;
  final UserRole role;

  const User({
    required this.name,
    this.role = UserRole.candidate,
  });

  @override
  List<Object?> get props => [name, role];
}

enum UserRole {
  candidate,
  admin,
}

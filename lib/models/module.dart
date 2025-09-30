import 'package:equatable/equatable.dart';

class Module extends Equatable {
  final String id;
  final String name;
  final String description;
  final String icon;
  final int questionCount;

  const Module({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.questionCount,
  });

  @override
  List<Object?> get props => [id, name, description, icon, questionCount];
}

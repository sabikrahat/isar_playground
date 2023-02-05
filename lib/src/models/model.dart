import 'package:isar/isar.dart';

part 'model.g.dart';

@collection
class Teacher {
  Id? id;

  late String name;
  late String subject;
}

@collection
class Student {
  Id? id;

  late String name;

  final advisor = IsarLink<Teacher>();
}

@collection
class Department {
  Id? id;

  late String name;

  final teachers = IsarLinks<Teacher>();
  final students = IsarLinks<Student>();
}

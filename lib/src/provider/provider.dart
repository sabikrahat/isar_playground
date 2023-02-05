import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:isar_playground/src/models/model.dart';

import '../db/db.dart';


final teachersStreamPd = StreamProvider.autoDispose((_) => db.teachers.watchLazy());
final studentsStreamPd = StreamProvider.autoDispose((_) => db.students.watchLazy());
final departmentsStreamPd = StreamProvider.autoDispose((_) => db.departments.watchLazy());

final teachersPd = FutureProvider.autoDispose<List<Teacher>>((ref) async {
  ref.watch(teachersStreamPd);
  return await db.teachers.where().findAll();
});

final studentsFuturePd =FutureProvider.autoDispose<List<Student>>((ref) async {
  ref.watch(studentsStreamPd);
  return await db.students.where().findAll();
});

final departmentsFuturePd = FutureProvider.autoDispose<List<Department>>((ref) async {
  ref.watch(departmentsStreamPd);
  return await db.departments.where().findAll();
});



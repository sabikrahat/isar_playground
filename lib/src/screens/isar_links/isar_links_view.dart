import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_playground/src/provider/provider.dart';

import '../../configs/size_config.dart';
import '../../db/db.dart';
import '../../models/model.dart';
import '../../utils/themes/themes.dart';

class IsarLinksView extends ConsumerWidget {
  const IsarLinksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Isar Links')),
      body: ref.watch(departmentsFuturePd).when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Text(error.toString()),
            data: (data) => ListView.builder(
              itemCount: data.length,
              itemBuilder: (_, index) {
                final depart = data[index];
                final teachers = depart.teachers.map((e) => e).toList();
                final students = depart.students.map((e) => e).toList();
                // debugPrint('teachers: ${depart.teachers}');
                // debugPrint('students: ${depart.students}');
                return Card(
                  child: ExpansionTile(
                    leading: const Icon(Icons.school_outlined),
                    title: Text(depart.name),
                    trailing: const Icon(Icons.edit),
                    children: [
                      TextFormField(
                        initialValue: depart.name,
                        onChanged: (value) => depart.name = value,
                      ),
                      const SizedBox(height: 10),
                      const Text('Teachers:'),
                      ...List.generate(teachers.length, (index) {
                        final teacher = teachers[index];
                        return Column(
                          mainAxisSize: mainMin,
                          children: [
                            TextFormField(
                              initialValue: teacher.name,
                              onChanged: (value) => teacher.name = value,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              initialValue: teacher.subject,
                              onChanged: (value) => teacher.subject = value,
                            ),
                          ],
                        );
                      }),
                      const SizedBox(height: 10),
                      const Text('Students:'),
                      ...List.generate(students.length, (index) {
                        final student = students[index];
                        return Column(
                          mainAxisSize: mainMin,
                          children: [
                            TextFormField(
                              initialValue: student.name,
                              onChanged: (value) => student.name = value,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              initialValue: student.advisor.value?.name,
                              onChanged: (value) =>
                                  student.advisor.value?.name = value,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              initialValue: student.advisor.value?.subject,
                              onChanged: (value) =>
                                  student.advisor.value?.subject = value,
                            ),
                          ],
                        );
                      }),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: mainCenter,
                        children: [
                          ElevatedButton(
                            style: roundedButtonStyle,
                            onPressed: () async {
                              await db.writeTxn(() async {
                                await db.departments.delete(depart.id!);
                                await db.teachers.deleteAll(teachers.map((e) => e.id!).toList());
                                await db.students.deleteAll(students.map((e) => e.id!).toList());
                              });
                            },
                            child: const Text('Delete'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            style: roundedButtonStyle,
                            onPressed: () async {
                              await db.writeTxn(() async {
                                await db.departments.put(depart);
                                await db.teachers.putAll(teachers);
                                await db.students.putAll(students);
                              });
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                );
              },
            ),
          ),
      floatingActionButton: const ModifyWidgets(),
    );
  }
}

class ModifyWidgets extends StatelessWidget {
  const ModifyWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      tooltip: 'Add Department',
      onPressed: () async {
        final teacher1 = Teacher()
          ..name = '1 - Teacher ${DateTime.now().microsecondsSinceEpoch}'
          ..subject = '1 - Subject ${DateTime.now().microsecondsSinceEpoch}';

        final teacher2 = Teacher()
          ..name = '2 - Teacher ${DateTime.now().microsecondsSinceEpoch}'
          ..subject = '2 - Subject ${DateTime.now().microsecondsSinceEpoch}';

        final student1 = Student()
          ..name = '1 - Student ${DateTime.now().microsecondsSinceEpoch}'
          ..advisor.value = teacher1;

        final student2 = Student()
          ..name = '2 - Student ${DateTime.now().microsecondsSinceEpoch}'
          ..advisor.value = teacher2;

        await db.writeTxn(() async {
          await db.teachers.put(teacher1);
          await db.students.put(student1);
          await student1.advisor.save();

          await db.teachers.put(teacher2);
          await db.students.put(student2);
          await student2.advisor.save();

          final department = Department()
            ..name = 'Department ${DateTime.now().microsecondsSinceEpoch}'
            ..teachers.addAll([teacher1, teacher2])
            ..students.addAll([student1, student2]);

          await db.departments.put(department);

          await department.teachers.save();
          await department.students.save();
        });
      },
      child: const Icon(Icons.local_fire_department),
    );
  }
}

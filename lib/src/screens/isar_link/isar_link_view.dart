import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_playground/src/models/model.dart';
import 'package:isar_playground/src/provider/provider.dart';

import '../../configs/size_config.dart';
import '../../db/db.dart';
import '../../utils/themes/themes.dart';

class IsarLinkView extends ConsumerWidget {
  const IsarLinkView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Isar Link')),
      body: ref.watch(studentsFuturePd).when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Text(error.toString()),
            data: (data) => ListView.builder(
              itemCount: data.length,
              itemBuilder: (_, index) {
                final student = data[index];
                final teacher = student.advisor.value;
                return Card(
                  child: ExpansionTile(
                    leading: const Icon(Icons.school_outlined),
                    title: Text(student.name),
                    subtitle: Column(
                      mainAxisSize: mainMin,
                      crossAxisAlignment: crossStart,
                      children: [
                        Text(teacher?.name ?? 'Not Found'),
                        Text(teacher?.subject ?? 'Not Found'),
                      ],
                    ),
                    trailing: const Icon(Icons.edit),
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
                      Row(
                        mainAxisAlignment: mainCenter,
                        children: [
                          ElevatedButton(
                            style: roundedButtonStyle,
                            onPressed: () async {
                              await db.writeTxn(() async {
                                await db.students.delete(student.id!);
                                await db.teachers.delete(teacher!.id!);
                              });
                            },
                            child: const Text('Delete'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            style: roundedButtonStyle,
                            onPressed: () async {
                              await db.writeTxn(() async {
                                await db.teachers.put(teacher!);
                                await db.students.put(student);
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
      tooltip: 'Add Student',
      onPressed: () async {
        final teacher = Teacher()
          ..name = 'Teacher ${DateTime.now().microsecondsSinceEpoch}'
          ..subject = 'Subject ${DateTime.now().microsecondsSinceEpoch}';

        final student = Student()
          ..name = 'Student ${DateTime.now().microsecondsSinceEpoch}'
          ..advisor.value = teacher;

        await db.writeTxn(() async {
          await db.students.put(student);
          await db.teachers.put(teacher);
          await student.advisor.save();
        });
      },
      child: const Icon(Icons.school_outlined),
    );
  }
}

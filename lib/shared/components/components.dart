import 'package:flutter/material.dart';
import 'package:todo/shared/cubit/cubit.dart';

///TextFormField Component
Widget defaultTextFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String? Function(String?)? validate,
  required String label,
  required IconData icon,
  Function()? onTap,
  bool readOnly = false,
}) =>
    TextFormField(
      readOnly: readOnly,
      validator: validate,
      controller: controller,
      keyboardType: type,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
    );

Widget buildTaskItem({
  required Map model,
  required BuildContext context,
  Function()? onDonePressed,
  Function()? onArchivedPressed,
  IconData? doneIcon,
  IconData? archiveIcon,
}) {
  return Dismissible(
    key: Key(model['id'].toString()),
    onDismissed: (direction) {
      AppCubit.get(context).deleteDatabase(id: model['id']);
    },
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 38.0,
            child: Text(
              "${model['time']}",
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${model['title']}",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "${model['date']}",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
          IconButton(
              onPressed: onDonePressed,
              icon: Icon(
                doneIcon,
                color: Colors.green,
              )),
          IconButton(
              onPressed: onArchivedPressed,
              icon: Icon(
                archiveIcon,
                color: Colors.black45,
              )),
        ],
      ),
    ),
  );
}

Widget taskBuilder({required List<Map> tasks, required String status}) {
  if (tasks.length > 0) {
    return ListView.separated(
        itemBuilder: (context, index) {
          if (status == "Done") {
            return buildTaskItem(model: tasks[index], context: context);
          } else if (status == "Archived") {
            return buildTaskItem(
              model: tasks[index],
              context: context,
              onDonePressed: () {
                AppCubit.get(context)
                    .updateDatabase(status: 'done', id: tasks[index]['id']);
              },
              doneIcon: Icons.check_circle_outline,
            );
          } else {
            return buildTaskItem(
              model: tasks[index],
              context: context,
              onDonePressed: () {
                AppCubit.get(context)
                    .updateDatabase(status: 'done', id: tasks[index]['id']);
              },
              doneIcon: Icons.check_circle_outline,
              onArchivedPressed: () {
                AppCubit.get(context)
                    .updateDatabase(status: 'archive', id: tasks[index]['id']);
              },
              archiveIcon: Icons.archive_outlined,
            );
          }
        },
        separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 10.0,
              ),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
            ),
        itemCount: tasks.length);
  } else {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu,
            size: 100.0,
            color: Colors.grey,
          ),
          Text(
            "No Tasks Yet ! , Please Add Some Tasks",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

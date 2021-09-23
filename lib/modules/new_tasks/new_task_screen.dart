
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class NewTasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit,AppStates>(
      listener: (BuildContext context, Object? state) {  },
      builder: (BuildContext context, state) {

        List<Map> tasks=AppCubit.get(context).newTasks;
        return taskBuilder(tasks:tasks,status: "New");
      },
    );
  }
}

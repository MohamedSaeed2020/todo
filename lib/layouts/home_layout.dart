import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/components/components.dart';
import 'package:intl/intl.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  //init variables
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

//bloc state management pattern
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, Object? state) {
          //check if you insert to database close the bottom sheet
          if (state is InsertToDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, state) {
          //get instance of AppCubit (BloC) class
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            body: (state is! GetDatabaseLoadingState)
                ? cubit.screens[cubit.currentIndex]
                : CircularProgressIndicator(),

            ///floatingActionButton
            floatingActionButton: FloatingActionButton(
              onPressed: () {

                //if it is opened
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                      title: titleController.text,
                      date: dateController.text,
                      time: timeController.text,
                    );
                    titleController.clear();
                    timeController.clear();
                    dateController.clear();
                    cubit.changeBottomSheetState(
                        isShow: false, icon: Icons.edit);
                  }
                } else {
                  //if it is closed
                  scaffoldKey.currentState
                      ?.showBottomSheet(
                        (context) => Container(
                          padding: EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ///Task Title
                                defaultTextFormField(
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return "Please Enter The Title Of The Task";
                                    }
                                  },
                                  controller: titleController,
                                  type: TextInputType.text,
                                  label: "Task Title",
                                  icon: Icons.title,
                                ),
                                const SizedBox(height: 20.0),

                                ///Task Time
                                defaultTextFormField(
                                  readOnly: true,
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return "Please Enter The Time Of The Task";
                                    }
                                  },
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      print(value);
                                      if (value != null) {
                                        timeController.text =
                                            value.format(context);
                                      } else {
                                        timeController.text =
                                            "${DateTime.now().hour}:${DateTime.now().minute}";
                                      }
                                    });
                                  },
                                  controller: timeController,
                                  type: TextInputType.datetime,
                                  label: "Task Time",
                                  icon: Icons.watch_later_outlined,
                                ),
                                const SizedBox(height: 20.0),

                                ///Task Date
                                defaultTextFormField(
                                  readOnly: true,
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return "Please Enter The Date Of The Task";
                                    }
                                  },
                                  onTap: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse("2021-09-14"))
                                        .then((value) {
                                      if (value != null) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value);
                                      } else {
                                        dateController.text = DateFormat.yMMMd()
                                            .format(DateTime.now());
                                      }
                                    });
                                  },
                                  controller: dateController,
                                  type: TextInputType.datetime,
                                  label: "Task Date",
                                  icon: Icons.calendar_today,
                                ),
                              ],
                            ),
                          ),
                        ),
                        elevation: 20.0,
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                        isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(
                cubit.fabIcon,
              ),
            ),
            ///bottomNavigationBar
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: "Tasks",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: "Done",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: "Archived",
                ),
              ],
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
            ),
          );
        },
      ),
    );
  }
}

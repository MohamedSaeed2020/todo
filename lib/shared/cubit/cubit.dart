import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/archived_tasks/archived_task_screen.dart';
import 'package:todo/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo/modules/new_tasks/new_task_screen.dart';
import 'package:todo/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {

  //get initial state
  AppCubit() : super(AppInitialState());

  //get instance of AppCubit class
  static AppCubit get(context) => BlocProvider.of(context);

  //class variables
  int currentIndex = 0;
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> titles = ["New Tasks", "Done Tasks", "Archived Tasks"];
  Database? database;

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  //class methods
  ///change currentIndex state
  void changeIndex(int index) {
    currentIndex = index;
    emit(ChangeBottomNavBarState());
  }

  ///change changeBottomSheetState closed or opened
  void changeBottomSheetState({required bool isShow, required IconData icon}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(ChangeBottomSheetState());
  }

  ///create database and show the saved tasks
  //if database isn't created create it and open, else just open it
  void createDatabase() {
    openDatabase(
      "todo.db",
      version: 1,
      onCreate: (database, version) {
        print("Database hase been created successfully!");

        ///create table
        database
            .execute(
                "CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)")
            .then((value) {
          print("Table hase been created successfully!");
        }).catchError((error) {
          print("Error hase been occurred ${error.toString()}");
        });
      },
      onOpen: (database) async {
        print("Database hase been opened successfully!");
        getDataFromDatabase(database);
      },
    ).then((value) {
      database = value;
      emit(CreateDatabaseState());
    });
  }

  ///get tasks from database
  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    //loading until data is returned
    emit(GetDatabaseLoadingState());
    database!.rawQuery('SELECT * FROM tasks').then((value) {
      if (value.isNotEmpty) {
        print("Database hase been returned successfully! $value");
        value.forEach((element) {
          if (element['status'] == 'new') {
            newTasks.add(element);
          } else if (element['status'] == 'done') {
            doneTasks.add(element);
          } else {
            archivedTasks.add(element);
          }
        });
      }
      emit(GetDataFromDatabaseState());
    });
  }

  ///insert new task (Database)
  void insertToDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    await database?.transaction((txn) async {
      txn
          .rawInsert(
        'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")',
      )
          .then((value) {
        print("Database hase been inserted successfully! $value");
        emit(InsertToDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print("Error hase been occurred ${error.toString()}");
      });
    });
  }

  ///update status of the task (Database)
  void updateDatabase({required String status, required int id}) {
    database!.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getDataFromDatabase(database);
      emit(UpdateDatabaseState());
      print("Database hase been updated successfully! $value");
    });
  }

  ///delete task (Database)
  void deleteDatabase({required int id}) {
    database!.rawDelete('DELETE from tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(DeleteDatabaseState());
      print("Task hase been deleted successfully! $value");
    });
  }


}

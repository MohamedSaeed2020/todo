import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo/layouts/home_layout.dart';
import 'package:todo/shared/bloc_observer.dart';

void main() {
  //to observe the states of the app.
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //to hide debugCheckedModeBanner
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
}

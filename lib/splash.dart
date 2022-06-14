import 'dart:async';
import 'dart:math';
import 'package:sqflite/sqflite.dart';
import 'package:todolist/Page/mainPage.dart';
import 'package:flutter/material.dart';
import 'package:todolist/main.dart';

class Splash extends StatefulWidget {
  // const Splash({Key? key}) : super(key: key);

  final Future<Database> db;
  Splash(this.db);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation? _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 5));
    _animation = Tween<double>(begin: 0, end: pi*2).animate(_animationController!);
    _animationController!.repeat();
    loadData();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  Future<Timer> loadData() async{
    return Timer(Duration(seconds: 2), onDoneLoading);
  }

  onDoneLoading() async {
    Navigator.pushReplacementNamed(context, '/mainPage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('splash'),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              AnimatedBuilder(
                  animation: _animationController!,
                  builder: (context, widget) {
                    return Transform.rotate(
                      angle: _animation!.value,
                      child: widget,
                    );
                  },
                child: Icon(
                  Icons.today_outlined,
                  color: Colors.blueAccent,
                  size: 80,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ),
    );
  }
}


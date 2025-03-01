import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Fullscreen Clock',
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.black,
      fontFamily: '7-Segment',
    ),
    home: const MyHomePage(),
    debugShowCheckedModeBanner: false,
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String _date;
  late String _time;
  Duration _durationTime = const Duration();
  Duration _durationDate = const Duration();

  void _curTime() {
    setState(() {
      _date = DateFormat('yyyy-MM-dd').format(DateTime.now().add(_durationDate));
      _time = DateFormat('hh:mm:ss').format(DateTime.now().add(_durationTime));
    });
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _curTime();
    Timer.periodic(const Duration(seconds: 1), (timer) => _curTime());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            showDateText(),
            showTimeText(),
          ],
        ),
      ),
    );
  }

  Widget showDateText() => GestureDetector(
    onTap: () => _onTapDate(context),
    child: SizedBox(
      width: MediaQuery.of(context).size.width * 0.3,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Stack(
          children: [
            const Text('8888-88-88', style: TextStyle(color: Colors.white10)),
            Text(_date, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    ),
  );

  void _onTapDate(BuildContext context) async {
    // Future<DateTime?> future = showDatePicker(
    DateTime? d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2200),
      builder: (BuildContext context, Widget? child) => Theme(
        data: ThemeData.dark(),
        child: child!,
      ),
    );

    // future.then((d) {
    if (d != null) {
      DateTime e = DateTime.now();
      DateTime b = DateTime(d.year, d.month, d.day);
      _durationDate = b.difference(e);
      _curTime();
    }
    // });
  }

  Widget showTimeText() => GestureDetector(
    onTap: () => _onTapTime(context),
    child: SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.width * 0.3,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Stack(
          children: [
            const Text('88:88:88', style: TextStyle(color: Colors.white10)),
            Text(_time, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    ),
  );

  void _onTapTime(BuildContext context) async {
    // Future<TimeOfDay?> future = await showTimePicker(
    TimeOfDay? t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) => Theme(
        data: ThemeData.dark(),
        child: child!,
      ),
    );

    //future.then((t) {
    if (t != null) {
      DateTime e = DateTime.now();
      DateTime b = DateTime(e.year, e.month, e.day, t.hour, t.minute, e.second);
      _durationTime = b.difference(e);
      _curTime();
    }
    //});
  }
}

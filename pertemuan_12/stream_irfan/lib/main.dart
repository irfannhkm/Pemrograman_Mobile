import 'package:flutter/material.dart';
import 'stream_irfan.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stream - Irfan | 2241720230',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const StreamHomePage(),
    );
  }
}

class StreamHomePage extends StatefulWidget {
  const StreamHomePage({super.key});

  @override
  State<StreamHomePage> createState() => _StreamHomePageState();
}

class _StreamHomePageState extends State<StreamHomePage> {
  late StreamSubscription subscription;
  late StreamSubscription subscription2;

  String values = '';
  late StreamTransformer transformer;

  Color bgColor = Colors.blueGrey;
  late ColorStream colorStream;

  int lastNumber = 0;
  late StreamController numberStreamController;
  late NumberStream numberStream;

  @override
  void initState() {
    numberStream = NumberStream();
    numberStreamController = numberStream.controller;
    Stream stream = numberStreamController.stream.asBroadcastStream();
    subscription = stream.listen((event) {
      setState(() {
        values += '$event - ';
      });
    });
    subscription2 = stream.listen((event) {
      setState(() {
        values += '$event - ';
      });
    });
    subscription.onError((error) {
      setState(() {
        lastNumber = -1;
      });
    });
    subscription.onDone(() {
      print('OnDone was called');
    });
    super.initState();
  }
  // void initState() {
  //   transformer = StreamTransformer<int, int>.fromHandlers(
  //     handleData: (value, sink) {
  //       sink.add(value * 10);
  //     },
  //     handleError: (error, stackTrace, sink) {
  //       sink.add(-1);
  //     },
  //     handleDone: (sink) => sink.close(),
  //   );

  //   numberStream = NumberStream();
  //   numberStreamController = numberStream.controller;
  //   Stream stream = numberStreamController.stream;

  //   stream.transform(transformer).listen((event) {
  //     setState(() {
  //       lastNumber = event;
  //     });
  //   }).onError((error) {
  //     setState(() {
  //       lastNumber = -1;
  //     });
  //   });
  //   super.initState();
  // }

  @override
  void dispose() {
    numberStreamController.close();
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Stream - Irfan | 2241720230'),
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(values),
              ElevatedButton(
                  onPressed: () => addRandomNumber(),
                  child: const Text('New Random Number')),
              ElevatedButton(
                  onPressed: () => stopStream(),
                  child: const Text('Stop Subscription')),
            ],
          ),
        ));
  }

  void addRandomNumber() {
    Random random = Random();
    int myNum = random.nextInt(10);
    if (!numberStreamController.isClosed) {
      numberStream.addNumberToSink(myNum);
    } else {
      setState(() {
        lastNumber = -1;
      });
    }
  }

  void changeColor() async {
    ColorStream colorStream = ColorStream();
    colorStream.getColors().listen((Color color) {
      setState(() {
        bgColor = color;
      });
    });
  }

  void stopStream() {
    numberStreamController.close();
  }
}

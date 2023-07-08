import 'dart:isolate';

Future<void> main() async {
  int counter = 0;

  ReceivePort receivePort = ReceivePort();

  DateTime now = DateTime.now();

  Isolate.run(
    () => task3(),
  ).asStream().listen((event) {
    print(event);
  });

  Isolate.run(
    () => task4(),
  ).asStream().listen((event) {
    print(event);
  }).onDone(() {
    print(DateTime.now().difference(now).inMilliseconds);
    return;
  });

  Isolate.spawn(
    task1,
    receivePort.sendPort,
  );

  Isolate isolate = await Isolate.spawn(
    task2,
    receivePort.sendPort,
  );

  receivePort.listen((message) {
    print(message);
    counter++;

    if (counter == 2) {
      receivePort.close();
    }
  }).onDone(() {
    print(DateTime.now().difference(now).inMilliseconds);
    isolate.kill(
      priority: Isolate.immediate,
    );
  });
}

void task1(SendPort sendPort) async {
  await Future.delayed(
    const Duration(milliseconds: 400),
  );

  sendPort.send("Task 1 Done");
}

void task2(SendPort sendPort) async {
  await Future.delayed(
    const Duration(milliseconds: 600),
  );

  sendPort.send("Task 2 Done");
}

Future<String> task3() async {
  await Future.delayed(
    const Duration(milliseconds: 400),
  );

  return "Task 3 Done";
}

Future<String> task4() async {
  await Future.delayed(
    const Duration(milliseconds: 600),
  );

  return "Task 4 Done";
}

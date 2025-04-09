import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'tarefa.dart';
import 'home_page.dart';
import 'controllers/tema_controller.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TarefaAdapter());
  await Hive.openBox<Tarefa>('tarefas');

  // Inicialização de notificações
  const AndroidInitializationSettings androidInit =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initSettings =
  InitializationSettings(android: androidInit);

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  runApp(ValueListenableBuilder(
    valueListenable: temaController,
    builder: (context, ThemeMode mode, _) {
      return MaterialApp(
        title: 'Lista de Tarefas',
        themeMode: mode,
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(useMaterial3: true),
        darkTheme: ThemeData.dark(useMaterial3: true),
        home: const HomePage(),
      );
    },
  ));
}

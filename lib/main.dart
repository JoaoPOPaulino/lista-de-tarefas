import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'controllers/tema_controller.dart';
import 'controllers/tarefa_controller.dart';
import 'models/tarefa_model.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TarefaAdapter());
  final box = await Hive.openBox<Tarefa>('tarefas_box');

  // Adiciona tarefas exemplo se a box estiver vazia
  if (box.isEmpty) {
    await _adicionarTarefasExemplo(box);
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TemaController()),
        ChangeNotifierProvider(create: (_) => TarefaController()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> _adicionarTarefasExemplo(Box<Tarefa> box) async {
  final tarefasExemplo = [
    Tarefa(
      titulo: 'Reunião com a equipe',
      observacao: 'Discutir o novo projeto',
      data: DateTime.now().add(const Duration(days: 1)),
      tipo: 'Trabalho',
    ),
    Tarefa(
      titulo: 'Estudar Flutter',
      observacao: 'Aprender sobre gerenciamento de estado',
      data: DateTime.now().add(const Duration(days: 2)),
      tipo: 'Estudos',
    ),
    Tarefa(
      titulo: 'Ir à academia',
      observacao: 'Treino de pernas',
      data: DateTime.now(),
      tipo: 'Saúde',
    ),
    Tarefa(
      titulo: 'Cinema com amigos',
      observacao: 'Assistir o novo filme',
      data: DateTime.now().add(const Duration(days: 3)),
      tipo: 'Lazer',
    ),
    Tarefa(
      titulo: 'Fazer compras',
      observacao: 'Mercado e farmácia',
      data: DateTime.now().add(const Duration(days: 1)),
      tipo: 'Geral',
    ),
  ];

  await box.addAll(tarefasExemplo);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final temaController = Provider.of<TemaController>(context);

    return MaterialApp(
      title: 'Gerenciador de Tarefas',
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: temaController.temaAtual,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
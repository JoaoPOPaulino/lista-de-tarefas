import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'tarefa.dart';
import 'controllers/tema_controller.dart';
import 'formulario_tarefa.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Box<Tarefa> box = Hive.box<Tarefa>('tarefas');

  @override
  void initState() {
    super.initState();
    _inserirTarefasExemplo();
  }

  void _inserirTarefasExemplo() {
    if (box.isEmpty) {
      final exemplos = [
        Tarefa(
          titulo: 'Reunião com equipe',
          data: DateTime.now().add(const Duration(days: 1)),
          observacao: 'Discutir prazos e metas',
          categoria: 'Trabalho',
        ),
        Tarefa(
          titulo: 'Estudar Flutter',
          data: DateTime.now().add(const Duration(days: 2)),
          observacao: 'Praticar layout e navegação',
          categoria: 'Estudos',
        ),
        Tarefa(
          titulo: 'Fazer compras',
          data: DateTime.now(),
          observacao: 'Leite, pão, ovos...',
          categoria: 'Pessoal',
        ),
        Tarefa(
          titulo: 'Caminhada no parque',
          data: DateTime.now().add(const Duration(days: 3)),
          observacao: 'Exercício leve de manhã',
          categoria: 'Saúde',
        ),
        Tarefa(
          titulo: 'Assistir série',
          data: DateTime.now().add(const Duration(days: 4)),
          observacao: 'Novo episódio disponível',
          categoria: 'Lazer',
        ),
        Tarefa(
          titulo: 'Atualizar currículo',
          data: DateTime.now().add(const Duration(days: 5)),
          observacao: 'Adicionar nova experiência',
          categoria: 'Trabalho',
        ),
      ];

      for (var tarefa in exemplos) {
        box.add(tarefa);
      }
    }
  }

  IconData _iconeCategoria(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'trabalho':
        return Icons.work;
      case 'estudos':
        return Icons.menu_book;
      case 'pessoal':
        return Icons.person;
      case 'saúde':
        return Icons.favorite;
      case 'lazer':
        return Icons.sports_esports;
      default:
        return Icons.label;
    }
  }

  Color _corCategoria(String categoria, BuildContext context) {
    final theme = Theme.of(context);
    switch (categoria.toLowerCase()) {
      case 'trabalho':
        return theme.colorScheme.primary;
      case 'estudos':
        return Colors.deepPurple;
      case 'pessoal':
        return Colors.teal;
      case 'saúde':
        return Colors.pinkAccent;
      case 'lazer':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _editarTarefa(Tarefa tarefa) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: FormularioTarefa(tarefa: tarefa),
      ),
    );
  }

  void _mostrarNotificacao(String titulo, String corpo) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'canal_tarefa',
      'Tarefas',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificacaoDetails =
    NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      titulo,
      corpo,
      notificacaoDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              temaController.value == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () => temaController.alternarTema(),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Tarefa> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('Nenhuma tarefa adicionada.'));
          }

          final tarefas = box.values.toList();

          return ListView.builder(
            itemCount: tarefas.length,
            itemBuilder: (context, index) {
              final tarefa = tarefas[index];
              return Card(
                child: ListTile(
                  leading: Icon(
                    _iconeCategoria(tarefa.categoria),
                    color: tarefa.concluida ? Colors.grey : null,
                  ),
                  title: Text(
                    tarefa.titulo,
                    style: TextStyle(
                      decoration: tarefa.concluida
                          ? TextDecoration.lineThrough
                          : null,
                      color: tarefa.concluida ? Colors.grey : null,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      Chip(
                        label: Text(tarefa.categoria),
                        backgroundColor: _corCategoria(tarefa.categoria, context)
                            .withOpacity(0.2),
                        labelStyle: TextStyle(
                          color: _corCategoria(tarefa.categoria, context),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                          '${tarefa.data.day}/${tarefa.data.month}/${tarefa.data.year}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit,
                            color: Theme.of(context).colorScheme.primary),
                        onPressed: () => _editarTarefa(tarefa),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete,
                            color: Theme.of(context).colorScheme.error),
                        onPressed: () {
                          tarefa.delete();
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      tarefa.concluida = !tarefa.concluida;
                      tarefa.save();
                      if (tarefa.concluida) {
                        _mostrarNotificacao("Tarefa Concluída", tarefa.titulo);
                      }
                    });
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => Dialog(
              child: FormularioTarefa(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

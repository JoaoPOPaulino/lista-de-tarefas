import 'package:hive/hive.dart';

part 'tarefa.g.dart';

@HiveType(typeId: 0)
class Tarefa extends HiveObject {
  @HiveField(0)
  String titulo;

  @HiveField(1)
  DateTime data;

  @HiveField(2)
  String observacao;

  @HiveField(3)
  String categoria;

  @HiveField(4)
  bool concluida;

  Tarefa({
    required this.titulo,
    required this.data,
    this.observacao = '',
    this.categoria = 'Geral',
    this.concluida = false,
  });
}

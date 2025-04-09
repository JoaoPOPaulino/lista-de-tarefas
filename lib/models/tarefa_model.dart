import 'package:hive/hive.dart';

part 'tarefa_model.g.dart';

@HiveType(typeId: 0)
class Tarefa extends HiveObject {
  @HiveField(0)
  String titulo;

  @HiveField(1)
  String observacao;

  @HiveField(2)
  DateTime data;

  @HiveField(3)
  String tipo;

  @HiveField(4)
  bool concluida;

  Tarefa({
    required this.titulo,
    required this.observacao,
    required this.data,
    required this.tipo,
    this.concluida = false,
  });

  // Método para copiar uma tarefa
  Tarefa copyWith({
    String? titulo,
    String? observacao,
    DateTime? data,
    String? tipo,
    bool? concluida,
  }) {
    return Tarefa(
      titulo: titulo ?? this.titulo,
      observacao: observacao ?? this.observacao,
      data: data ?? this.data,
      tipo: tipo ?? this.tipo,
      concluida: concluida ?? this.concluida,
    );
  }
}
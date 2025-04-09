import 'package:flutter/material.dart';
import '../models/tarefa_model.dart';

class TarefaItem extends StatelessWidget {
  final Tarefa tarefa;
  final ValueChanged<bool?>? onConcluidaChanged;
  final VoidCallback? onEditar;
  final VoidCallback? onRemover;

  const TarefaItem({
    super.key,
    required this.tarefa,
    this.onConcluidaChanged,
    this.onEditar,
    this.onRemover,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    IconData _obterIconePorTipo() {
      switch (tarefa.tipo) {
        case 'Trabalho':
          return Icons.work;
        case 'Estudos':
          return Icons.school;
        case 'Lazer':
          return Icons.sports_esports;
        case 'Saúde':
          return Icons.health_and_safety;
        case 'Família':
          return Icons.family_restroom;
        default:
          return Icons.task;
      }
    }

    Color _obterCorPorTipo() {
      switch (tarefa.tipo) {
        case 'Trabalho':
          return Colors.blue;
        case 'Estudos':
          return Colors.purple;
        case 'Lazer':
          return Colors.green;
        case 'Saúde':
          return Colors.red;
        case 'Família':
          return Colors.orange;
        default:
          return Colors.grey;
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _obterCorPorTipo().withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _obterIconePorTipo(),
            color: _obterCorPorTipo(),
          ),
        ),
        title: Text(
          tarefa.titulo,
          style: TextStyle(
            decoration:
            tarefa.concluida ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tarefa.observacao),
            const SizedBox(height: 4),
            Text(
              '${tarefa.data.day}/${tarefa.data.month}/${tarefa.data.year}',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: tarefa.concluida,
              onChanged: onConcluidaChanged,
            ),
            IconButton(
              icon: Icon(Icons.edit, color: theme.colorScheme.secondary),
              onPressed: onEditar,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: theme.colorScheme.error),
              onPressed: onRemover,
            ),
          ],
        ),
      ),
    );
  }
}
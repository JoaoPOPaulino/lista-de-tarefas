import 'package:flutter/material.dart';

class FiltroWidget extends StatelessWidget {
  final ValueChanged<String> onTipoChanged;
  final VoidCallback onOrdenacaoChanged;

  const FiltroWidget({
    super.key,
    required this.onTipoChanged,
    required this.onOrdenacaoChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: 'Todos',
              items: const [
                DropdownMenuItem(value: 'Todos', child: Text('Todos os tipos')),
                DropdownMenuItem(value: 'Geral', child: Text('Geral')),
                DropdownMenuItem(value: 'Trabalho', child: Text('Trabalho')),
                DropdownMenuItem(value: 'Estudos', child: Text('Estudos')),
                DropdownMenuItem(value: 'Lazer', child: Text('Lazer')),
                DropdownMenuItem(value: 'Saúde', child: Text('Saúde')),
                DropdownMenuItem(value: 'Família', child: Text('Família')),
              ],
              onChanged: (value) => onTipoChanged(value!),
              decoration: const InputDecoration(
                labelText: 'Filtrar por tipo',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: onOrdenacaoChanged,
            tooltip: 'Alternar ordenação',
          ),
        ],
      ),
    );
  }
}
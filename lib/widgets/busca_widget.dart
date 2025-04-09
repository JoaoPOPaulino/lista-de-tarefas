import 'package:flutter/material.dart';

class BuscaWidget extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const BuscaWidget({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: 'Buscar tarefas',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
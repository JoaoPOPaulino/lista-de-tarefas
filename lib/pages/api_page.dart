import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiPage extends StatefulWidget {
  const ApiPage({super.key});

  @override
  State<ApiPage> createState() => _ApiPageState();
}

class _ApiPageState extends State<ApiPage> {
  List<dynamic> _tarefas = [];
  bool _carregando = true;
  String _erro = '';

  @override
  void initState() {
    super.initState();
    _carregarTarefas();
  }

  Future<void> _carregarTarefas() async {
    setState(() {
      _carregando = true;
      _erro = '';
    });

    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/todos'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _tarefas = json.decode(response.body);
          _carregando = false;
        });
      } else {
        setState(() {
          _erro = 'Erro ao carregar tarefas: ${response.statusCode}';
          _carregando = false;
        });
      }
    } catch (e) {
      setState(() {
        _erro = 'Erro de conexão: $e';
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas da API'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarTarefas,
          ),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _erro.isNotEmpty
          ? Center(child: Text(_erro))
          : _tarefas.isEmpty
          ? const Center(child: Text('Nenhuma tarefa encontrada'))
          : RefreshIndicator(
        onRefresh: _carregarTarefas,
        child: ListView.builder(
          itemCount: _tarefas.length,
          itemBuilder: (context, index) {
            final tarefa = _tarefas[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading: Icon(
                  tarefa['completed']
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: tarefa['completed']
                      ? Colors.green
                      : Colors.grey,
                ),
                title: Text(tarefa['title']),
                subtitle: Text('ID: ${tarefa['id']}'),
              ),
            );
          },
        ),
      ),
    );
  }
}
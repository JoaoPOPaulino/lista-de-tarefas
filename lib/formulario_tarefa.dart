import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'tarefa.dart';

class FormularioTarefa extends StatefulWidget {
  final Tarefa? tarefa;

  const FormularioTarefa({super.key, this.tarefa});

  @override
  State<FormularioTarefa> createState() => _FormularioTarefaState();
}

class _FormularioTarefaState extends State<FormularioTarefa> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _observacaoController;
  DateTime _dataSelecionada = DateTime.now();
  String _categoriaSelecionada = 'Geral';

  final categorias = ['Geral', 'Trabalho', 'Estudos', 'Pessoal', 'Saúde', 'Lazer'];

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.tarefa?.titulo ?? '');
    _observacaoController = TextEditingController(text: widget.tarefa?.observacao ?? '');
    _dataSelecionada = widget.tarefa?.data ?? DateTime.now();
    _categoriaSelecionada = widget.tarefa?.categoria ?? 'Geral';
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _observacaoController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      final box = Hive.box<Tarefa>('tarefas');

      if (widget.tarefa != null) {
        widget.tarefa!
          ..titulo = _tituloController.text
          ..observacao = _observacaoController.text
          ..data = _dataSelecionada
          ..categoria = _categoriaSelecionada
          ..save();
      } else {
        final nova = Tarefa(
          titulo: _tituloController.text,
          data: _dataSelecionada,
          observacao: _observacaoController.text,
          categoria: _categoriaSelecionada,
        );
        box.add(nova);
      }

      Navigator.of(context).pop();
    }
  }

  void _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (data != null) {
      setState(() {
        _dataSelecionada = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) => value == null || value.isEmpty ? 'Digite um título' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _observacaoController,
                decoration: const InputDecoration(labelText: 'Observações'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _categoriaSelecionada,
                items: categorias.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _categoriaSelecionada = value;
                    });
                  }
                },
                decoration: const InputDecoration(labelText: 'Categoria'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Data: ${_dataSelecionada.day}/${_dataSelecionada.month}/${_dataSelecionada.year}',
                    ),
                  ),
                  TextButton(
                    onPressed: _selecionarData,
                    child: const Text('Selecionar Data'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _salvar,
                icon: const Icon(Icons.save),
                label: Text(widget.tarefa != null ? 'Salvar Alterações' : 'Adicionar Tarefa'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

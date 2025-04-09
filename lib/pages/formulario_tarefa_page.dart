import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/tarefa_controller.dart';
import '../models/tarefa_model.dart';

class FormularioTarefaPage extends StatefulWidget {
  final Tarefa? tarefa;
  final int? index;

  const FormularioTarefaPage({super.key, this.tarefa, this.index});

  @override
  State<FormularioTarefaPage> createState() => _FormularioTarefaPageState();
}

class _FormularioTarefaPageState extends State<FormularioTarefaPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _observacaoController;
  late DateTime _dataSelecionada;
  late String _tipoSelecionado;

  final List<String> tipos = [
    'Geral',
    'Trabalho',
    'Estudos',
    'Lazer',
    'Saúde',
    'Família'
  ];

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.tarefa?.titulo ?? '');
    _observacaoController = TextEditingController(text: widget.tarefa?.observacao ?? '');
    _dataSelecionada = widget.tarefa?.data ?? DateTime.now();
    _tipoSelecionado = widget.tarefa?.tipo ?? 'Geral';
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _observacaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tarefaController = Provider.of<TarefaController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tarefa == null ? 'Nova Tarefa' : 'Editar Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _tituloController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um título';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _observacaoController,
                  decoration: const InputDecoration(
                    labelText: 'Observação',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _tipoSelecionado,
                  items: tipos.map((String tipo) {
                    return DropdownMenuItem<String>(
                      value: tipo,
                      child: Text(tipo),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _tipoSelecionado = newValue!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Tarefa',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _selecionarData,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Data',
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_dataSelecionada.day}/${_dataSelecionada.month}/${_dataSelecionada.year}',
                        ),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _salvarTarefa(tarefaController),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      widget.tarefa == null ? 'Adicionar Tarefa' : 'Salvar Alterações',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selecionarData() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _dataSelecionada) {
      setState(() {
        _dataSelecionada = picked;
      });
    }
  }

  void _salvarTarefa(TarefaController controller) {
    if (_formKey.currentState!.validate()) {
      final novaTarefa = Tarefa(
        titulo: _tituloController.text,
        observacao: _observacaoController.text,
        data: _dataSelecionada,
        tipo: _tipoSelecionado,
        concluida: widget.tarefa?.concluida ?? false,
      );

      if (widget.tarefa == null) {
        controller.adicionarTarefa(novaTarefa);
      } else {
        controller.atualizarTarefa(widget.index!, novaTarefa);
      }

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.tarefa == null
              ? 'Tarefa adicionada com sucesso!'
              : 'Tarefa atualizada com sucesso!'),
        ),
      );
    }
  }
}
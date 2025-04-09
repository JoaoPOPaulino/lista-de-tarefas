import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/tarefa_controller.dart';
import '../controllers/tema_controller.dart';
import '../widgets/busca_widget.dart';
import '../widgets/filtro_widget.dart';
import '../widgets/tarefa_item.dart';
import 'formulario_tarefa_page.dart';
import '../models/tarefa_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final temaController = Provider.of<TemaController>(context);
    final tarefaController = Provider.of<TarefaController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Tarefas'),
        actions: [
          IconButton(
            icon: Icon(temaController.temaAtual == ThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: temaController.alternarTema,
          ),
        ],
      ),
      body: Column(
        children: [
          BuscaWidget(
            onChanged: (texto) => tarefaController.setFiltroTexto(texto),
          ),
          FiltroWidget(
            onTipoChanged: (tipo) => tarefaController.setFiltroTipo(tipo),
            onOrdenacaoChanged: () => tarefaController.alternarOrdenacao(),
          ),
          Expanded(
            child: Consumer<TarefaController>(
              builder: (context, controller, _) {
                if (controller.tarefas.isEmpty) {
                  return const Center(
                    child: Text('Nenhuma tarefa encontrada.'),
                  );
                }
                return ListView.builder(
                  itemCount: controller.tarefas.length,
                  itemBuilder: (context, index) {
                    final tarefa = controller.tarefas[index];
                    return TarefaItem(
                      tarefa: tarefa,
                      onConcluidaChanged: (value) =>
                          controller.alternarConclusao(index),
                      onEditar: () => _abrirFormularioEdicao(
                          context, index, controller.tarefas[index]),
                      onRemover: () => _confirmarRemocao(context, index),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormularioAdicao(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _abrirFormularioAdicao(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FormularioTarefaPage(),
      ),
    );
  }

  void _abrirFormularioEdicao(BuildContext context, int index, Tarefa tarefa) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormularioTarefaPage(tarefa: tarefa, index: index),
      ),
    );
  }

  void _confirmarRemocao(BuildContext context, int index) {
    final tarefaController = Provider.of<TarefaController>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja realmente excluir a tarefa "${tarefaController.tarefas[index].titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              tarefaController.removerTarefa(index);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tarefa removida com sucesso!')),
              );
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
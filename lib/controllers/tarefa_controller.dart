import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/tarefa_model.dart';

class TarefaController extends ChangeNotifier {
  final Box<Tarefa> _tarefasBox = Hive.box<Tarefa>('tarefas_box');
  List<Tarefa> _tarefasFiltradas = [];
  List<int> _indicesOriginais = []; // Armazena os índices originais do Hive
  String _filtroTexto = '';
  String _filtroTipo = 'Todos';
  bool _ordenarPorData = true;

  TarefaController() {
    _carregarTarefas();
  }

  List<Tarefa> get tarefas => _tarefasFiltradas;
  String get filtroTexto => _filtroTexto;
  String get filtroTipo => _filtroTipo;
  bool get ordenarPorData => _ordenarPorData;

  void _carregarTarefas() {
    _aplicarFiltros();
  }

  void adicionarTarefa(Tarefa tarefa) {
    _tarefasBox.add(tarefa);
    _aplicarFiltros();
  }

  void atualizarTarefa(int index, Tarefa tarefa) {
    final hiveIndex = _indicesOriginais[index];
    _tarefasBox.putAt(hiveIndex, tarefa);
    _aplicarFiltros();
  }

  void removerTarefa(int index) {
    final hiveIndex = _indicesOriginais[index];
    _tarefasBox.deleteAt(hiveIndex);
    _aplicarFiltros();
  }

  void alternarConclusao(int index) {
    final hiveIndex = _indicesOriginais[index];
    final tarefa = _tarefasBox.getAt(hiveIndex);
    if (tarefa != null) {
      tarefa.concluida = !tarefa.concluida;
      tarefa.save();
      _aplicarFiltros();
    }
  }

  void setFiltroTexto(String texto) {
    _filtroTexto = texto;
    _aplicarFiltros();
  }

  void setFiltroTipo(String tipo) {
    _filtroTipo = tipo;
    _aplicarFiltros();
  }

  void alternarOrdenacao() {
    _ordenarPorData = !_ordenarPorData;
    _aplicarFiltros();
  }

  void _aplicarFiltros() {
    _indicesOriginais.clear();
    _tarefasFiltradas.clear();

    // Percorre todas as tarefas no Hive
    for (int i = 0; i < _tarefasBox.length; i++) {
      final tarefa = _tarefasBox.getAt(i);
      if (tarefa != null) {
        // Aplica filtro de texto
        final textoMatch = _filtroTexto.isEmpty ||
            tarefa.titulo.toLowerCase().contains(_filtroTexto.toLowerCase()) ||
            tarefa.observacao.toLowerCase().contains(_filtroTexto.toLowerCase());

        // Aplica filtro de tipo
        final tipoMatch = _filtroTipo == 'Todos' || tarefa.tipo == _filtroTipo;

        if (textoMatch && tipoMatch) {
          _tarefasFiltradas.add(tarefa);
          _indicesOriginais.add(i); // Armazena o índice original
        }
      }
    }

    // Ordena as tarefas
    if (_ordenarPorData) {
      final List<Tarefa> tarefasOrdenadas = List.from(_tarefasFiltradas);
      final List<int> indicesOrdenados = List.from(_indicesOriginais);

      // Ordena mantendo a correspondência entre tarefas e índices
      for (int i = 0; i < tarefasOrdenadas.length - 1; i++) {
        for (int j = i + 1; j < tarefasOrdenadas.length; j++) {
          if (tarefasOrdenadas[i].data.compareTo(tarefasOrdenadas[j].data) > 0) {
            final tempTarefa = tarefasOrdenadas[i];
            final tempIndex = indicesOrdenados[i];

            tarefasOrdenadas[i] = tarefasOrdenadas[j];
            indicesOrdenados[i] = indicesOrdenados[j];

            tarefasOrdenadas[j] = tempTarefa;
            indicesOrdenados[j] = tempIndex;
          }
        }
      }

      _tarefasFiltradas = tarefasOrdenadas;
      _indicesOriginais = indicesOrdenados;
    } else {
      final List<Tarefa> tarefasOrdenadas = List.from(_tarefasFiltradas);
      final List<int> indicesOrdenados = List.from(_indicesOriginais);

      // Ordena mantendo a correspondência entre tarefas e índices
      for (int i = 0; i < tarefasOrdenadas.length - 1; i++) {
        for (int j = i + 1; j < tarefasOrdenadas.length; j++) {
          if (tarefasOrdenadas[i].titulo.compareTo(tarefasOrdenadas[j].titulo) > 0) {
            final tempTarefa = tarefasOrdenadas[i];
            final tempIndex = indicesOrdenados[i];

            tarefasOrdenadas[i] = tarefasOrdenadas[j];
            indicesOrdenados[i] = indicesOrdenados[j];

            tarefasOrdenadas[j] = tempTarefa;
            indicesOrdenados[j] = tempIndex;
          }
        }
      }

      _tarefasFiltradas = tarefasOrdenadas;
      _indicesOriginais = indicesOrdenados;
    }

    notifyListeners();
  }
}
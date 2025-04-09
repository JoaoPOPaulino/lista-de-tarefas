import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TemaController extends ChangeNotifier {
  ThemeMode _temaAtual = ThemeMode.light;

  ThemeMode get temaAtual => _temaAtual;

  TemaController() {
    _carregarPreferencias();
  }

  Future<void> _carregarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    final temaSalvo = prefs.getString('tema') ?? 'light';
    _temaAtual = temaSalvo == 'dark' ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void alternarTema() async {
    _temaAtual = _temaAtual == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tema', _temaAtual == ThemeMode.dark ? 'dark' : 'light');
    notifyListeners();
  }
}
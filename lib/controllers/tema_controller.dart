import 'package:flutter/material.dart';

class TemaController extends ValueNotifier<ThemeMode> {
  TemaController() : super(ThemeMode.light);

  void alternarTema() {
    value = value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}

final temaController = TemaController();

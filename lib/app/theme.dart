import 'package:flutter/material.dart';

const _seed = Color(0xFF2563EB);

ThemeData _build(Brightness b) => ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: _seed, brightness: b),
      appBarTheme: const AppBarTheme(centerTitle: false),
    );

final ThemeData appTheme = _build(Brightness.light);
final ThemeData appDarkTheme = _build(Brightness.dark);

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'views/patrimonios_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const corVermelha = Color(0xFFE30613); // Vermelho característico (SENAI / Material Red)

    return GetMaterialApp(
      title: 'Gerenciamento de Patrimônio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: corVermelha,
          primary: corVermelha,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: corVermelha,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 2,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: corVermelha,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: corVermelha,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const PatrimoniosView(),
    );
  }
}

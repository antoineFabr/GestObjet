import 'package:gestobjetapp/features/app/presentation/pages/widget_tree.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gest Objet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.(26A163),
          brightness: Brightness.dark,
        ),
      ),
      home: WidgetTree(),
    );
  }
}

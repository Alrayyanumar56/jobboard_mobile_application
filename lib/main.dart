import 'package:flutter/material.dart';
import 'app/theme.dart';

void main() => runApp(const JobBoardApp());

class JobBoardApp extends StatelessWidget {
  const JobBoardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JobBoard',
      theme: appTheme,
      home: const Scaffold(
        body: Center(child: Text('JobBoard')),
      ),
    );
  }
}
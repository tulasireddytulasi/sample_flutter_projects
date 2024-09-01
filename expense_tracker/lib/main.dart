import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/view/home/home.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/repository/hive_init.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveInit().init();
  // await Hive.initFlutter();
  // Hive.registerAdapter(ExpenseAdapter()); // Register the adapter
  // var box = await Hive.openBox<Expense>('expenses');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

import 'dart:async';
import 'dart:io';
import 'package:expense_tracker/core/repository/hive_service.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class HiveInit {
  Future<void> init() async {
    Directory document = await getApplicationDocumentsDirectory();

    await Hive.initFlutter(document.path);
    Hive.registerAdapter(ExpenseAdapter()); // Register the adapter
    await HiveService().expenseBoxOpen();
  }
}
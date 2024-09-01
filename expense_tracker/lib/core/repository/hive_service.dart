import 'package:expense_tracker/model/expense.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static final HiveService _hiveService = HiveService._internal();

  factory HiveService() {
    return _hiveService;
  }

  HiveService._internal();

  late Box<Expense> _expenseBox;

  expenseBoxOpen() async {
    _expenseBox = await Hive.openBox<Expense>('expenses');
  }

  Box<Expense> get expenseBox => _expenseBox;
}

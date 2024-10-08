import 'package:hive/hive.dart';

part 'expense.g.dart'; // This will be generated by the Hive generator

@HiveType(typeId: 0) // Specify a unique typeId for the adapter
class Expense extends HiveObject {
  @HiveField(0)
  final String expenseId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final String category;

  Expense({
    required this.expenseId,
    required this.title,
    required this.amount,
    required this.category,
  });
}

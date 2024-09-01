import 'package:expense_tracker/core/repository/hive_service.dart';
import 'package:expense_tracker/core/utils/app_styles.dart';
import 'package:expense_tracker/core/utils/color_palette.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/view/home/widget/drop_down_widget.dart';
import 'package:expense_tracker/view/home/widget/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Expense> box;
  double totalAmount = 0;
  String formattedDate = "";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  String categoryValue = "Select Category";
  final List<String> categoryList = const ["Select Category", "Food", "Home Rent", "Grocery", "Medical Bills", "Shopping"];

  @override
  void initState() {
    super.initState();
    hiveInit();
  }

  hiveInit() async {
    box = HiveService().expenseBox;
    box.clear();
    DateTime now = DateTime.now();
    formattedDate = DateFormat('d, MMM').format(now);
  }

  void _addTransaction({required String id, required String title, required double amount, required String category}) {
    Expense expense = Expense(expenseId: id, title: title, category: category, amount: amount);
    box.add(expense);

    final expenses = box.values.toList();
    totalAmount = 0;
    for (var element in expenses) {
      totalAmount += element.amount;
    }

    setState(() {});
  }

  void _bottomWidget() {
    titleController.text = "";
    amountController.text = "";
    showModalBottomSheet(
      context: context,
      elevation: 6,
      isScrollControlled: true,
      enableDrag: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 15, right: 15, left: 15),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: ColorPalette.primary, width: 1),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: ColorPalette.primary, width: 1),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                DropDownWidget(
                  hintText: "Select Category",
                  value: categoryValue,
                  onChanged: (value) {
                    categoryValue = value ?? "";
                    setState(() {});
                  },
                  listData: categoryList,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 70,
                  child: ElevatedButton(
                    onPressed: () {
                      _addTransaction(
                        id: UniqueKey().toString(),
                        title: titleController.text.trim(),
                        amount: double.parse(amountController.text.trim()),
                        category: categoryValue,
                      );
                      titleController.text = "";
                      amountController.text = "";
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: ColorPalette.bodyColor2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      "Add",
                      style: AppStyles.bigTextStyle.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    ).whenComplete(
      () {
        titleController.text = "";
        amountController.text = "";
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary, // inversePrimary
        title: const Text("Expense Tracking App"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.only(left: 10, right: 10),
            alignment: Alignment.centerLeft,
            color: ColorPalette.lightViolet,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Amount:",
                  style: AppStyles.bigTextStyle.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  "₹$totalAmount",
                  style: AppStyles.bigTextStyle.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: box.length,
              itemBuilder: (context, index) {
                final expense = box.getAt(index);
                return TransactionCard(
                  title: expense?.title ?? "No Title",
                  amount: (expense?.amount.toString()) ?? "No Title",
                  dateTime: formattedDate,
                  category: expense?.category ?? "N/A",
                  key: Key(index.toString()),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 4),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _bottomWidget,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

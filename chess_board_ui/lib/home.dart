import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: ColumWidget(),
      ),
    );
  }
}

class RowWidgets extends StatelessWidget {
  const RowWidgets({super.key, required this.intVal});

  final int intVal;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(8, (index) {
        final int indexVal = index + intVal;
        bool isWhite = (indexVal % 2) == 0;
        return ChessBox(color: isWhite ? Colors.white : Colors.black);
      }),
    );
  }
}

class ColumWidget extends StatelessWidget {
  const ColumWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(8, (index) {
        final int indexVal = index + 1;
        bool isWhite = (indexVal % 2) == 0;
        return RowWidgets(intVal: isWhite ? 1 : 2);
      }),
    );
  }
}

class ChessBox extends StatelessWidget {
  const ChessBox({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      alignment: Alignment.center,
      width: 60,
      height: 60,
      color: color,
    );
  }
}
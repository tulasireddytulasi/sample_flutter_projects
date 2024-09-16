import 'package:flutter/material.dart';
import 'package:untitled/puzle.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
    //puzle();
  }



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
    return GestureDetector(
      onTap: () => puzle(),
      child: Container(
        margin: const EdgeInsets.all(4),
        alignment: Alignment.center,
        width: 60,
        height: 60,
        color: color,
      ),
    );
  }
}

void puzle(){
  print("ttttttttttttttttttttt");
  List<List<int?>> initialGrid = [
    [1, 5, 12, 10],
    [2, 14, 7, 15],
    [9, 4, 11, 3],
    [13, 6, 8, null]
  ];
  print("uuuuuuuuuuuuuuuu");
  PuzzleState? solution = solvePuzzle(initialGrid);
  print("hhhhhhhhhhh");
  printSolution(solution);
}
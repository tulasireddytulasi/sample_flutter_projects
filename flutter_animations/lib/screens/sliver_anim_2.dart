import 'package:flutter/material.dart';
import 'dart:math' as math;

class SliverAppBarAnim2 extends StatelessWidget {
  const SliverAppBarAnim2({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> products = List.generate(30, (index) => 'Product ${index + 1}');

    const double expandedHeight = 200.0;
    const double collapsedHeight = 60.0; // The height of the app bar when collapsed

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: expandedHeight,
              collapsedHeight: collapsedHeight,
              pinned: true,
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  // Calculate the scroll progress from 0.0 (expanded) to 1.0 (collapsed)
                  final double currentHeight = constraints.biggest.height;
                  final double progress = math.max(0.0, 1.0 - (currentHeight - collapsedHeight) / (expandedHeight - collapsedHeight));

                  // Linear interpolation for alignment
                  final Alignment alignment = Alignment.lerp(
                    Alignment.center, // Starts in the center
                    Alignment.centerLeft, // Ends on the left
                    progress,
                  )!;

                  // Linear interpolation for padding (to move it more to the left edge)
                  final EdgeInsets padding = EdgeInsets.lerp(
                    //EdgeInsets.zero, // No padding initially
                    const EdgeInsets.only(top: 100.0, bottom: 20),
                    const EdgeInsets.only(left: 16.0), // Padding when collapsed
                    progress,
                  )!;

                  return FlexibleSpaceBar(
                    titlePadding: EdgeInsets.only(top: 4, bottom: 4),
                    background: const ColoredBox(color: Colors.blue), // Placeholder background color
                    title: Align(
                      alignment: alignment,
                      child: Padding(
                        padding: padding,
                        child: Image.network(
                          'https://picsum.photos/800/600',
                          // width: 50,
                          // height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                    centerTitle: true,
                  );
                },
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: ListTile(
                      leading: const Icon(Icons.shopping_bag),
                      title: Text(products[index]),
                      subtitle: const Text('A great product for you.'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        print('Tapped on ${products[index]}');
                      },
                    ),
                  );
                },
                childCount: products.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
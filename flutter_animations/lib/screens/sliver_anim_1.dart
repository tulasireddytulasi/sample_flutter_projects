import 'package:flutter/material.dart';
import 'dart:math' as math;

class SliverAppBarAnim1 extends StatelessWidget {
  const SliverAppBarAnim1({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> products = List.generate(30, (index) => 'Product ${index + 1}');

    const double expandedHeight = 200.0;
    const double collapsedHeight = kToolbarHeight;
    const double leadingIconWidth = 56.0;
    const double leadingIconPadding = 16.0;
    const double collapsedTitleLeftPadding = leadingIconWidth + leadingIconPadding;

    // Define the padding for the expanded and collapsed states
    const EdgeInsets expandedPadding = EdgeInsets.only(top: 133.0, left: 20); // Only the top padding is set here
    const EdgeInsets collapsedPadding = EdgeInsets.only(left: collapsedTitleLeftPadding);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: expandedHeight,
            collapsedHeight: collapsedHeight,
            pinned: true,
            leading: const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Icon(Icons.arrow_back, color: Colors.white),
            ),
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double currentHeight = constraints.biggest.height;
                final double scrollProgress = math.max(0.0, 1.0 - (currentHeight - collapsedHeight) / (expandedHeight - collapsedHeight));

                final Alignment titleAlignment = Alignment.lerp(
                  Alignment.centerLeft,
                  Alignment.centerLeft,
                  scrollProgress,
                )!;

                // **FIXED:** The `EdgeInsets.lerp` now correctly transitions from `expandedPadding`
                // to `collapsedPadding`. Changes to `expandedPadding` will no longer
                // affect the final `collapsedPadding`.
                final EdgeInsets titlePadding = EdgeInsets.lerp(
                  expandedPadding,
                  collapsedPadding,
                  scrollProgress,
                )!;

                return FlexibleSpaceBar(
                  titlePadding: EdgeInsets.only(top: 6, bottom: 4),
                  centerTitle: true,
                  background: Image.network(
                    'https://picsum.photos/800/600',
                    fit: BoxFit.cover,
                  ),
                  title: Align(
                    alignment: titleAlignment,
                    child: Padding(
                      padding: titlePadding,
                      child: const Text(
                        'My Products',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
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
                    onTap: () {},
                  ),
                );
              },
              childCount: products.length,
            ),
          ),
        ],
      ),
    );
  }
}
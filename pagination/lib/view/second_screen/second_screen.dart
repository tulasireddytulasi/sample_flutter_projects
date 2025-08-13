import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Local dummy list to simulate fetched data
  List<String> myList = [];

  // PagingController manages paging logic and state
  late final _pagingController = PagingController<int, String>(
    getNextPageKey: (state) => (state.keys?.last ?? 0) + 1, // Calculates the next page
    fetchPage: (pageKey) => addData(pageKey), // Callback to fetch data
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Infinite Scroll Pagination Demo'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Center(
        child: PagingListener(
          controller: _pagingController,
          builder: (context, state, fetchNextPage) => PagedListView<int, String>(
            state: state,
            fetchNextPage: fetchNextPage, // Called when scroll reaches end
            builderDelegate: PagedChildBuilderDelegate(
              itemBuilder: (context, item, index) => Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.lightBlue.withAlpha(50)),
                ),
                child: Text(item), // Display each item from the list
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Simulates fetching data with 2-second delay
  Future<List<String>> addData(int page) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

    // Add 5 dummy items per page
    for (int i = 0; i < 5; i++) {
      myList.add('Page $page - Item ${i + 1}');
    }

    return myList; // Return updated list
  }
}

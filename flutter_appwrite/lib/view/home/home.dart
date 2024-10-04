import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite/model/photo_model.dart';
import 'package:flutter_appwrite/provider/home_provider.dart';
import 'package:flutter_appwrite/services/appwrite_config.dart';
import 'package:flutter_appwrite/utils/app_exceptions.dart';
import 'package:flutter_appwrite/utils/common_functins.dart';
import 'package:flutter_appwrite/view/home/widget/photo_card.dart';
import 'package:flutter_appwrite/view/profile/profile_screen.dart';
import 'package:flutter_appwrite/view/upload_file/upload_file.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PagingController<String, PhotoModel> _pagingController = PagingController(firstPageKey: "");
  late HomeProvider homeProvider;

  @override
  void initState() {
    super.initState();
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    _pagingController.addPageRequestListener((lastId) {
      _fetchGalleryPhotos(lastId: lastId);
    });
  }

  Future<void> _fetchGalleryPhotos({required String lastId}) async {
    List<String> queries = [Query.limit(5)];
    if (lastId.isNotEmpty) {
      queries.add(Query.cursorAfter(lastId));
    }

    final Result<DocumentList, String> photosResponse = await homeProvider.getGalleryPhotos(queries: queries);
    final DocumentList documentList = photosResponse.success!;
    String finalLastId = documentList.documents.lastOrNull?.$id ?? "";
    final isLastPage = documentList.total < 5;
    print("isLastPage: $isLastPage, total: ${documentList.total}, finalLastId: $finalLastId");
    final List<PhotoModel> photoModelList = List<PhotoModel>.from(
      documentList.documents.map((x) => PhotoModel.fromJson(x.data)),
    );

    if (isLastPage) {
      _pagingController.appendLastPage(photoModelList);
    } else {
      _pagingController.appendPage(photoModelList, finalLastId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard", style: Theme.of(context).textTheme.titleLarge),
        elevation: 4,
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const UploadFile()));
              },
              icon: const Icon(Icons.add)),
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
              },
              icon: const Icon(Icons.person)),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: PagedGridView<String, PhotoModel>(
            showNewPageProgressIndicatorAsGridChild: false,
            showNewPageErrorIndicatorAsGridChild: false,
            showNoMoreItemsIndicatorAsGridChild: false,
            pagingController: _pagingController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 9 / 16,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
            ),
            builderDelegate: PagedChildBuilderDelegate<PhotoModel>(
              itemBuilder: (context, item, index) => InkWell(
                onTap: () {
                 print("Photo URL: ${item.toJson()}");
                },
                child: PhotoCard(
                  key: ValueKey(item.filePath),
                  imageUrl: getFileLink(bucketId: AppwriteConfig.galleryBucketId, fileId: item.filePath ?? ""),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:users_app/core/utils/constants.dart';
import 'package:users_app/core/utils/custom_colors.dart';
import 'package:users_app/model/actor_model.dart';
import 'package:users_app/view/home/bloc/home_bloc.dart';
import 'package:users_app/view/home/widget/user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String baseURL = "https://image.tmdb.org/t/p/w185";
  final HomeBloc homeBloc = HomeBloc();
  int pageNo = 0;
  static const _pageSize = 20;
  final PagingController<int, Result> _pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      homeBloc.add(LoadUserData(pageNo: pageKey));
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.DARK_JUNGLE_GREEN_1,
      appBar: AppBar(
        backgroundColor: CustomColors.tealishBlue,
        centerTitle: false,
        title: const Text(
          "Actors Screen",
          style: TextStyle(
            fontSize: 24,
            color: CustomColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<HomeBloc, HomeState>(
          bloc: homeBloc,
          listener: (context, state) {
            if (state.runtimeType == UsersDataLoaded) {
              final myData = state as UsersDataLoaded;
              final List<Result> data = myData.usersData;
              pageNo = pageNo + 1;
              print("pageNo: $pageNo");
              _pagingController.appendPage(data, pageNo);
            }
          },
          builder: (context, state) {
            return PagedListView<int, Result>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<Result>(
                itemBuilder: (context, item, index) {
                  return UserCard(
                    name: item.name ?? "",
                    dob: item.knownForDepartment ?? "",
                    gender: (item.gender ?? 1) == 2 ? "Male" : "Female",
                    picUrl: baseURL + (item.profilePath ?? ""),
                    info: Constants.bio,
                    location: "vizag, Andhra Pradesh - 530017",
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

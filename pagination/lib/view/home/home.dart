// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:users_app/core/utils/constants.dart';
// import 'package:users_app/core/utils/custom_colors.dart';
// import 'package:users_app/model/actor_model.dart';
// import 'package:users_app/view/details/details.dart';
// import 'package:users_app/view/home/bloc/home_bloc.dart';
// import 'package:users_app/view/home/widget/user_card.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final String baseURL = "https://image.tmdb.org/t/p/w185";
//   final String imgURL = "https://image.tmdb.org/t/p/w500";
//   final HomeBloc homeBloc = HomeBloc();
//   int pageNo = 1;
//   final PagingController<int, Result> _pagingController = PagingController(firstPageKey: 1);
//
//   @override
//   void initState() {
//     super.initState();
//     _pagingController.addPageRequestListener((pageKey) {
//       homeBloc.add(LoadUserData(pageNo: pageKey));
//     });
//   }
//
//   @override
//   void dispose() {
//     _pagingController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: CustomColors.DARK_JUNGLE_GREEN_1,
//       appBar: AppBar(
//         backgroundColor: CustomColors.tealishBlue,
//         centerTitle: false,
//         title: const Text(
//           "Actors Screen",
//           style: TextStyle(
//             fontSize: 24,
//             color: CustomColors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: BlocConsumer<HomeBloc, HomeState>(
//           bloc: homeBloc,
//           listener: (context, state) {
//             print("state: ${state.runtimeType}");
//             try {
//               if (state is NavigateToDetailsState) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => DetailsScreen(
//                       imgURL: state.imgUrl,
//                       imgTag: state.imgTag,
//                     ),
//                   ),
//                 );
//               }
//               if (state.runtimeType == UsersDataLoaded) {
//                 final myData = state as UsersDataLoaded;
//                 final List<Result> data = myData.usersData;
//                 pageNo++;
//                 _pagingController.appendPage(data, pageNo);
//               }
//             } catch (e) {
//               print("Error: $e");
//             }
//           },
//           builder: (context, state) {
//             return PagingState<int, Result>(
//               pagingController: _pagingController,
//               builderDelegate: PagedChildBuilderDelegate<Result>(
//                 itemBuilder: (context, item, index) {
//                   final String imgUrlVal = item.profilePath ?? "";
//                   final String imgUrl = imgUrlVal.isEmpty ? imgUrlVal : imgURL + imgUrlVal;
//
//                   return InkWell(
//                     onTap: () {
//                       try {
//                         homeBloc.add(
//                           NavigateToDetailsEvent(
//                             dateNow: DateTime.now().toIso8601String(),
//                             imgUrl: imgUrl,
//                             imgTag: item.name ?? "",
//                           ),
//                         );
//                       } catch (e) {
//                         print("Error: $e");
//                       }
//                     },
//                     child: UserCard(
//                       name: item.name ?? "",
//                       dob: item.knownForDepartment ?? "",
//                       gender: (item.gender ?? 1) == 2 ? "Male" : "Female",
//                       picUrl: imgUrl,
//                       info: Constants.bio,
//                       location: "vizag, Andhra Pradesh - 530017",
//                     ),
//                   );
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

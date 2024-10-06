import 'package:chat_ui/app/core/routes/route_names.dart';
import 'package:chat_ui/app/core/utils/enums.dart';
import 'package:chat_ui/app/view/error_screen/error_screen.dart';
import 'package:chat_ui/app/view/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouteConfig {
  static GoRouter returnRouter() {
    return GoRouter(
      initialLocation: "/",
      routes: [
        GoRoute(
          path: "/",
          name: RouteNames.initial,
          redirect: (context, state) {
            String? path = state.fullPath;
            if (path == null || path == "/" || path == "/dashboard") {
              return "/dashboard/movies/popular";
            }
            return null;
          },
          routes: [
            GoRoute(
              path: "dashboard/:mainScreen/:subScreen",
              builder: (context, state) {
                String? mainScreen = state.pathParameters["mainScreen"];
                String? subScreen = state.pathParameters["subScreen"];
                bool mainError = !MAIN_SCREENS.values.toString().contains(mainScreen.toString());
                bool subErrorScreen = !SUB_SCREENS.values.toString().contains(subScreen.toString());

                if (mainError || subErrorScreen) {
                  return const ErrorScreen(title: "URL Error");
                }

                MAIN_SCREENS? mainScreens;
                try {
                  mainScreens = MAIN_SCREENS.values.byName(mainScreen ?? "");
                } catch (e) {
                  mainScreens = MAIN_SCREENS.movies;
                }
                SUB_SCREENS? screens;
                try {
                  screens = SUB_SCREENS.values.byName(subScreen ?? "");
                } catch (e) {
                  screens = SUB_SCREENS.popular;
                }
                return HomeScreen(mainScreen: mainScreens, subScreen: screens);
              },
            )
          ],
        ),
        GoRoute(
          path: "/dashboard",
          redirect: (context, state) {
            return "/dashboard/movies/popular";
          },
        ),
        GoRoute(
          path: "/dashboard/movies",
          redirect: (context, state) {
            return "/dashboard/movies/popular";
          },
        ),
        GoRoute(
          path: "/dashboard/tvSeries",
          redirect: (context, state) {
            return "/dashboard/tvSeries/popular";
          },
        ),
        GoRoute(
          path: "/dashboard/celebrities",
          redirect: (context, state) {
            return "/dashboard/celebrities/popular";
          },
        ),
      ],
      errorPageBuilder: (context, state) => const MaterialPage(
        child: ErrorScreen(title: "URL Error"),
      ),
    );
  }
}

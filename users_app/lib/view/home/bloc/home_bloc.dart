import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:users_app/core/resource/http_request.dart';
import 'package:users_app/model/actor_model.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeInitial()) {
    on<LoadUserData>(_start);
  }

  Future<FutureOr<void>> _start(LoadUserData homeEvent, Emitter<HomeState> emit) async {
    final String url = "person/popular?language=en_us&page=${homeEvent.pageNo}&api_key=434fcadef5103207fecca9176385a533";

    try {
      emit(UsersDataLoading());
      final Response response = await HttpRequestDio().getActorsList(url: url);
      if (response.statusCode == 200) {
        final UserModel userModel = userModelFromJson(json.encode(response.data));
        final List<Result> userData = userModel.results ?? [];
        emit(UsersDataLoaded(usersData: userData));
      }
    } catch (e, s) {
      print("Error: $e");
      print("Error Stack: $s");
    }
  }
}

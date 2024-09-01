part of 'home_bloc.dart';

@immutable
sealed class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();

  @override
  List<Object?> get props => [];
}

class UsersDataLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

final class UsersDataLoaded extends HomeState {
  const UsersDataLoaded({required this.usersData});

  final List<Result> usersData;

  @override
  List<Object?> get props => [usersData];
}

class UsersDataError extends HomeState {
  const UsersDataError();

  @override
  List<Object?> get props => [];
}

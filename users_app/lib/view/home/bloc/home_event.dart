part of 'home_bloc.dart';

@immutable
sealed class HomeEvent extends Equatable {
  const HomeEvent();
}

final class HomeStarted extends HomeEvent{
  @override
  List<Object?> get props => [];
}

final class LoadUserData extends HomeEvent{
  const LoadUserData({required this.pageNo});
  final int pageNo;
  @override
  List<Object?> get props => [pageNo];
}

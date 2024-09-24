part of 'details_bloc.dart';

@immutable
sealed class DetailsEvent extends Equatable {
  const DetailsEvent();
}

final class LoadImageEvent extends DetailsEvent {
  @override
  List<Object?> get props => [];
}





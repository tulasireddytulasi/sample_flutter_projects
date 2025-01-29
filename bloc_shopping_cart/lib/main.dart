import 'package:bloc_shopping_cart/app.dart';
import 'package:bloc_shopping_cart/shopping_repository.dart';
import 'package:bloc_shopping_cart/simple_bloc_observer.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  Bloc.observer = const SimpleBlocObserver();
  runApp(App(shoppingRepository: ShoppingRepository()));
}

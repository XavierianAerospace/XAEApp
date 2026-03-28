import 'package:equatable/equatable.dart';

abstract class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object?> get props => [];
}

class MenuInitial extends MenuState {
  const MenuInitial();
}

class MenuLoaded extends MenuState {
  const MenuLoaded();
}

part of 'game_session_filter_bloc.dart';

abstract class GameSessionFilterEvent extends Equatable {
  const GameSessionFilterEvent();

  @override
  List<Object> get props => [];
}

class UpdateFilter extends GameSessionFilterEvent {
  const UpdateFilter();

  @override
  List<Object> get props => [];
}

class UpdateGameSessionWithFilter extends GameSessionFilterEvent {
  final GameSessionFilter gameSessionFilter;

  const UpdateGameSessionWithFilter({this.gameSessionFilter = GameSessionFilter.all});

  @override
  List<Object> get props => [gameSessionFilter];
}

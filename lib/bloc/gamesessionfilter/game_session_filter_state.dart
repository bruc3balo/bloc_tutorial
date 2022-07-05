part of 'game_session_filter_bloc.dart';

abstract class GameSessionFilterState extends Equatable {
  const GameSessionFilterState();

  @override
  List<Object> get props => [];

}

class GameSessionFilterLoading extends GameSessionFilterState {

}

class GameSessionFilterLoaded extends GameSessionFilterState {

  final List<GameSession> filteredGameSessions;
  final GameSessionFilter gameSessionFilter;


  const GameSessionFilterLoaded({required this.filteredGameSessions, this.gameSessionFilter = GameSessionFilter.all});

  @override
  List<Object> get props => [filteredGameSessions,gameSessionFilter];
}

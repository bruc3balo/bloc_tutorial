part of 'game_session_bloc.dart';

abstract class GameSessionState extends Equatable {
  const GameSessionState();

  @override
  List<Object> get props => [];
}
//define all states of gamesession


class GameSessionLoading extends GameSessionState {

}

class GameSessionLoaded extends GameSessionState {
  final List<GameSession> gameSessions;

  const GameSessionLoaded({this.gameSessions = const <GameSession>[]});

  @override
  List<Object> get props => [gameSessions];
}

part of 'game_session_bloc.dart';

abstract class GameSessionEvent extends Equatable {
  const GameSessionEvent();

  @override
  List<Object?> get props => [];
}

//add events that happen to game session
class LoadGameSession extends GameSessionEvent {
  final List<GameSession> gameSessions;

  const LoadGameSession({this.gameSessions = const <GameSession> []});

  @override
  List<Object?> get props => [gameSessions];
}
class AddGameSession extends GameSessionEvent {
  final GameSession gameSession;

  const AddGameSession({required this.gameSession});

  @override
  List<Object?> get props => [gameSession];
}

class UpdateGameSession extends GameSessionEvent {
  final GameSession gameSession;

  const UpdateGameSession({required this.gameSession});

  @override
  List<Object?> get props => [gameSession];
}
class DeleteGameSession extends GameSessionEvent {
  final GameSession gameSession;

  const DeleteGameSession({required this.gameSession});

  @override
  List<Object?> get props => [gameSession];
}


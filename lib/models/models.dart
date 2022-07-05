import 'package:equatable/equatable.dart';

class GameSession extends Equatable{
  final String sessionId;
  final String host;
  bool? ongoing;
  bool? completed;
  bool? cancelled;

  GameSession({
      required this.sessionId, required this.host, this.ongoing, this.completed, this.cancelled}) {
    ongoing = ongoing ?? false;
    completed = completed ?? false;
    cancelled = cancelled ?? false;
  }


  GameSession copyWith({
  String? sessionId,
  String? host,
  bool? ongoing,
  bool? completed,
  bool? cancelled}) {
    return GameSession(
        sessionId: sessionId ?? this.sessionId,
        host: host ?? this.host,
        ongoing: ongoing ?? this.ongoing,
        completed: completed ?? this.completed,
        cancelled: cancelled ?? this.cancelled,
    );
  }

  @override
  List<Object?> get props => [
    sessionId,
    host,
    ongoing,
    completed,
    cancelled,
  ];

  static List<GameSession> gameSessions = [
    GameSession(sessionId: "482945", host: "thewick3rman",ongoing: true),
    GameSession(sessionId: "592857", host: "oly",ongoing: true),
  ];
}

enum GameSessionFilter {
  all,
  completed,
  cancelled,
  ongoing,
  pending,
}
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/models.dart';

part 'game_session_event.dart';
part 'game_session_state.dart';


//update event handler
class GameSessionBloc extends Bloc<GameSessionEvent, GameSessionState> {
  GameSessionBloc() : super(GameSessionLoading()) {
    on<LoadGameSession>(_onLoadGameSession);
    on<AddGameSession>(_onAddGameSession);
    on<DeleteGameSession>(_onDeleteGameSession);
    on<UpdateGameSession>(_onUpdateGameSession);
  }


  void _onLoadGameSession (LoadGameSession event, Emitter<GameSessionState> emit) {
    emit(
      GameSessionLoaded(gameSessions: event.gameSessions),
    );
  }
  void _onAddGameSession (AddGameSession event, Emitter<GameSessionState> emit) {
    final state = this.state;
    if (state is GameSessionLoaded) {
      emit(GameSessionLoaded(gameSessions: List.from(state.gameSessions)..add(event.gameSession)));
    }
  }
  void _onDeleteGameSession (DeleteGameSession event, Emitter<GameSessionState> emit) {
    final state = this.state;
    if (state is GameSessionLoaded) {
      List<GameSession> gameSessions = state.gameSessions.where((gs) => gs.sessionId != event.gameSession.sessionId).toList();
      emit (
        GameSessionLoaded(gameSessions: gameSessions),
      );
    }
  }
  void _onUpdateGameSession (UpdateGameSession event, Emitter<GameSessionState> emit) {
    final state = this.state;
    if (state is GameSessionLoaded) {
      List<GameSession> gameSessions = (state.gameSessions.map((gs) => gs.sessionId == event.gameSession.sessionId ? event.gameSession : gs)).toList();

      emit (GameSessionLoaded(gameSessions: gameSessions));
    }
  }
}

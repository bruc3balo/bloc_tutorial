import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_tutorial/models/models.dart';
import 'package:equatable/equatable.dart';

import '../gamesessionbloc/game_session_bloc.dart';

part 'game_session_filter_event.dart';
part 'game_session_filter_state.dart';

class GameSessionFilterBloc extends Bloc<GameSessionFilterEvent, GameSessionFilterState> {

  final GameSessionBloc _gameSessionBloc;
  late StreamSubscription _gameSessionSubscription;

  //loading is the starting event
  GameSessionFilterBloc({required GameSessionBloc gameSessionBloc}) : _gameSessionBloc = gameSessionBloc , super(GameSessionFilterLoading()) {
    on<UpdateGameSessionWithFilter>(_onUpdateGameSession);
    on<UpdateFilter>(_onUpdateFilter);

    _gameSessionSubscription = gameSessionBloc.stream.listen((event) {
      add(const UpdateFilter());
    });
  }

  void _onUpdateFilter (UpdateFilter event, Emitter<GameSessionFilterState> emitter) {
    final state = this.state;
    if(state is GameSessionFilterLoading) {
      add(const UpdateGameSessionWithFilter(gameSessionFilter: GameSessionFilter.all));
    }
    
    if(state is GameSessionFilterLoaded) {
      final state = this.state as GameSessionFilterLoaded;

      //from bloc state
      add(UpdateGameSessionWithFilter(gameSessionFilter: state.gameSessionFilter));
    }

  }

  void _onUpdateGameSession (UpdateGameSessionWithFilter event, Emitter<GameSessionFilterState> emitter) {
    final state = _gameSessionBloc.state;
    if(state is GameSessionLoaded) {
      List<GameSession> gameSessions = state.gameSessions.where((gs) {
        switch (event.gameSessionFilter) {

          case GameSessionFilter.all:
            return true;
          case GameSessionFilter.completed:
            return gs.completed!;
          case GameSessionFilter.cancelled:
            return gs.cancelled!;
          case GameSessionFilter.ongoing:
            return gs.ongoing! && !gs.cancelled!;
          case GameSessionFilter.pending:
            return !(gs.ongoing! || gs.cancelled! || gs.completed!);
      }
      }).toList();

      emitter(GameSessionFilterLoaded(filteredGameSessions: gameSessions));
    }
  }
}

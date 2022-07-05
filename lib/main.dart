import 'package:bloc_tutorial/bloc/gamesessionbloc/game_session_bloc.dart';
import 'package:bloc_tutorial/bloc/gamesessionfilter/game_session_filter_bloc.dart';
import 'package:bloc_tutorial/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GameSessionBloc()..add(LoadGameSession(gameSessions: GameSession.gameSessions))),
        BlocProvider(create: (context)=> GameSessionFilterBloc(gameSessionBloc: BlocProvider.of<GameSessionBloc>(context))),
      ],
      child: const MaterialApp(
        title: 'Bloc Demo',
        home: GameList(),
      ),
    );
  }
}


class GameList extends StatefulWidget {
  const GameList({Key? key}) : super(key: key);

  @override
  State<GameList> createState() => _GameListState();
}

class _GameListState extends State<GameList> {


  Card _gameCard(GameSession gameSession, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("#${index + 1}: ${gameSession.host}", style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),),
            Row(
              children: [
                IconButton(onPressed: () {
                  context.read<GameSessionBloc>().add(UpdateGameSession(gameSession: gameSession.copyWith(completed: true)));
                }, icon: const Icon(Icons.stop_circle)),
                IconButton(onPressed: () {
                  //context.read<GameSessionBloc>().add(DeleteGameSession(gameSession: gameSession));
                  context.read<GameSessionBloc>().add(UpdateGameSession(gameSession: gameSession.copyWith(cancelled: true)));
                }, icon: const Icon(Icons.cancel)),
              ],
            )
          ],
        ),
      ),
    );
  }


  Widget _gameSessionWidget (String title) {
    return BlocConsumer<GameSessionFilterBloc, GameSessionFilterState>(
      listener: (context, state) {
        if(state is GameSessionFilterLoaded) {

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Game sessions are ${state.filteredGameSessions.length} in your ${state.gameSessionFilter.toString().split('.').last}")));
        }
      },
      builder: (context, state) {
        if (state is GameSessionLoading) {
          return const CircularProgressIndicator(color: Colors.red,);
        } else if (state is GameSessionFilterLoaded) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child:  Text(title,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.filteredGameSessions.length,
                    itemBuilder: (BuildContext c, int i) {
                      return _gameCard(state.filteredGameSessions[i],i);
                    }
                )
              ],
            ),
          );
        } else {
          return const Text("Something went wrong");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Games"),
          actions: [
            IconButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NewGame()));
            }, icon: const Icon(Icons.add))
          ],
          bottom: TabBar(
            onTap: (tabIndex) {
              switch(tabIndex) {
                case 0:
                  BlocProvider.of<GameSessionFilterBloc>(context)
                      .add(const UpdateGameSessionWithFilter(gameSessionFilter: GameSessionFilter.all));
                  break;

                case 1:
                  BlocProvider.of<GameSessionFilterBloc>(context)
                      .add(const UpdateGameSessionWithFilter(gameSessionFilter: GameSessionFilter.completed));
                  break;

                case 2:
                  BlocProvider.of<GameSessionFilterBloc>(context)
                      .add(const UpdateGameSessionWithFilter(gameSessionFilter: GameSessionFilter.cancelled));
                  break;
              }
            },
            tabs: const [
              Tab(icon: Icon(Icons.play_circle_outline),),
              Tab(icon: Icon(Icons.stop_circle),),
              Tab(icon: Icon(Icons.cancel),),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _gameSessionWidget("All"),
            _gameSessionWidget("Completed"),
            _gameSessionWidget("Cancelled"),
          ],
        ),
      ),
    );
  }
}


class NewGame extends StatefulWidget {
  const NewGame({Key? key}) : super(key: key);

  @override
  State<NewGame> createState() => _NewGameState();
}

class _NewGameState extends State<NewGame> {
  
  final TextEditingController _host = TextEditingController();
  final TextEditingController _sessionId = TextEditingController();

  Column _inputField(String field,TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(field,style: const TextStyle(fontSize: 19,fontWeight: FontWeight.bold),),
        Container(height: 50,margin: const EdgeInsets.only(bottom: 10),width: double.infinity,child: TextFormField(controller: controller,),),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Game Bloc"),
      ),
      body: BlocListener<GameSessionBloc, GameSessionState>(
      listener: (context, state) {
          if (state is GameSessionLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Game session added ")),
            );
          }
      },
      child: Card(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _inputField("Session Id",_sessionId),
                  _inputField("Host",_host),
                  ElevatedButton(onPressed: () {
                    context.read<GameSessionBloc>().add(AddGameSession(gameSession: GameSession(sessionId: _sessionId.text, host: _host.text)));
                    Navigator.pop(context);
                    }, child: const Text("Start Game"))
                ],
              ),
            ),
          ),
      ),
    );
  }
}







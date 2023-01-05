import 'package:bloc_provider_builder/user_bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'counter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _counterBloc = CounterBloc()..add(CounterDecEvent());
    final _userBloc = UserBloc();
    return MultiBlocProvider(
      providers: [
        BlocProvider<CounterBloc>(create: (context) => _counterBloc),
        BlocProvider<UserBloc>(create: (context) => _userBloc,
        ),
      ],
      child: Scaffold(
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  _counterBloc.add(CounterIncEvent());
                },
                icon: Icon(Icons.plus_one)),
            IconButton(
                onPressed: () {
                  _counterBloc.add(CounterDecEvent());
                },
                icon: Icon(Icons.exposure_minus_1)),
            IconButton(
                onPressed: () {
                  _userBloc.add(UserGetUsersEvent(_counterBloc.state));// количество пользователей будем брать из счетчика
                },
                icon: Icon(Icons.person_add)),
            IconButton(
                onPressed: () {
                  _userBloc.add(UserGetUsersJobEvent(_counterBloc.state));// количество пользователей будем брать из счетчика
                },
                icon: Icon(Icons.work)),

          ],
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                BlocBuilder<CounterBloc, int>(
                  bloc: _counterBloc,
                  builder: (context, state) {
                    return Text(state.toString(), style: TextStyle(fontSize: 33));
                  },
                ),
                BlocBuilder<UserBloc, UserState>(
                  bloc: _userBloc,
                  builder: (context, state) {
                    final users = state.users;
                    final job = state.job;
                    return Column(
                      children: [
                        if (state.isLoading )
                          CircularProgressIndicator(),
                        if (users.isNotEmpty)
                          ...users.map((e) => Text(e.name)),
                        if (job.isNotEmpty)
                          ...job.map((e) => Text(e.name)),


                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import 'counter_bloc.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatelessWidget {
//   const MyHomePage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<CounterBloc>(
//       create: (context) => CounterBloc(),
//       child: BlocBuilder<CounterBloc, int>(builder: (context, state) {
//         return Scaffold(
//           floatingActionButton: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               IconButton(onPressed: () {
//                 BlocProvider.of<CounterBloc>(context).add(CounterIncEvent());
//               }, icon: Icon(Icons.plus_one)),
//               IconButton(onPressed: () {
//                 BlocProvider.of<CounterBloc>(context).add(CounterDecEvent());
//               }, icon: Icon(Icons.exposure_minus_1)),
//             ],
//           ),
//           body: Center(child: Text(state.toString(), style: TextStyle(fontSize: 33))),
//         );
//       },
//       ),
//     );
//   }
// }

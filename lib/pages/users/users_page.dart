import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/pages/users/users_controller.dart';
import 'package:front/pages/users/users_loaded_page.dart';

class UsersPage extends StatelessWidget{
  const UsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UsersCubit()..refresh(),
      child: Center(
        child: BlocBuilder<UsersCubit, UsersState>(
          builder: (context, state){
            switch (state.phase) {
              case LoadPhase.init:
                return const Text("u don't have to see init");
              case LoadPhase.loading:
                return const CircularProgressIndicator();
              case LoadPhase.failed:
                return Text("ERROR! ${state.err}",
                  style: const TextStyle(color: Colors.red),
                );
              case LoadPhase.ready:
                return UsersLoadedPage(state.users);
            }
          },
        ),
      ),
    );
  }
}
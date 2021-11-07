import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/pages/rooms/rooms_controller.dart';
import 'package:front/pages/rooms/rooms_loaded_page.dart';

class RoomsPage extends StatelessWidget{
  const RoomsPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RoomsCubit()..refresh(),
      child: Center(
        child: BlocBuilder<RoomsCubit, RoomsState>(
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
                return RoomsLoadedPage(state.rooms);
            }
          },
        ),
      ),
    );
  }
}
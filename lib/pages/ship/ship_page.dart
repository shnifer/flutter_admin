import 'package:flutter/material.dart';
import 'package:flutter_admin/pages/ship/ship_controller.dart';
import 'package:flutter_admin/pages/ship/ship_loaded_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShipPage extends StatelessWidget{
  const ShipPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ShipCubit()..refresh(),
      child: Center(
        child: BlocBuilder<ShipCubit, ShipState>(
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
                return ShipLoadedPage(state.ship!);
            }
          },
        ),
      ),
    );
  }
}
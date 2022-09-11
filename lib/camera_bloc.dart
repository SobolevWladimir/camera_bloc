import 'dart:io';

import 'package:flutter/material.dart';
import 'bloc/cameras/bloc.dart';
import 'language.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class CameraScreen extends StatelessWidget {
  final CameraLanguage language;
  final Function(File file) onTakePhoto;
  const CameraScreen(
      {Key? key,
      required this.onTakePhoto,
      this.language = const CameraLanguage()})
      : super(key: key);
  Widget _loading() => Container(
        color: Colors.black,
        child: const Center(child: CircularProgressIndicator()),
      );
  Widget _notCameras() => Container(
        color: Colors.black,
        child: Center(
            child: Text(
          language.notCameras,
          style: const TextStyle(color: Colors.white),
        )),
      );

  Widget _errrorLoad() => Container(
        color: Colors.black,
        child: Center(
            child: Text(
          language.errorLoad,
          style: const TextStyle(color: Colors.white),
        )),
      );

  Widget _errorPermissions() => Container(
        color: Colors.black,
        child: Center(
            child: Text(
          language.notPermissions,
          style: const TextStyle(color: Colors.white),
        )),
      );
  List<BlocProvider> getProviders() {
    return [
      BlocProvider<CamerasBloc>(
        create: (context) {
          return CamerasBloc()..add(InitCameras());
        },
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: getProviders(),
      child: BlocBuilder<CamerasBloc, CamerasState>(
        builder: (constex, state) {
          if (state is InitingCameras) {
            return _loading();
          }
          if (state is NotAvailebleCameras) {
            return _notCameras();
          }
          if (state is ErrorInitingCameras) {
            return _errrorLoad();
          }
          if (state is NotPermissions) {
            return _errorPermissions();
          }
          if (state is ReadyCameras) {
            return CameraItem(state.controller, onTakePhoto: onTakePhoto);
          }
          return const Center(child: Text("что то пошло не так"));
        },
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:newsdaily/model/tesla_model.dart';
import 'package:newsdaily/repository/tesla_repo.dart';


class TeslaBloc {
  late TeslaRepository teslaRepository;

  StreamController? teslaController;

  StreamSink<TeslaNewsModel> get teslaSink =>
      teslaController!.sink as StreamSink<TeslaNewsModel>;

  Stream<TeslaNewsModel> get teslaStream =>
      teslaController!.stream as Stream<TeslaNewsModel>;

  TeslaBloc() {
    teslaRepository = TeslaRepository();
    teslaController = StreamController<TeslaNewsModel>();
  }

  getTesla() async {
    try {
     TeslaNewsModel response =
          await teslaRepository.data();
      teslaSink.add(response);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  dispose() {
    teslaController?.close();
  }
}

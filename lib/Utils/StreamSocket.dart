
import 'dart:async';
import 'package:gemini_ai/Models/DataModel.dart';

class StreamSocket {
  final _socketResponse = StreamController<List<DataModel>>.broadcast();
  void Function(List<DataModel>) get addResponse => _socketResponse.sink.add;
  Stream<List<DataModel>> get getResponse => _socketResponse.stream.asBroadcastStream();
}
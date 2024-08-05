import 'dart:isolate';
import 'package:spotify_downloader/core/utils/utils.dart';

class IsolatePool {
  IsolatePool._(Isolate mainIsolate, SendPort addSendPort)
      : _mainIsolate = mainIsolate,
        _mainSendPort = addSendPort;

  static const _cancelCommand = 'cancel_command';

  final Isolate _mainIsolate;
  final SendPort _mainSendPort;

  bool _isIsolateKilled = false;

  static Future<IsolatePool> create() async {
    final ReceivePort mainReceivePort = ReceivePort();
    final mainIsolate = await Isolate.spawn(mainIsolateEntryPoint, mainReceivePort.sendPort);
    final mainSendPort = await mainReceivePort.first;
    return IsolatePool._(mainIsolate, mainSendPort);
  }

  static void mainIsolateEntryPoint(SendPort isolateSendPort) {
    ReceivePort isolateReceivePort = ReceivePort();
    isolateSendPort.send(isolateReceivePort.sendPort);

    isolateReceivePort.listen((message) {
      function(sendPort, token) => message.$1.call(sendPort, message.$2, token);
      _startFunction(function, message.$3);
    });
  }

  static void _startFunction(
      Function(SendPort, CancellationToken) function, SendPort functionSendPort) {
    final functionReceivePort = ReceivePort();
    functionSendPort.send(functionReceivePort.sendPort);

    final cancellationTokenSource = CancellationTokenSource();

    functionReceivePort.listen((message) {
      if (message == _cancelCommand) {
        cancellationTokenSource.cancel();
      }
    });

    function.call(functionSendPort, cancellationTokenSource.token);
  }

  void closeIsolatePool() {
    _mainIsolate.kill();
    _isIsolateKilled = true;
  }

  Future<CancellableStream> add<T>(
      Future<void> Function(SendPort sendPort, T params, CancellationToken token) function, T params) async {
    if (_isIsolateKilled) {
      throw IsolatePoolWasClosedException();
    }

    final handlerReceivePort = ReceivePort();
    _mainSendPort.send((function, params, handlerReceivePort.sendPort));

    final broadcastReceivePort = handlerReceivePort.asBroadcastStream();
    final handlerSendPort = (await broadcastReceivePort.first) as SendPort;

    return CancellableStream(stream: broadcastReceivePort, cancelFunciton: () => handlerSendPort.send(_cancelCommand));
  }

  Future<CancellableCompute<ReturnType>> compute<ReturnType, Params>(
      Future<ReturnType> Function(Params params, CancellationToken token) function, Params params) async {
    if (_isIsolateKilled) {
      throw IsolatePoolWasClosedException();
    }

    final handlerReceivePort = ReceivePort();
    _mainSendPort.send((
      (SendPort sendPort, Params params, CancellationToken token) async =>
          sendPort.send(await function.call(params, token)),
      params,
      handlerReceivePort.sendPort
    ));

    final broadcastReceivePort = handlerReceivePort.asBroadcastStream();
    final handlerSendPort = (await broadcastReceivePort.first) as SendPort;

    return CancellableCompute<ReturnType>(
        future: () async {
          final awaitResult  = await broadcastReceivePort.first;
          return awaitResult as ReturnType;
        }.call() ,
        cancelFunciton: () => handlerSendPort.send(_cancelCommand));
  }
}

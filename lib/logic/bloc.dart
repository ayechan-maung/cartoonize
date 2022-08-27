import 'package:cartoonize/service/network_service.dart';
import 'package:cartoonize/service/snapshot_response.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

class Bloc extends NetworkRepository {
  final controller = PublishSubject<SnapshotResponse>();
  Stream<SnapshotResponse> mvStream() => controller.stream;

  PublishSubject<double> progressController = PublishSubject<double>();
  Stream<double> progressStream() => progressController.stream;

  getMv({Map<String, dynamic>? param, FormData? fd}) async {
    SnapshotResponse snap = SnapshotResponse(data: null, status: Status.loading);
    controller.sink.add(snap);

    await fetch(
      params: param,
      fromData: fd,
      callBack: (SnapshotResponse snapshot) {
        print(snapshot.status);
        if (snapshot.hasData) {
          snap.data = snapshot.data;
          print('data ${snapshot.data}');
          if (!controller.isClosed) {
            controller.sink.add(snapshot);
          }
        } else {
          controller.sink.add(snapshot);
        }
      },
      progressCallback: (i) {
        var progress = i * 0.8;
        // print('progress->>> $i');
        progressController.sink.add(progress);
      },
      receiveProgress: (i) {
        print('receive progress--> $i');
      },
    );
  }

  dispose() {
    controller.close();
    progressController.close();
  }
}

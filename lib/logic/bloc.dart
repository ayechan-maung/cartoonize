import 'package:cartoonize/service/network_service.dart';
import 'package:cartoonize/service/snapshot_response.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

class Bloc extends NetworkRepository {
  final controller = PublishSubject<SnapshotResponse>();
  Stream<SnapshotResponse> mvStream() => controller.stream;

  PublishSubject<double> progressController = PublishSubject<double>();
  Stream<double> progressStream() => progressController.stream;

  var progress = 0.0;
  SnapshotResponse snap = SnapshotResponse();
  // this token for cancel request upload.
  CancelToken? cancelToken;

  getMv({Map<String, dynamic>? param, FormData? fd}) async {
    snap = SnapshotResponse(data: null, status: Status.loading);
    cancelToken = CancelToken();
    controller.sink.add(snap);

    await fetch(
      params: param,
      fromData: fd,
      cancelToken: cancelToken,
      callBack: (SnapshotResponse snapshot) {
        print(snapshot.status);
        if (snapshot.hasData) {
          snap.data = snapshot.data;
          if (!controller.isClosed) {
            controller.sink.add(snapshot);
          }
        } else {
          controller.sink.add(snapshot);
        }
      },
      progressCallback: (i) {
        progress = i * 0.8;
        // print('progress->>> $i');
        progressController.sink.add(progress);
      },
      receiveProgress: (i) {},
    );
  }

  cancelRequest() {
    if (cancelToken != null) {
      cancelToken!.cancel();
      progress = 0.0;
      snap = SnapshotResponse();
      progressController.sink.add(progress);
    }
  }

  dispose() {
    controller.close();
    progressController.close();
  }
}

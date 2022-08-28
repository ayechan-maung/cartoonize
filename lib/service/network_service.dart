import 'package:cartoonize/app_utils/app_const.dart';
import 'package:cartoonize/service/snapshot_response.dart';
import 'package:dio/dio.dart';

class NetworkRepository {
  Future<void> fetch(
      {Map<String, dynamic>? params,
      FormData? fromData,
      required CallBackFunction callBack,
      ProgressCallbackFunction? progressCallback,
      ReceiveProgress? receiveProgress,
      CancelToken? cancelToken}) async {
    try {
      BaseOptions options = BaseOptions();
      Response response;
      Dio dio = Dio(options);

      response = await dio.post(API,
          data: fromData,
          onSendProgress: (int count, int total) => progressCallback!(count / total),
          onReceiveProgress: (int count, int total) => receiveProgress!(count / total),
          cancelToken: cancelToken);
      print('status code --> ${response.statusCode}');
      print('fd==> $fromData');
      SnapshotResponse snapshot = SnapshotResponse();

      if (response.statusCode == 200) {
        snapshot.status = Status.data;
        snapshot.data = response.data;
      } else {
        snapshot.status = Status.error;
        snapshot.error = ErrorStatus.Unknown;
      }
      callBack(snapshot);
    } on DioError catch (e) {
      SnapshotResponse snapshot = SnapshotResponse();

      if (e.response != null) {
        if (e.response!.statusCode == 400) {
          snapshot.status = Status.error;
          snapshot.error = e.error;
          snapshot.data = e.response.toString();
        } else if (e.response!.statusCode == 500) {
          snapshot.status = Status.error;
          snapshot.data = 'Server Error';
        } else {
          snapshot.status = Status.error;
          snapshot.error = e.error;
        }
      }
      callBack(snapshot);
    }
  }
}

typedef CallBackFunction(SnapshotResponse response);
typedef ProgressCallbackFunction(double i);
typedef ReceiveProgress(double i);

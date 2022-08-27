enum ErrorStatus { NotFound, Unknown }

enum Status { error, loading, data, more, server }

class SnapshotResponse {
  dynamic data;
  dynamic error;
  Status? status;
  //to check status
  bool get inLoading => data == null;
  bool get hasData => data != null;
  bool get hasError => error != null;

  SnapshotResponse({this.data, this.error, this.status});
}

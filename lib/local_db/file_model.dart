const String tableImgFiles = 'cartoons';

class ImgFile {
  int? id;
  String? imageUrl;
  String? description;
  DateTime? dateTime;

  ImgFile({this.id, this.imageUrl, this.description, this.dateTime});

  ImgFile copyWith({
    int? id,
    String? imageUrl,
    String? description,
    DateTime? createdTime,
  }) =>
      ImgFile(
        id: id ?? this.id,
        imageUrl: imageUrl ?? this.imageUrl,
        description: description ?? this.description,
        dateTime: dateTime ?? this.dateTime,
      );

  ImgFile.fromJson(Map<String, Object?> json) {
    id = json[FieldsConst.id] as int;
    imageUrl = json[FieldsConst.imageUrl] as String;
    description = json[FieldsConst.description] as String;
    dateTime = DateTime.parse(json[FieldsConst.time] as String);
  }

  Map<String, Object?> toJson() => {
        FieldsConst.id: id,
        FieldsConst.imageUrl: imageUrl,
        FieldsConst.description: description,
        FieldsConst.time: dateTime!.toIso8601String(),
      };
}

class FieldsConst {
  static String id = '_id';
  static String imageUrl = 'imageUrl';
  static String description = 'description';
  static String time = 'time';

  static List<String> colField = [id, imageUrl, description, time];
}

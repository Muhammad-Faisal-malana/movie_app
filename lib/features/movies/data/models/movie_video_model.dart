class VideoModel {
  final String key;
  final String type;

  VideoModel({
    required this.key,
    required this.type,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      key: json['key'],
      type: json['type'],
    );
  }
}

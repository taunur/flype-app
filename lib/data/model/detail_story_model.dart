import 'dart:convert';

DetailStoryModel detailStoryModelFromJson(String str) =>
    DetailStoryModel.fromJson(json.decode(str));

String detailStoryModelToJson(DetailStoryModel data) =>
    json.encode(data.toJson());

class DetailStoryModel {
  bool error;
  String message;
  DetailStory story;

  DetailStoryModel({
    required this.error,
    required this.message,
    required this.story,
  });

  factory DetailStoryModel.fromJson(Map<String, dynamic> json) =>
      DetailStoryModel(
        error: json["error"],
        message: json["message"],
        story: DetailStory.fromJson(json["story"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "story": story.toJson(),
      };
}

class DetailStory {
  String? id;
  String? name;
  String? description;
  String? photoUrl;
  DateTime? createdAt;
  double? lat;
  double? lon;

  DetailStory({
    this.id,
    this.name,
    this.description,
    this.photoUrl,
    this.createdAt,
    this.lat,
    this.lon,
  });

  factory DetailStory.fromJson(Map<String, dynamic> json) => DetailStory(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        photoUrl: json["photoUrl"],
        createdAt: DateTime.parse(json["createdAt"]),
        lat: json["lat"]?.toDouble(),
        lon: json["lon"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "photoUrl": photoUrl,
        "createdAt": createdAt!.toIso8601String(),
        "lat": lat,
        "lon": lon,
      };
}

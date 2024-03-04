import 'package:json_annotation/json_annotation.dart';

part 'detail_story_model.g.dart';

@JsonSerializable()
class DetailStoryModel {
  final bool error;
  final String message;
  @JsonKey(name: 'story')
  final DetailStory story;

  DetailStoryModel({
    required this.error,
    required this.message,
    required this.story,
  });

  factory DetailStoryModel.fromJson(Map<String, dynamic> json) =>
      _$DetailStoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$DetailStoryModelToJson(this);
}

@JsonSerializable()
class DetailStory {
  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final DateTime createdAt;
  final double? lat;
  final double? lon;

  DetailStory({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    this.lat,
    this.lon,
  });

  factory DetailStory.fromJson(Map<String, dynamic> json) =>
      _$DetailStoryFromJson(json);

  Map<String, dynamic> toJson() => _$DetailStoryToJson(this);
}

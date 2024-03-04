import 'package:json_annotation/json_annotation.dart';

part 'list_story_model.g.dart';

@JsonSerializable()
class ListStoryModel {
  final bool error;
  final String message;
  @JsonKey(name: 'listStory')
  final List<ListStory> listStory;

  ListStoryModel({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory ListStoryModel.fromJson(json) => _$ListStoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListStoryModelToJson(this);
}

@JsonSerializable()
class ListStory {
  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final DateTime createdAt;
  final double? lat;
  final double? lon;

  ListStory({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    this.lat,
    this.lon,
  });

  factory ListStory.fromJson(Map<String, dynamic> json) =>
      _$ListStoryFromJson(json);

  Map<String, dynamic> toJson() => _$ListStoryToJson(this);
}

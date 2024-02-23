import 'package:flutter/material.dart';
import 'package:flype/data/model/list_story_model.dart';
import 'package:intl/intl.dart';

class StoryTimeProvider with ChangeNotifier {
  String formatCreatedAt(ListStory story) {
    Duration difference = DateTime.now().difference(story.createdAt!);
    
    // Jika lebih dari satu hari, tampilkan tanggal dan jam
    if (difference.inDays > 0) {
      return DateFormat('dd MMMM yyyy HH:mm', 'id_ID').format(story.createdAt!);
    } else {
      // Jika kurang dari satu hari, tampilkan hanya jam
      return DateFormat('HH:mm', 'id_ID').format(story.createdAt!);
    }
  }
}

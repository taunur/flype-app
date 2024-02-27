import 'package:flutter/material.dart';
import 'package:flype/data/api/story_service.dart';
import 'package:flype/data/db/auth_repository.dart';
import 'package:flype/data/model/list_story_model.dart';
import 'package:flype/data/utils/result_state.dart';
import 'package:logger/logger.dart';

class StoryProvider extends ChangeNotifier {
  final Logger logger = Logger();
  late String _token; 

  final AuthRepository _authRepository = AuthRepository();

  /// Metode untuk menyetel token saat login
  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  ResultState _state = ResultState.noData;

  List<ListStory> _allStories = [];
  List<ListStory> get allStories => _allStories;

  String _message = '';
  String get message => _message;

  ResultState get state => _state;

  Future<void> _getStory() async {
    try {
      _state = ResultState.loading;
      _message = '';
      notifyListeners();

      /// Mengambil token dari AuthRepository
      _token = (await _authRepository.getToken())!;

      final storyResult = await StoryServices().getAllStory(
        token: _token,
      );

      if (storyResult.isEmpty) {
        _state = ResultState.noData;
        _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        _allStories = storyResult;
      }
    } catch (e) {
      _state = ResultState.error;
      _message = 'Failed to load stories. Check your connection.';
      logger.e('Error loading stories: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await _getStory();
  }

  Future<void> getStory(String token) async {
    await _getStory();
  }

}

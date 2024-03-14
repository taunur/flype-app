import 'package:flutter/material.dart';
import 'package:flype/data/api/story_service.dart';
import 'package:flype/data/db/auth_repository.dart';
import 'package:flype/data/model/detail_story_model.dart';
import 'package:flype/data/utils/result_state.dart';
import 'package:logger/logger.dart';

class DetailStoryProvider extends ChangeNotifier {
  final Logger logger = Logger();
  late String _token;

  final AuthRepository _authRepository = AuthRepository();

  /// Metode untuk menyetel token saat login
  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  ResultState _state = ResultState.noData;

  DetailStoryModel? _detailStory;
  DetailStoryModel? get detailStory => _detailStory;

  String _message = '';
  String get message => _message;

  ResultState get state => _state;

  double _latitude = 0.0;
  double _longitude = 0.0;

  double get latitude => _latitude;
  double get longitude => _longitude;

  Future<void> _getDetailStory(String id) async {
    try {
      _state = ResultState.loading;
      _message = '';
      notifyListeners();

      /// Mengambil token dari AuthRepository
      _token = (await _authRepository.getToken())!;
      _detailStory =
          await StoryServices().getDetailStory(id: id, token: _token);

      _state = ResultState.hasData;
    } catch (e) {
      _state = ResultState.error;
      _message = 'Failed to load stories.';
      logger.e('Error loading stories: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> getStoryById(
    String id,
    String token,
  ) async {
    await _getDetailStory(id);
  }

  void setLatitude(double latitude) {
    _latitude = latitude;
    notifyListeners();
  }

  void setLongitude(double longitude) {
    _longitude = longitude;
    notifyListeners();
  }
}

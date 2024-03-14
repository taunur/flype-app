import 'package:flutter/material.dart';
import 'package:flype/data/api/connection_services.dart';
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

  final List<ListStory> _allStories = [];
  List<ListStory> get allStories => _allStories;

  String _message = '';
  String get message => _message;

  ResultState get state => _state;

  int? pageItems = 1;
  int sizeItems = 10;

  Future<void> _getStory({int? page, int? size}) async {
    try {
      if (pageItems == 1) {
        _state = ResultState.loading;
        _message = '';
        notifyListeners();
      }

      /// Memeriksa koneksi internet sebelum memanggil layanan untuk mengambil cerita
      final isConnected = await ConnectionServices().isInternetAvailable();
      if (!isConnected) {
        _state = ResultState.noConnection;
        _message = 'No Internet Connection';
        notifyListeners();
        return;
      }

      /// Mengambil token dari AuthRepository
      _token = (await _authRepository.getToken())!;

      final storyResult = await StoryServices().getAllStory(
        token: _token,
        page: page ?? pageItems,
        size: size ?? sizeItems,
      );

      if (storyResult.isEmpty) {
        _state = ResultState.noData;
        _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        if (pageItems == 1) {
          _allStories.clear();
        }
        _allStories.addAll(storyResult);
        if (storyResult.length < sizeItems) {
          pageItems = null;
        } else {
          pageItems = (page ?? pageItems)! + 1;
        }
      }
    } catch (e) {
      _state = ResultState.error;
      _message = 'Failed to load stories.';
      logger.e('Error loading stories: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    _allStories.clear();
    pageItems = 1;
    await _getStory();
  }

  Future<void> getStory(String token) async {
    await _getStory();
  }
}

import 'package:flutter/material.dart';

import '../core/exceptions/app_exception.dart';
import '../core/services/storage_service.dart';
import '../models/article_model.dart';
import '../repositories/article_repository.dart';

class NewsProvider extends ChangeNotifier {
  final ArticleRepository repository;
  final StorageService _storageService = StorageService();

  List<ArticleModel> _articles = [];
  List<int> _favoriteIds = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _searchQuery = '';
  String _currentUserEmail = '';

  NewsProvider({required this.repository});

  List<ArticleModel> get articles => _applySearch(_articles);
  List<ArticleModel> get allArticles => _articles;
  List<ArticleModel> get favoriteArticles =>
      _applySearch(_articles.where((e) => _favoriteIds.contains(e.id)).toList());
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  Future<void> initialize() async {
    await loadFavoritesByCurrentUser();
    await fetchArticles();
  }

  Future<void> loadFavoritesByCurrentUser() async {
    final user = await _storageService.getLoggedInUser();
    _currentUserEmail = (user?['email'] ?? '').toString();

    if (_currentUserEmail.isEmpty) {
      _favoriteIds = [];
    } else {
      _favoriteIds = await _storageService.getFavoriteIds(_currentUserEmail);
    }

    notifyListeners();
  }

  Future<void> fetchArticles() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final data = await repository.fetchArticles();

      if (_currentUserEmail.isNotEmpty) {
        _favoriteIds = await _storageService.getFavoriteIds(_currentUserEmail);
      } else {
        _favoriteIds = [];
      }

      _articles = data;
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (_) {
      _errorMessage = 'Không thể tải dữ liệu';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshArticles() async {
    await fetchArticles();
  }

  void searchArticles(String value) {
    _searchQuery = value.trim().toLowerCase();
    notifyListeners();
  }

  List<ArticleModel> _applySearch(List<ArticleModel> list) {
    if (_searchQuery.isEmpty) return list;
    return list
        .where((article) => article.title.toLowerCase().contains(_searchQuery))
        .toList();
  }

  Future<bool> toggleFavoriteById(int articleId) async {
    if (_currentUserEmail.isEmpty) return false;

    if (_favoriteIds.contains(articleId)) {
      _favoriteIds.remove(articleId);
    } else {
      _favoriteIds.add(articleId);
    }

    await _storageService.saveFavoriteIds(_currentUserEmail, _favoriteIds);
    notifyListeners();

    return _favoriteIds.contains(articleId);
  }

  bool isFavorite(int id) => _favoriteIds.contains(id);

  ArticleModel? getById(int id) {
    try {
      return _articles.firstWhere((element) => element.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> onUserChanged() async {
    _searchQuery = '';
    await loadFavoritesByCurrentUser();
    await fetchArticles();
  }
}
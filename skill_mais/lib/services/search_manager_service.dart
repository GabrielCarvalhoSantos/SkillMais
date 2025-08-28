// lib/services/search_manager_service.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SearchManagerService {
  static const String _recentSearchesKey = 'recent_searches';
  static const int _maxRecentSearches = 5;

  // Singleton pattern
  static final SearchManagerService _instance = SearchManagerService._internal();
  factory SearchManagerService() => _instance;
  SearchManagerService._internal();

  // Adicionar uma nova pesquisa
  Future<void> addRecentSearch(String categoryName) async {
    if (categoryName.trim().isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    List<String> recentSearches = await getRecentSearches();

    // Remove se já existe (para colocar no topo)
    recentSearches.remove(categoryName);
    
    // Adiciona no início da lista
    recentSearches.insert(0, categoryName);
    
    // Mantém apenas os últimos N itens
    if (recentSearches.length > _maxRecentSearches) {
      recentSearches = recentSearches.take(_maxRecentSearches).toList();
    }

    // Salva no SharedPreferences
    await prefs.setString(_recentSearchesKey, json.encode(recentSearches));
  }

  // Obter pesquisas recentes
  Future<List<String>> getRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? searchesJson = prefs.getString(_recentSearchesKey);
      
      if (searchesJson == null || searchesJson.isEmpty) {
        return [];
      }

      final List<dynamic> searchesList = json.decode(searchesJson);
      return searchesList.cast<String>();
    } catch (e) {
      print('Erro ao carregar pesquisas recentes: $e');
      return [];
    }
  }

  // Limpar todas as pesquisas recentes
  Future<void> clearRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_recentSearchesKey);
  }

  // Remover uma pesquisa específica
  Future<void> removeRecentSearch(String categoryName) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> recentSearches = await getRecentSearches();
    
    recentSearches.remove(categoryName);
    await prefs.setString(_recentSearchesKey, json.encode(recentSearches));
  }
}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'HomePage.dart';

class SavedArticlesProvider with ChangeNotifier {
  List<Article> _savedArticles = [];
  final CollectionReference _favoritesCollection = FirebaseFirestore.instance.collection('fav');

  List<Article> get savedArticles => _savedArticles;

  Future<void> fetchSavedArticles() async {
    // Fetch saved articles from Firestore
    try {
      QuerySnapshot snapshot = await _favoritesCollection.get();
      _savedArticles = snapshot.docs.map((doc) => Article.fromJson(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error fetching saved articles: $e');
    }

    notifyListeners();
  }

  Future<void> toggleSavedStatus(Article article) async {
    if (_savedArticles.contains(article)) {
      _savedArticles.remove(article);
      await _favoritesCollection.doc(article.title).delete();
    } else {
      _savedArticles.add(article);
      await _favoritesCollection.doc(article.title).set(article.toJson());
    }

    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'Detailspage.dart';
import 'Favoritesprovider.dart';
import 'HomePage.dart';
import 'dart:convert';

class RecentlyVisitedPage extends StatefulWidget {
  @override
  _RecentlyVisitedPageState createState() => _RecentlyVisitedPageState();
}

class _RecentlyVisitedPageState extends State<RecentlyVisitedPage> {
  List<Article> recentlyVisitedArticles = [];

  @override
  void initState() {
    super.initState();
    _loadRecentlyVisitedArticles();
  }

  // Load recently visited articles from SharedPreferences
  Future<void> _loadRecentlyVisitedArticles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? articleJsonList = prefs.getStringList('recently_visited_articles');

    if (articleJsonList != null) {
      setState(() {
        recentlyVisitedArticles = articleJsonList
            .map((jsonString) => Article.fromJson(json.decode(jsonString)))
            .toList();
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recently Visited Articles'),
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListView.builder(
          itemCount: recentlyVisitedArticles.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                title: Text(recentlyVisitedArticles[index].title),
                subtitle: Text(recentlyVisitedArticles[index].description),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsPage(article: recentlyVisitedArticles[index]),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

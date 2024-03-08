import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'Detailspage.dart';
import 'Favoritesprovider.dart';
import 'Recent.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isListView = true;
  late List<Article> articles;
  List<Article> recentlyVisitedArticles = [];

  @override
  void initState() {
    super.initState();
    Provider.of<SavedArticlesProvider>(context, listen: false).fetchSavedArticles();
    fetchNews();
  }
  Future<void> fetchNews() async {
    final apiKey = '4c60e841f3244284a0401b53b49b0ae1'; // Replace with your NewsAPI key
    final response =
    await http.get(Uri.parse('https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> articlesData = data['articles'];
      articles = articlesData.map((article) => Article.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load news');
    }

    setState(() {}); // Trigger a rebuild after fetching the data
  }
  Future<void> _addRecentlyVisitedArticle(Article article) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> articleJsonList = prefs.getStringList('recently_visited_articles') ?? [];

    // Convert the Article to JSON and add it to the list
    articleJsonList.add(json.encode(article.toJson()));

    // Save the updated list to SharedPreferences
    await prefs.setStringList('recently_visited_articles', articleJsonList);

    // Update the state to reflect the changes
    setState(() {
      recentlyVisitedArticles = articleJsonList
          .map((jsonString) => Article.fromJson(json.decode(jsonString)))
          .toList();
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toggle View Example'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(isListView ? Icons.grid_view : Icons.list),
            onPressed: () {
              setState(() {
                isListView = !isListView;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecentlyVisitedPage(),
                ),
              );
            },
          ),

        ],
      ),
      body: ChangeNotifierProvider(
        create: (context) => SavedArticlesProvider(),
        child: Column(
          children: [

            Expanded(
              child: isListView ? _buildListView() : _buildGridView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    return articles != null
        ? ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async{
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsPage(article: articles[index]),
              ),
            );
            await _addRecentlyVisitedArticle(articles[index]);
          },
          child: ChangeNotifierProvider.value(
            value: Provider.of<SavedArticlesProvider>(context),
            child: ArticleListItem(article: articles[index]),
          ),
        );
      },
    )
        : Center(child: CircularProgressIndicator());
  }

  Widget _buildGridView() {
    return articles != null
        ? GestureDetector(
      onTap: () {
        // Handle tap on the entire grid view, if needed
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(8.0),
        ),
        //margin: EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 2.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: articles.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsPage(article: articles[index]),
                  ),
                );
              },
              child: ChangeNotifierProvider.value(
                value: Provider.of<SavedArticlesProvider>(context),
                child: ArticleGridItem(article: articles[index]),
              ),
            );
          },
        ),
      ),
    )
        : Center(child: CircularProgressIndicator());
  }
}

class ArticleListItem extends StatelessWidget {
  final Article article;

  ArticleListItem({required this.article});

  @override
  Widget build(BuildContext context) {
    SavedArticlesProvider savedArticlesProvider = Provider.of<SavedArticlesProvider>(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(article.title),
        subtitle: Text(article.description),
        leading: Container(
          width: 80,
          height: 80,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              article.urlToImage,
              fit: BoxFit.cover,
            ),
          ),
        ),
        trailing: IconButton(
          icon: savedArticlesProvider.savedArticles.contains(article)
              ? Icon(Icons.favorite, color: Colors.red)
              : Icon(Icons.favorite_border),
          onPressed: () {
            savedArticlesProvider.toggleSavedStatus(article);
          },
        ),
      ),
    );
  }
}

class ArticleGridItem extends StatelessWidget {
  final Article article;

  ArticleGridItem({required this.article});

  @override
  Widget build(BuildContext context) {
    SavedArticlesProvider savedArticlesProvider = Provider.of<SavedArticlesProvider>(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(article: article),
          ),
        );
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
                child: Image.network(
                  article.urlToImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                article.title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: savedArticlesProvider.savedArticles.contains(article)
                      ? Icon(Icons.favorite, color: Colors.red)
                      : Icon(Icons.favorite_border),
                  onPressed: () {
                    savedArticlesProvider.toggleSavedStatus(article);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Article {
  final String title;
  final String description;
  final String urlToImage;
  final String url;

  Article({
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.url,
  });
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'urlToImage': urlToImage,
      'url':url,
    };
  }


  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      url:json['url']??'',
    );
  }
}

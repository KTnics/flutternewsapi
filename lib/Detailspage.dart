import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'HomePage.dart';

class DetailsPage extends StatelessWidget {

  final Article article;

  DetailsPage({required this.article});

  @override
  Widget build(BuildContext context) {
    void _copyToClipboard(String text) {
      Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Copied to clipboard'),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.network(
                article.urlToImage,
                fit: BoxFit.cover,
              ),
              ListTile(
                title: Text(
                  'Title',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(article.title),
              ),
              ListTile(
                title: Text(
                  'Description',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(article.description),
              ),
              ListTile(
                title: Text("readfull article",
                    style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(article.url),
                trailing: IconButton(
                  icon: Icon(Icons.content_copy),
                  onPressed: () => _copyToClipboard(article.url),
                ),


              )

            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fullstack_dart_client/fullstack_dart_client.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

import 'widgets/gap.dart';
import 'widgets/result_display.dart';

var client = Client('http://localhost:8080/')
  ..connectivityMonitor = FlutterConnectivityMonitor();

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String? _resultMessage;
  String? _errorMessage;
  List<Article>? _articles;

  final _titleTextController = TextEditingController();
  final _contentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  void _fetchArticles([String? keyword]) async {
    try {
      final articles = await client.article.getArticles(keyword: keyword);

      setState(() {
        _articles = articles;
      });
    } catch (error) {
      debugPrint('Error: $error');
      setState(() {
        _errorMessage = '$error';
      });
    }
  }

  void _addArticle() async {
    final title = _titleTextController.text;
    final content = _contentTextController.text;

    if (title.isEmpty || content.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a title and content.';
      });
      return;
    }

    final article = Article(
      title: title,
      content: content,
      createdAt: DateTime.now(),
    );

    try {
      final result = await client.article.addArticle(article);
      final articles = await client.article.getArticles();

      if (result) {
        setState(() {
          _errorMessage = null;
          _resultMessage = 'Article added :)';
          _articles = articles;
        });
      } else {
        throw Exception('Failed to add article');
      }
    } catch (error) {
      debugPrint('Error: $error');
      setState(() {
        _errorMessage = '$error';
      });
    }
  }

  void _deleteArticle(int id) async {
    try {
      final result = await client.article.deleteArticle(id);
      final articles = await client.article.getArticles();

      if (result) {
        setState(() {
          _errorMessage = null;
          _resultMessage = 'Article deleted :)';
          _articles = articles;
        });
      } else {
        throw Exception('Failed to delete article');
      }
    } catch (error) {
      debugPrint('Error: $error');
      setState(() {
        _errorMessage = '$error';
      });
    }
  }

  void _updateArticle(Article article) async {
    try {
      final result = await client.article.updateArticle(article);
      final articles = await client.article.getArticles();

      if (result) {
        setState(() {
          _errorMessage = null;
          _resultMessage = 'Article updated :)';
          _articles = articles;
        });
      } else {
        throw Exception('Failed to update article');
      }
    } catch (error) {
      debugPrint('Error: $error');
      setState(() {
        _errorMessage = '$error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _titleTextController,
                decoration: const InputDecoration(
                  hintText: 'Title of article',
                ),
              ),
              const Gap(),
              TextField(
                controller: _contentTextController,
                decoration: const InputDecoration(
                  hintText: 'Content of article',
                ),
              ),
              const Gap(),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addArticle,
                  child: const Text('Send to Server'),
                ),
              ),
              const Gap(),
              ResultDisplay(
                resultMessage: _resultMessage,
                errorMessage: _errorMessage,
                articles: _articles,
                deleteArticle: _deleteArticle,
                updateArticle: _updateArticle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

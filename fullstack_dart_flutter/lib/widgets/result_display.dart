import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fullstack_dart_client/fullstack_dart_client.dart';
import 'package:fullstack_dart_flutter/widgets/gap.dart';

class ResultDisplay extends StatelessWidget {
  final String? resultMessage;
  final String? errorMessage;
  final List<Article>? articles;
  final Function(int id) deleteArticle;
  final Function(Article article) updateArticle;

  const ResultDisplay({
    super.key,
    this.resultMessage,
    this.errorMessage,
    this.articles,
    required this.deleteArticle,
    required this.updateArticle,
  });

  @override
  Widget build(BuildContext context) {
    editArticleDialog(Article article) {
      var titleController = TextEditingController();
      var contentController = TextEditingController();

      titleController.text = article.title;
      contentController.text = article.content;

      showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.8),
        builder: (context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Title'),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: 'Enter title',
                    ),
                  ),
                  const Gap(),
                  const Text('Content'),
                  TextField(
                    controller: contentController,
                    decoration: const InputDecoration(
                      hintText: 'Enter description',
                    ),
                  ),
                  const Gap(),
                  ElevatedButton(
                    onPressed: () {
                      if (article != null) {
                        article.title = titleController.text;
                        article.content = contentController.text;
                        updateArticle(article);
                      }
                    },
                    child: const Text('Update Article'),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    showArticleDialog(Article article) {
      showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.8),
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  const Gap(),
                  Text(
                    article.content,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    String? text;
    Color backgroundColor;
    if (errorMessage != null) {
      backgroundColor = Colors.red;
      text = errorMessage!;
    } else if (resultMessage != null) {
      backgroundColor = Colors.green;
      text = resultMessage!;
    } else {
      backgroundColor = Colors.grey[300]!;
      text = null;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (text != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: backgroundColor,
            child: Center(child: Text(text)),
          ),
        if (articles != null)
          for (var article in articles!)
            GestureDetector(
              onTap: () => showArticleDialog(article),
              child: Slidable(
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        deleteArticle(article.id!);
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                    SlidableAction(
                      onPressed: (context) {
                        editArticleDialog(article);
                      },
                      backgroundColor: Colors.lightBlue,
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(article.title),
                  subtitle: Text(article.content),
                ),
              ),
            ),
      ],
    );
  }
}

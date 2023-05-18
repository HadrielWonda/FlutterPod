import 'package:serverpod/serverpod.dart';

import '../generated/article.dart';

class ArticleEndpoint extends Endpoint {
  Future<List<Article>> getArticles(Session session, {String? keyword}) async {
    final articles = Article.find(
      session,
      where: (table) => keyword != null && keyword.isNotEmpty
          ? table.title.ilike('%$keyword%')
          : Constant(true),
    );

    return articles;
  }

  Future<bool> addArticle(Session session, Article article) async {
    try {
      await Article.insert(session, article);

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateArticle(Session session, Article article) async {
    final result = await Article.update(session, article);

    return result;
  }

  Future<bool> deleteArticle(Session session, int id) async {
    final result = await Article.delete(
      session,
      where: (table) => table.id.equals(id),
    );

    return result == 1;
  }
}

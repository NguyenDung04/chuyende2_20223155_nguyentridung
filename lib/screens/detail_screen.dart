import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/utils/date_helper.dart';
import '../models/article_model.dart';
import '../providers/news_provider.dart';

class DetailScreen extends StatelessWidget {
  final ArticleModel article;

  const DetailScreen({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, provider, _) {
        final currentArticle = provider.getById(article.id) ?? article;
        final bool isFavorite = provider.isFavorite(article.id);

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: const Color(0xFF6D5DF6),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        currentArticle.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey.shade300,
                          child: const Center(
                            child: Icon(Icons.broken_image, size: 60),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.15),
                              Colors.black.withOpacity(0.45),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: IconButton(
                      onPressed: () async {
                        final bool newState =
                        await provider.toggleFavoriteById(article.id);

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              newState
                                  ? 'Đã thêm vào yêu thích'
                                  : 'Đã xóa khỏi yêu thích',
                            ),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: isFavorite ? Colors.redAccent : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Container(
                  transform: Matrix4.translationValues(0, -18, 0),
                  decoration: const BoxDecoration(
                    color: Color(0xfff7f8fc),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentArticle.title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            height: 1.35,
                            color: Color(0xFF1F1F39),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEDE9FF),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today_rounded,
                                    size: 14,
                                    color: Color(0xFF6D5DF6),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    DateHelper.formatDate(currentArticle.publishedAt),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF6D5DF6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Text(
                            currentArticle.content * 3,
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.8,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final bool newState =
                              await provider.toggleFavoriteById(article.id);

                              if (!context.mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    newState
                                        ? 'Đã thêm vào yêu thích'
                                        : 'Đã xóa khỏi yêu thích',
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6D5DF6),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                            ),
                            label: Text(
                              isFavorite ? 'Bỏ yêu thích' : 'Thêm vào yêu thích',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

extension RepeatString on String {
  String operator *(int times) {
    return List.generate(times, (_) => this).join('\n\n');
  }
}
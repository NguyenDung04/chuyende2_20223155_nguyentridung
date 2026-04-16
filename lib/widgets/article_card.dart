import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/utils/date_helper.dart';
import '../models/article_model.dart';
import '../providers/news_provider.dart';
import '../screens/detail_screen.dart';

class ArticleCard extends StatelessWidget {
  final ArticleModel article;

  const ArticleCard({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, provider, _) {
        final bool isFavorite = provider.isFavorite(article.id);

        return Container(
          margin: const EdgeInsets.only(bottom: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailScreen(article: article),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                        child: Image.network(
                          article.imageUrl,
                          width: double.infinity,
                          height: 210,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: double.infinity,
                            height: 210,
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: Icon(
                                Icons.broken_image_rounded,
                                size: 54,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.92),
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
                                DateHelper.formatDate(article.publishedAt),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1F1F39),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: GestureDetector(
                          onTap: () async {
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
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 220),
                                transitionBuilder: (child, animation) =>
                                    ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    ),
                                child: Icon(
                                  isFavorite
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  key: ValueKey(isFavorite),
                                  color: isFavorite
                                      ? Colors.red
                                      : Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            height: 1.35,
                            color: Color(0xFF1F1F39),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          article.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F2FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Xem chi tiết',
                                style: TextStyle(
                                  color: Color(0xFF6D5DF6),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.grey.shade500,
                              size: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
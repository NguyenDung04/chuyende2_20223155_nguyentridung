import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/news_provider.dart';
import '../widgets/article_card.dart';
import '../widgets/empty_view.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, provider, _) {
        final favorites = provider.favoriteArticles;

        return CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bài viết yêu thích',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F1F39),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Lưu lại những bài viết bạn quan tâm để xem lại bất cứ lúc nào',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDE9FF),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            '${favorites.length} bài yêu thích',
                            style: const TextStyle(
                              color: Color(0xFF6D5DF6),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            favorites.isEmpty
                ? const SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyView(
                icon: Icons.favorite_border,
                title: 'Chưa có bài yêu thích',
                message:
                'Hãy nhấn vào biểu tượng trái tim ở danh sách tin tức để lưu bài viết bạn thích',
              ),
            )
                : SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return ArticleCard(article: favorites[index]);
                  },
                  childCount: favorites.length,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
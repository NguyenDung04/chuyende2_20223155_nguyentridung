import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/news_provider.dart';
import '../widgets/article_card.dart';
import '../widgets/empty_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.allArticles.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (provider.errorMessage.isNotEmpty && provider.allArticles.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(provider.errorMessage),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            );
          });

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.wifi_off_rounded,
                      size: 60,
                      color: Color(0xFF6D5DF6),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Không thể tải dữ liệu',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F1F39),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      provider.errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: provider.fetchArticles,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6D5DF6),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Thử lại',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return RefreshIndicator(
          color: const Color(0xFF6D5DF6),
          onRefresh: provider.refreshArticles,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Khám phá tin tức',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F1F39),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Cập nhật bài viết mới nhất và tìm kiếm nội dung bạn quan tâm',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            provider.searchArticles(value);
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            hintText: 'Tìm kiếm theo tiêu đề bài viết...',
                            hintStyle: const TextStyle(
                              color: Color(0xFF98A2B3),
                              fontSize: 14,
                            ),
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              color: Color(0xFF7A5AF8),
                            ),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                              onPressed: () {
                                _searchController.clear();
                                provider.searchArticles('');
                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.close_rounded,
                                color: Color(0xFF667085),
                              ),
                            )
                                : null,
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 18,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
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
                              '${provider.articles.length} bài viết',
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
              provider.articles.isEmpty
                  ? const SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyView(
                  icon: Icons.article_outlined,
                  title: 'Không tìm thấy bài viết',
                  message: 'Hãy thử từ khóa khác để tìm nội dung phù hợp',
                ),
              )
                  : SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final article = provider.articles[index];
                      return ArticleCard(article: article);
                    },
                    childCount: provider.articles.length,
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
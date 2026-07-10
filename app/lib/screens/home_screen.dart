import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/collection_repository.dart';
import '../models/collection_item.dart';
import '../providers/repository_providers.dart';
import '../widgets/rating_stars.dart';
import 'deco/sticker_canvas_screen.dart';
import 'detail/item_detail_screen.dart';
import 'punch/image_select_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  ItemSortOrder _sortBy = ItemSortOrder.newest;
  late Future<List<CollectionItem>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = _load();
  }

  Future<List<CollectionItem>> _load() {
    return ref
        .read(collectionRepositoryProvider)
        .listItems(sortBy: _sortBy);
  }

  void _reload() {
    setState(() {
      _itemsFuture = _load();
    });
  }

  Future<void> _openPunchFlow() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ImageSelectScreen()));
    if (mounted) _reload();
  }

  Future<void> _openItem(CollectionItem item) async {
    final deleted = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => ItemDetailScreen(item: item)),
    );
    if (deleted == true && mounted) _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('퐁당'),
        actions: [
          PopupMenuButton<ItemSortOrder>(
            tooltip: '정렬',
            icon: const Icon(Icons.sort),
            onSelected: (value) => setState(() {
              _sortBy = value;
              _reload();
            }),
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: ItemSortOrder.newest,
                child: Text('최신순'),
              ),
              PopupMenuItem(
                value: ItemSortOrder.ratingDesc,
                child: Text('별점순'),
              ),
            ],
          ),
          IconButton(
            tooltip: '다꾸 캔버스 (T203 검증)',
            icon: const Icon(Icons.auto_awesome_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const StickerCanvasScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<CollectionItem>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data!;
          if (items.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  '아직 등록된 도감이 없습니다.\n오른쪽 아래 + 버튼으로 첫 수집을 펀치해보세요.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => _reload(),
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.78,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _CollectionCard(
                  item: item,
                  onTap: () => _openItem(item),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openPunchFlow,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _CollectionCard extends StatelessWidget {
  final CollectionItem item;
  final VoidCallback onTap;
  const _CollectionCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.file(
                File(item.thumbnailPath),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const ColoredBox(
                      color: Color(0xFFEFEFEF),
                      child: Icon(Icons.broken_image_outlined),
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 6,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'No.${item.docNumber.toString().padLeft(3, '0')}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  RatingStars(rating: item.rating, size: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

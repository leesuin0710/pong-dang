import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/collection_repository.dart';
import '../models/collection_item.dart';
import '../providers/repository_providers.dart';
import '../widgets/collection_grid_view.dart';
import 'calendar/calendar_screen.dart';
import 'deco/sticker_canvas_screen.dart';
import 'detail/item_detail_screen.dart';
import 'folder/folder_list_screen.dart';
import 'punch/image_select_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _tabIndex = 0;
  ItemSortOrder _sortBy = ItemSortOrder.newest;
  late Future<List<CollectionItem>> _itemsFuture;
  // Bumped whenever items change so the folder tab (kept alive by
  // IndexedStack) is recreated with a fresh key and reloads its stats —
  // it has no other way to know an item moved in/out of a folder while
  // it sat in the background.
  int _folderTabToken = 0;

  @override
  void initState() {
    super.initState();
    _itemsFuture = _load();
  }

  Future<List<CollectionItem>> _load() {
    return ref.read(collectionRepositoryProvider).listItems(sortBy: _sortBy);
  }

  void _reload() {
    setState(() {
      _itemsFuture = _load();
      _folderTabToken++;
    });
  }

  Future<void> _openPunchFlow() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ImageSelectScreen()));
    if (mounted) _reload();
  }

  Future<void> _openItem(CollectionItem item) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => ItemDetailScreen(item: item)),
    );
    if (changed == true && mounted) _reload();
  }

  @override
  Widget build(BuildContext context) {
    final isCollectionTab = _tabIndex == 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('퐁당'),
        actions: [
          if (isCollectionTab) ...[
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
                  MaterialPageRoute(
                    builder: (_) => const StickerCanvasScreen(),
                  ),
                );
              },
            ),
          ],
        ],
      ),
      body: IndexedStack(
        index: _tabIndex,
        children: [
          FutureBuilder<List<CollectionItem>>(
            future: _itemsFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return CollectionGridView(
                items: snapshot.data!,
                emptyMessage: '아직 등록된 도감이 없습니다.\n오른쪽 아래 + 버튼으로 첫 수집을 펀치해보세요.',
                onTapItem: _openItem,
                onRefresh: () async => _reload(),
              );
            },
          ),
          FolderListScreen(key: ValueKey(_folderTabToken)),
          const CalendarScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (index) => setState(() => _tabIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.grid_view), label: '도감'),
          NavigationDestination(icon: Icon(Icons.folder_outlined), label: '폴더'),
          NavigationDestination(icon: Icon(Icons.calendar_month_outlined), label: '달력'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openPunchFlow,
        child: const Icon(Icons.add),
      ),
    );
  }
}

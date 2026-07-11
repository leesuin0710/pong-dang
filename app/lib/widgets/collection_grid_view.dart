import 'dart:io';

import 'package:flutter/material.dart';

import '../models/collection_item.dart';
import 'rating_stars.dart';

/// Shared 2-column grid used by both the home "도감" tab and folder detail
/// screens — same card look wherever a list of items is shown.
class CollectionGridView extends StatelessWidget {
  final List<CollectionItem> items;
  final String emptyMessage;
  final ValueChanged<CollectionItem> onTapItem;
  final Future<void> Function()? onRefresh;

  const CollectionGridView({
    super.key,
    required this.items,
    required this.emptyMessage,
    required this.onTapItem,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(emptyMessage, textAlign: TextAlign.center),
        ),
      );
    }
    final grid = GridView.builder(
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
        return _CollectionCard(item: item, onTap: () => onTapItem(item));
      },
    );
    if (onRefresh == null) return grid;
    return RefreshIndicator(onRefresh: onRefresh!, child: grid);
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

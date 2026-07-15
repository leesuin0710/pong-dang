import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/deco_entry.dart';

sealed class DecoEntryPickResult {
  const DecoEntryPickResult();
}

class DecoEntryPickOpen extends DecoEntryPickResult {
  final DecoEntry entry;
  const DecoEntryPickOpen(this.entry);
}

class DecoEntryPickCreateNew extends DecoEntryPickResult {
  const DecoEntryPickCreateNew();
}

/// Bottom sheet listing a day's 다꾸 entries (F7.4) — a day can hold
/// several pages, so tapping a date with existing entries shows this
/// picker instead of jumping straight into one.
Future<DecoEntryPickResult?> showDecoEntryListSheet(
  BuildContext context, {
  required DateTime date,
  required List<DecoEntry> entries,
}) {
  return showModalBottomSheet<DecoEntryPickResult?>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) {
      return SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  DateFormat('yyyy년 M월 d일').format(date),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              for (final entry in entries)
                ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.auto_awesome)),
                  title: Text(DateFormat('HH:mm').format(entry.createdAt)),
                  onTap: () => Navigator.of(
                    context,
                  ).pop(DecoEntryPickOpen(entry)),
                ),
              ListTile(
                leading: const Icon(Icons.add_circle_outline),
                title: const Text('+ 새 다꾸 추가'),
                onTap: () =>
                    Navigator.of(context).pop(const DecoEntryPickCreateNew()),
              ),
            ],
          ),
        ),
      );
    },
  );
}

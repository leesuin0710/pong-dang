import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../models/deco_entry.dart';
import '../../providers/repository_providers.dart';

/// A single 다꾸 page for [date]. If [entry] is null, nothing has been
/// persisted yet — opening the calendar day is not itself a save, and
/// neither is tapping "저장" with no content: an empty page is nothing
/// worth keeping, so the button only does something once T402 lets the
/// user actually place a sticker/text (which flips [_hasUnsavedChanges]).
class DecoSpaceScreen extends StatefulWidget {
  final DateTime date;
  final DecoEntry? entry;
  const DecoSpaceScreen({super.key, required this.date, this.entry});

  @override
  State<DecoSpaceScreen> createState() => _DecoSpaceScreenState();
}

class _DecoSpaceScreenState extends State<DecoSpaceScreen> {
  late DecoEntry? _entry = widget.entry;
  bool _saving = false;

  // T402 will set this to true whenever a sticker/text placement changes.
  // Nothing in this screen can create a change yet, so "저장" stays
  // disabled for the whole T401 stub.
  bool _hasUnsavedChanges = false;

  Future<void> _save(WidgetRef ref) async {
    setState(() => _saving = true);
    try {
      _entry ??= await ref
          .read(decoRepositoryProvider)
          .createEntry(widget.date);
      if (!mounted) return;
      setState(() => _hasUnsavedChanges = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('저장됨')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(DateFormat('yyyy년 M월 d일').format(widget.date)),
            actions: [
              TextButton(
                onPressed: (_hasUnsavedChanges && !_saving)
                    ? () => _save(ref)
                    : null,
                child: const Text('저장'),
              ),
            ],
          ),
          body: const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                '스티커·텍스트를 배치하는 다꾸 캔버스는 T402에서 구현 예정입니다.',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }
}

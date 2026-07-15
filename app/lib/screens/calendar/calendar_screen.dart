import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/deco_entry.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/deco_entry_list_sheet.dart';
import '../deco/deco_space_screen.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  static const _weekdayLabels = ['일', '월', '화', '수', '목', '금', '토'];
  static const _monthLabels = [
    '1월', '2월', '3월', '4월', '5월', '6월',
    '7월', '8월', '9월', '10월', '11월', '12월',
  ];

  late DateTime _visibleMonth = _monthAnchor(DateTime.now());
  late Future<Map<String, List<DecoEntry>>> _entriesFuture;

  static DateTime _monthAnchor(DateTime d) => DateTime(d.year, d.month, 1);
  static bool _isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  void initState() {
    super.initState();
    _entriesFuture = _load();
  }

  Future<Map<String, List<DecoEntry>>> _load() {
    return ref
        .read(decoRepositoryProvider)
        .listEntriesGroupedByDateInMonth(_visibleMonth);
  }

  void _changeMonth(int delta) {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + delta, 1);
      _entriesFuture = _load();
    });
  }

  void _goToToday() {
    setState(() {
      _visibleMonth = _monthAnchor(DateTime.now());
      _entriesFuture = _load();
    });
  }

  void _reload() {
    setState(() {
      _entriesFuture = _load();
    });
  }

  List<DateTime> _buildGridDates() {
    final first = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
    final daysInMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1, 0).day;
    final leadingBlanks = first.weekday % 7; // Sun weekday=7 -> 0 blanks

    final dates = <DateTime>[
      for (var i = leadingBlanks; i > 0; i--) first.subtract(Duration(days: i)),
      for (var d = 1; d <= daysInMonth; d++) DateTime(_visibleMonth.year, _visibleMonth.month, d),
    ];
    while (dates.length % 7 != 0) {
      dates.add(dates.last.add(const Duration(days: 1)));
    }
    return dates;
  }

  Future<void> _openDecoSpace(DateTime date, {DecoEntry? entry}) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => DecoSpaceScreen(date: date, entry: entry),
      ),
    );
    // Only reload if something was actually saved — opening an empty day
    // and backing out shouldn't make it show up on the calendar.
    if (saved == true && mounted) _reload();
  }

  Future<void> _onDayTap(DateTime date, List<DecoEntry> entries) async {
    if (entries.isEmpty) {
      await _openDecoSpace(date);
      return;
    }

    final result = await showDecoEntryListSheet(
      context,
      date: date,
      entries: entries,
    );
    if (result == null || !mounted) return;

    if (result is DecoEntryPickOpen) {
      await _openDecoSpace(date, entry: result.entry);
    } else {
      await _openDecoSpace(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gridDates = _buildGridDates();
    final today = DateTime.now();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              IconButton(
                onPressed: () => _changeMonth(-1),
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: Text(
                  '${_visibleMonth.year}년 ${_monthLabels[_visibleMonth.month - 1]}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                onPressed: () => _changeMonth(1),
                icon: const Icon(Icons.chevron_right),
              ),
              TextButton(onPressed: _goToToday, child: const Text('오늘')),
            ],
          ),
        ),
        Row(
          children: [
            for (final label in _weekdayLabels)
              Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
          ],
        ),
        Expanded(
          child: FutureBuilder<Map<String, List<DecoEntry>>>(
            future: _entriesFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final entriesByDate = snapshot.data!;
              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                ),
                itemCount: gridDates.length,
                itemBuilder: (context, index) {
                  final date = gridDates[index];
                  final entries =
                      entriesByDate[DecoEntry.dateKey(date)] ?? const [];
                  final isCurrentMonth = date.month == _visibleMonth.month;
                  final isToday = _isSameDate(date, today);
                  return _DayCell(
                    date: date,
                    entryCount: entries.length,
                    dimmed: !isCurrentMonth,
                    highlighted: isToday,
                    onTap: () => _onDayTap(date, entries),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  final DateTime date;
  final int entryCount;
  final bool dimmed;
  final bool highlighted;
  final VoidCallback onTap;

  const _DayCell({
    required this.date,
    required this.entryCount,
    required this.dimmed,
    required this.highlighted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: highlighted ? primary.withValues(alpha: 0.15) : null,
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${date.day}',
              style: TextStyle(
                color: dimmed ? Colors.grey.shade400 : null,
                fontWeight: highlighted ? FontWeight.bold : null,
              ),
            ),
            if (entryCount > 0)
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(color: primary, shape: BoxShape.circle),
              ),
            if (entryCount > 1)
              Text(
                '+${entryCount - 1}',
                style: TextStyle(fontSize: 9, color: primary),
              ),
          ],
        ),
      ),
    );
  }
}

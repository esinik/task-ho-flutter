import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/providers/calendar_provider.dart';
import '../../core/providers/providers.dart';
import '../../core/models/weekly_task.dart';
import '../../core/logging/app_logger.dart';
import '../../core/repo/calendar.dart';
import '../../../l10n/app_localizations.dart';
import 'widgets/note_detail_dialog.dart';

// Customer filter for ListView
final calendarListCustomerFilterProvider = StateProvider<String?>((_) => null);

/// Main calendar screen with Takvim/Liste tabs
class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLogger().logScreenView('Calendar');
    final viewMode = ref.watch(calendarViewModeProvider);

    return Column(
      children: [
        // Tab bar: Takvim / Liste
        _CalendarTabBar(),
        const Divider(height: 1),
        // Content based on selected tab
        Expanded(
          child: viewMode == CalendarViewMode.calendar ? const _CalendarTableView() : const _CalendarListView(),
        ),
      ],
    );
  }
}

class _CalendarTabBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewMode = ref.watch(calendarViewModeProvider);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _TabButton(
            label: l10n.calendarView,
            icon: Icons.calendar_month,
            isSelected: viewMode == CalendarViewMode.calendar,
            onTap: () {
              ref.read(calendarViewModeProvider.notifier).state = CalendarViewMode.calendar;
              AppLogger().logButtonClick('CalendarView_Table', 'Calendar');
            },
          ),
          const SizedBox(width: 8),
          _TabButton(
            label: l10n.listView,
            icon: Icons.list,
            isSelected: viewMode == CalendarViewMode.list,
            onTap: () {
              ref.read(calendarViewModeProvider.notifier).state = CalendarViewMode.list;
              AppLogger().logButtonClick('CalendarView_List', 'Calendar');
            },
          ),
          const Spacer(),
          // Add note button (only in calendar view)
          ...viewMode == CalendarViewMode.calendar
              ? [
                  ElevatedButton.icon(
                    style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.blue)),
                    onPressed: () async {
                      AppLogger().logButtonClick('AddNote', 'Calendar');
                      final result = await NoteDetailDialog.show(context);
                      if (result == null) return;

                      if (result.customer == null || result.date == null) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.customerAndDateRequired)),
                          );
                        }
                        return;
                      }

                      // Save note
                      try {
                        final repo = ref.read(calendarRepositoryProvider);
                        final dateStr =
                            '${result.date!.year}-${result.date!.month.toString().padLeft(2, '0')}-${result.date!.day.toString().padLeft(2, '0')}';

                        await repo.createNote(
                          customer: result.customer!,
                          title: result.title,
                          date: dateStr,
                          notes: result.notes,
                          isCompleted: result.isCompleted,
                        );

                        // Refresh calendar
                        ref.invalidate(weeklyCalendarProvider);

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.noteAdded)),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Hata: $e')),
                          );
                        }
                      }
                    },
                    icon: const Icon(
                      Icons.add,
                      size: 18,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Not Ekle',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ]
              : [],
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Calendar table view with weekly grid
class _CalendarTableView extends ConsumerWidget {
  const _CalendarTableView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyData = ref.watch(weeklyCalendarProvider);
    final currentWeekStart = ref.watch(currentWeekStartProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Column(
        children: [
          // Week navigation
          _WeekNavigationBar(currentWeekStart: currentWeekStart),
          const Divider(height: 1),
          // Calendar table
          Expanded(
            child: weeklyData.when(
              data: (data) => _CalendarTable(data: data),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => _CalendarTable(
                data: WeeklyCalendarData(
                  startDate: currentWeekStart,
                  endDate:
                      DateTime.parse(currentWeekStart).add(const Duration(days: 6)).toIso8601String().substring(0, 10),
                  notes: {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekNavigationBar extends ConsumerWidget {
  final String currentWeekStart;

  const _WeekNavigationBar({required this.currentWeekStart});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startDate = DateTime.parse(currentWeekStart);
    final endDate = startDate.add(const Duration(days: 6));
    final dateFormat = DateFormat('d MMMM yyyy', 'tr_TR');

    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              final newStart = startDate.subtract(const Duration(days: 7));
              ref.read(currentWeekStartProvider.notifier).state =
                  '${newStart.year}-${newStart.month.toString().padLeft(2, '0')}-${newStart.day.toString().padLeft(2, '0')}';
              AppLogger().logButtonClick('PreviousWeek', 'Calendar');
            },
            tooltip: 'Önceki hafta',
          ),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: startDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                  locale: const Locale('tr', 'TR'),
                  helpText: 'Hafta seçin',
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Colors.blue,
                          onPrimary: Colors.white,
                          surface: Colors.white,
                          onSurface: Colors.black87,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  // Calculate Monday of the selected week
                  final day = picked.weekday; // 1=Mon, 7=Sun
                  final monday = picked.subtract(Duration(days: day - 1));
                  ref.read(currentWeekStartProvider.notifier).state =
                      '${monday.year}-${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';
                  AppLogger().logButtonClick('DatePicker', 'Calendar');
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 20,
                      color: Colors.blue[700],
                    ),
                    const SizedBox(width: 12),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${dateFormat.format(startDate)} - ${dateFormat.format(endDate)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Tarih seçmek için tıklayın',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.arrow_drop_down_rounded,
                      size: 24,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              final newStart = startDate.add(const Duration(days: 7));
              ref.read(currentWeekStartProvider.notifier).state =
                  '${newStart.year}-${newStart.month.toString().padLeft(2, '0')}-${newStart.day.toString().padLeft(2, '0')}';
              AppLogger().logButtonClick('NextWeek', 'Calendar');
            },
            tooltip: 'Sonraki hafta',
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: () {
              final now = DateTime.now();
              final monday = now.subtract(Duration(days: (now.weekday - 1) % 7));
              ref.read(currentWeekStartProvider.notifier).state =
                  '${monday.year}-${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';
              AppLogger().logButtonClick('TodayWeek', 'Calendar');
            },
            icon: const Icon(Icons.today),
            label: const Text('Bu hafta'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarTable extends ConsumerWidget {
  final WeeklyCalendarData data;

  const _CalendarTable({required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customersAsync = ref.watch(customerListProvider);

    return customersAsync.when(
      data: (customers) {
        final customerNames = customers.map((c) => c.name).toList();
        if (customerNames.isEmpty) {
          return const Center(child: Text('Müşteri bulunamadı'));
        }

        // Generate 7 days starting from Monday
        final startDate = DateTime.parse(data.startDate);
        final weekDays = List.generate(7, (i) => startDate.add(Duration(days: i)));
        final today = DateTime.now();
        final todayStr =
            '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: constraints.maxWidth,
                    minHeight: constraints.maxHeight,
                  ),
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(const Color(0xFFE3F2FD)),
                    columnSpacing: 0,
                    horizontalMargin: 0,
                    dataRowMinHeight: 80,
                    dataRowMaxHeight: double.infinity,
                    border: TableBorder.all(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                    columns: [
                      DataColumn(
                        label: Container(
                          width: 120,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          child: const Text('Müşteriler', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      ...weekDays.map((day) {
                        final dayStr =
                            '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
                        final isToday = dayStr == todayStr;
                        final dayName = DateFormat('EEEE', 'tr_TR').format(day);
                        final dayDate = DateFormat('d MMM', 'tr_TR').format(day);

                        return DataColumn(
                          label: Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              decoration: isToday
                                  ? BoxDecoration(
                                      color: Colors.yellow[100],
                                    )
                                  : null,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    dayName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isToday ? Colors.orange[800] : null,
                                    ),
                                  ),
                                  Text(
                                    dayDate,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isToday ? Colors.orange[800] : Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                    rows: customerNames.map((customer) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Container(
                              width: 120,
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              child: Text(
                                customer,
                                style: const TextStyle(fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          ...weekDays.map((day) {
                            final dayStr =
                                '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
                            final notesForDay = data.notes[customer]?[dayStr] ?? [];

                            return DataCell(
                              _CalendarCell(
                                customer: customer,
                                date: dayStr,
                                notes: notesForDay,
                              ),
                            );
                          }),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Müşteriler yüklenemedi: $e')),
    );
  }
}

class _CalendarCell extends StatelessWidget {
  final String customer;
  final String date;
  final List<WeeklyNote> notes;

  const _CalendarCell({
    required this.customer,
    required this.date,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      constraints: const BoxConstraints(minHeight: 80),
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...notes.map((note) => _NoteCard(note: note, customer: customer)),
        ],
      ),
    );
  }
}

class _NoteCard extends ConsumerWidget {
  final WeeklyNote note;
  final String customer;

  const _NoteCard({required this.note, required this.customer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDone = note.isCompleted;

    return InkWell(
      onTap: () async {
        // Parse date from note.id or use a date field if available
        final dateMatch = RegExp(r'(\d{4})-(\d{2})-(\d{2})').firstMatch(note.id);
        DateTime? noteDate;
        if (dateMatch != null) {
          noteDate = DateTime(
            int.parse(dateMatch.group(1)!),
            int.parse(dateMatch.group(2)!),
            int.parse(dateMatch.group(3)!),
          );
        }

        final result = await NoteDetailDialog.show(
          context,
          initial: NoteFormResult(
            customer: customer,
            title: note.title,
            date: noteDate,
            notes: note.notes.isEmpty ? null : note.notes,
            isCompleted: note.isCompleted,
          ),
        );

        if (result == null) return;

        if (result.customer == null || result.date == null) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Müşteri ve tarih zorunludur')),
            );
          }
          return;
        }

        try {
          final repo = ref.read(calendarRepositoryProvider);
          final dateStr =
              '${result.date!.year}-${result.date!.month.toString().padLeft(2, '0')}-${result.date!.day.toString().padLeft(2, '0')}';

          await repo.updateNote(
            id: note.id,
            customer: result.customer!,
            title: result.title,
            date: dateStr,
            notes: result.notes,
            isCompleted: result.isCompleted,
          );

          ref.invalidate(weeklyCalendarProvider);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Not güncellendi')),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Hata: $e')),
            );
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isDone ? Colors.grey[100] : Colors.blue[50],
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                decoration: isDone ? TextDecoration.lineThrough : null,
                color: isDone ? Colors.grey : Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (note.notes.isNotEmpty)
              Text(
                note.notes,
                style: TextStyle(
                  fontSize: 10,
                  color: isDone ? Colors.grey : Colors.grey[600],
                  decoration: isDone ? TextDecoration.lineThrough : null,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }
}

/// Calendar list view with date range filter
class _CalendarListView extends ConsumerStatefulWidget {
  const _CalendarListView();

  @override
  ConsumerState<_CalendarListView> createState() => _CalendarListViewState();
}

class _CalendarListViewState extends ConsumerState<_CalendarListView> {
  List<Map<String, dynamic>>? _notesWithMetadata; // Store full note data
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    // Auto-fetch notes on init with default date range
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchNotes();
    });
  }

  Future<void> _fetchNotes() async {
    final startDate = ref.read(calendarStartDateProvider);
    final endDate = ref.read(calendarEndDateProvider);
    final customerFilter = ref.read(calendarListCustomerFilterProvider);

    setState(() => _loading = true);
    try {
      final repo = ref.read(calendarRepositoryProvider);
      final startStr = startDate != null
          ? '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}'
          : null;
      final endStr = endDate != null
          ? '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}'
          : null;

      // Get raw response with customer and date fields
      final notes = await repo.getRawNotesInRange(
        startDate: startStr,
        endDate: endStr,
        customer: customerFilter,
      );

      setState(() {
        _notesWithMetadata = notes;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final startDate = ref.watch(calendarStartDateProvider);
    final endDate = ref.watch(calendarEndDateProvider);

    return Column(
      children: [
        // Date range filter
        Container(
          color: Colors.grey[50],
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 680;
              const double filterFieldHeight = 56;
              final filters = [
                Flexible(
                  flex: 2,
                  child: Consumer(
                    builder: (context, ref, _) {
                      final customersAsync = ref.watch(customerOptionsProvider);
                      final selected = ref.watch(calendarListCustomerFilterProvider);
                      return customersAsync.when(
                        data: (customers) => DropdownButtonFormField<String?>(
                          initialValue: selected,
                          isDense: true,
                          menuMaxHeight: 300,
                          alignment: Alignment.centerLeft,
                          icon: const Icon(Icons.people, size: 18),
                          style: const TextStyle(fontSize: 13, color: Colors.black87),
                          borderRadius: BorderRadius.circular(8),
                          elevation: 2,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: l10n.customer,
                            isDense: true,
                          ),
                          items: [
                            DropdownMenuItem<String?>(value: null, child: Text(l10n.all)),
                            ...customers.map((c) => DropdownMenuItem<String?>(value: c, child: Text(c))),
                          ],
                          onChanged: (value) {
                            ref.read(calendarListCustomerFilterProvider.notifier).state = value;
                            _fetchNotes();
                          },
                        ),
                        loading: () => const SizedBox(
                          height: filterFieldHeight,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        error: (e, st) => const SizedBox(),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16, height: 16),
                Flexible(
                  flex: 2,
                  child: _DatePicker(
                    label: l10n.startDate,
                    date: startDate,
                    onChanged: (date) {
                      ref.read(calendarStartDateProvider.notifier).state = date;
                    },
                  ),
                ),
                const SizedBox(width: 16, height: 16),
                Flexible(
                  flex: 2,
                  child: _DatePicker(
                    label: l10n.endDate,
                    date: endDate,
                    onChanged: (date) {
                      ref.read(calendarEndDateProvider.notifier).state = date;
                    },
                  ),
                ),
                const SizedBox(width: 16, height: 16),
                Flexible(
                  flex: 1,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: _fetchNotes,
                    icon: const Icon(Icons.search, size: 18),
                    label: Text(l10n.filter),
                  ),
                ),
              ];
              return isNarrow
                  ? Wrap(
                      runSpacing: 12,
                      spacing: 16,
                      alignment: WrapAlignment.start,
                      children: filters,
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: filters,
                    );
            },
          ),
        ),
        const Divider(height: 1),
        // Notes list
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _notesWithMetadata == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            l10n.clickToViewNotes,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                  : _notesWithMetadata!.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                l10n.noNotesInRange,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _notesWithMetadata!.length,
                          itemBuilder: (context, index) {
                            final noteData = _notesWithMetadata![index];
                            final isCompleted = noteData['isCompleted'] as bool? ?? false;
                            final title = noteData['title'] as String;
                            final notes = noteData['notes'] as String? ?? '';
                            final customer = noteData['customer'] as String;
                            final dateStr = noteData['date'] as String;
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: Icon(
                                  isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                                  color: isCompleted ? Colors.green : Colors.grey,
                                ),
                                title: Text(
                                  '$customer - $title',
                                  style: TextStyle(
                                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: notes.isNotEmpty
                                    ? Text(
                                        notes,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    : null,
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () async {
                                  // Parse date from dateStr (YYYY-MM-DD)
                                  final dateMatch = RegExp(r'(\d{4})-(\d{2})-(\d{2})').firstMatch(dateStr);
                                  DateTime? noteDate;
                                  if (dateMatch != null) {
                                    noteDate = DateTime(
                                      int.parse(dateMatch.group(1)!),
                                      int.parse(dateMatch.group(2)!),
                                      int.parse(dateMatch.group(3)!),
                                    );
                                  }

                                  final result = await NoteDetailDialog.show(
                                    context,
                                    initial: NoteFormResult(
                                      customer: customer,
                                      title: title,
                                      date: noteDate,
                                      notes: notes.isEmpty ? null : notes,
                                      isCompleted: isCompleted,
                                    ),
                                  );

                                  if (result != null && result.customer != null && result.date != null) {
                                    try {
                                      final repo = ref.read(calendarRepositoryProvider);
                                      final dateStr =
                                          '${result.date!.year}-${result.date!.month.toString().padLeft(2, '0')}-${result.date!.day.toString().padLeft(2, '0')}';

                                      await repo.updateNote(
                                        id: noteData['_id'] as String,
                                        customer: result.customer!,
                                        title: result.title,
                                        date: dateStr,
                                        notes: result.notes,
                                        isCompleted: result.isCompleted,
                                      );

                                      _fetchNotes(); // Refresh list

                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Not güncellendi')),
                                        );
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Hata: $e')),
                                        );
                                      }
                                    }
                                  }
                                },
                              ),
                            );
                          },
                        ),
        ),
      ],
    );
  }
}

class _DatePicker extends StatelessWidget {
  final String label;
  final DateTime? date;
  final ValueChanged<DateTime?> onChanged;

  const _DatePicker({
    required this.label,
    required this.date,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final controller =
        TextEditingController(text: date == null ? '' : DateFormat('d MMMM yyyy', 'tr_TR').format(date!));
    return TextFormField(
      readOnly: true,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
        prefixIcon: const Icon(Icons.calendar_today, size: 18),
        suffixIcon: date != null
            ? IconButton(
                icon: const Icon(Icons.clear, size: 18),
                onPressed: () => onChanged(null),
              )
            : null,
      ),
      style: TextStyle(color: date == null ? Colors.grey[800] : Colors.black87, fontSize: 13),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) {
          onChanged(picked);
        }
      },
    );
  }
}

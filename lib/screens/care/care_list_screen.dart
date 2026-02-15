import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../states/care_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/care/care_record_card.dart';
import '../../widgets/care/care_type_filter.dart';

class CareListScreen extends StatefulWidget {
  final int babyId;
  final String? initialRecordType;

  const CareListScreen({
    super.key,
    required this.babyId,
    this.initialRecordType,
  });

  @override
  State<CareListScreen> createState() => _CareListScreenState();
}

class _CareListScreenState extends State<CareListScreen> {
  static const double _paginationTriggerOffset = 240;

  final ScrollController _scrollController = ScrollController();
  String _selectedRecordType = CareTypeFilter.allValue;
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    _selectedRecordType = widget.initialRecordType ?? CareTypeFilter.allValue;
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRecords();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadRecords() async {
    final careState = context.read<CareState>();
    await careState.loadRecords(
      widget.babyId,
      recordType: CareTypeFilter.toApiValue(_selectedRecordType),
      startDate: _formatDateForApi(_selectedDateRange?.start),
      endDate: _formatDateForApi(_selectedDateRange?.end),
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _paginationTriggerOffset) {
      context.read<CareState>().loadMore(widget.babyId);
    }
  }

  Future<void> _selectDateRange() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 3, 1, 1);
    final picked = await showDateRangePicker(
      context: context,
      firstDate: firstDate,
      lastDate: now,
      initialDateRange: _selectedDateRange,
    );

    if (picked == null) {
      return;
    }

    setState(() {
      _selectedDateRange = picked;
    });
    await _loadRecords();
  }

  Future<void> _clearDateRange() async {
    setState(() {
      _selectedDateRange = null;
    });
    await _loadRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppBarWidget(
              title: '육아 기록',
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: '육아 기록 추가',
                  onPressed: () => context.push('/care/${widget.babyId}/add'),
                ),
              ],
            ),
            _buildFilterSection(),
            Expanded(
              child: Consumer<CareState>(
                builder: (context, careState, child) {
                  if (careState.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (careState.errorMessage != null && careState.records.isEmpty) {
                    return _buildErrorState(careState.errorMessage!);
                  }
                  if (careState.records.isEmpty) {
                    return _buildEmptyState();
                  }

                  return RefreshIndicator(
                    onRefresh: _loadRecords,
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                      itemCount: careState.records.length + 1,
                      itemBuilder: (context, index) {
                        if (index == careState.records.length) {
                          return _buildListFooter(careState);
                        }

                        final record = careState.records[index];
                        return CareRecordCard(
                          record: record,
                          onTap: () => context.push(
                            '/care/${widget.babyId}/${record.id}',
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.borderLight),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CareTypeFilter(
            selectedValue: _selectedRecordType,
            onChanged: (value) async {
              setState(() {
                _selectedRecordType = value;
              });
              await _loadRecords();
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: _selectDateRange,
                icon: const Icon(Icons.date_range),
                label: Text(_dateRangeLabel()),
              ),
              if (_selectedDateRange != null) ...[
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _clearDateRange,
                  child: const Text('기간 초기화'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadRecords,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.event_note, size: 72, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              '육아 기록이 없습니다',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '우측 상단 + 버튼으로 기록을 추가해보세요.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListFooter(CareState careState) {
    if (careState.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (!careState.hasMore) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            '모든 육아 기록을 불러왔습니다.',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  String _dateRangeLabel() {
    if (_selectedDateRange == null) {
      return '기간 필터';
    }
    final formatter = DateFormat('MM/dd');
    return '${formatter.format(_selectedDateRange!.start)} - ${formatter.format(_selectedDateRange!.end)}';
  }

  String? _formatDateForApi(DateTime? value) {
    if (value == null) {
      return null;
    }
    return DateFormat('yyyy-MM-dd').format(value);
  }
}

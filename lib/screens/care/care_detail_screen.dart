import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/care_record.dart';
import '../../states/care_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_bar_widget.dart';

class CareDetailScreen extends StatefulWidget {
  final int babyId;
  final int recordId;

  const CareDetailScreen({
    super.key,
    required this.babyId,
    required this.recordId,
  });

  @override
  State<CareDetailScreen> createState() => _CareDetailScreenState();
}

class _CareDetailScreenState extends State<CareDetailScreen> {
  CareRecord? _record;
  bool _isLoading = true;
  bool _isDeleting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadRecord();
  }

  Future<void> _loadRecord() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final record =
          await context.read<CareState>().getCareRecord(widget.babyId, widget.recordId);
      if (!mounted) {
        return;
      }
      setState(() {
        _record = record;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = '육아 기록을 불러오지 못했습니다.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _moveToEditScreen() async {
    await context.push('/care/${widget.babyId}/${widget.recordId}/edit');
    if (!mounted) {
      return;
    }
    await _loadRecord();
  }

  Future<void> _confirmAndDelete() async {
    if (_record == null || _isDeleting) {
      return;
    }
    final careState = context.read<CareState>();

    final shouldDelete = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('육아 기록 삭제'),
            content: const Text('선택한 육아 기록을 삭제하시겠어요?\n삭제 후 되돌릴 수 없습니다.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
                child: const Text('삭제'),
              ),
            ],
          ),
        ) ??
        false;

    if (!shouldDelete) {
      return;
    }

    setState(() {
      _isDeleting = true;
    });

    try {
      await careState.deleteCareRecord(widget.babyId, widget.recordId);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('육아 기록이 삭제되었습니다.')),
      );
      context.pop();
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('삭제에 실패했습니다: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppBarWidget(
              title: '육아 기록 상세',
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
              actions: [
                IconButton(
                  onPressed: _isLoading || _record == null ? null : _moveToEditScreen,
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  onPressed: _isLoading || _record == null ? null : _confirmAndDelete,
                  color: AppColors.error,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null || _record == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage ?? '육아 기록을 찾을 수 없습니다.'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadRecord,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    final record = _record!;
    final recordedAt = DateTime.tryParse(record.recordedAt);
    final recordedLabel = recordedAt == null
        ? record.recordedAt
        : DateFormat('yyyy년 MM월 dd일 HH:mm').format(recordedAt);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildInfoCard(
            title: '기본 정보',
            rows: [
              _InfoRow(label: '타입', value: record.recordType.displayName),
              _InfoRow(label: '기록 시각', value: recordedLabel),
              if (record.diaperType != null)
                _InfoRow(label: '기저귀', value: record.diaperType!.displayName),
              if (record.sleepStart != null)
                _InfoRow(
                  label: '수면 시작',
                  value: _formatDateTime(record.sleepStart!),
                ),
              if (record.sleepEnd != null)
                _InfoRow(
                  label: '수면 종료',
                  value: _formatDateTime(record.sleepEnd!),
                ),
              if (record.sleepDurationMinutes != null)
                _InfoRow(label: '수면 시간', value: '${record.sleepDurationMinutes}분'),
              if (record.temperature != null)
                _InfoRow(
                  label: '체온',
                  value: '${record.temperature}°${record.temperatureUnit ?? 'C'}',
                ),
              if (record.medicineName != null)
                _InfoRow(label: '약 이름', value: record.medicineName!),
              if (record.medicineDosage != null)
                _InfoRow(label: '복용량', value: record.medicineDosage!),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            title: '메모',
            rows: [
              _InfoRow(
                label: '',
                value: (record.notes == null || record.notes!.trim().isEmpty)
                    ? '메모 없음'
                    : record.notes!.trim(),
              ),
            ],
          ),
          if (_isDeleting) ...[
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<_InfoRow> rows,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.headlineSmall),
          const SizedBox(height: 12),
          ...rows.map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: row,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(String dateTimeString) {
    final parsedDateTime = DateTime.tryParse(dateTimeString);
    if (parsedDateTime == null) {
      return dateTimeString;
    }
    return DateFormat('yyyy-MM-dd HH:mm').format(parsedDateTime);
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    if (label.isEmpty) {
      return Text(value, style: AppTextStyles.bodyMedium);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 88,
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ),
        Expanded(
          child: Text(value, style: AppTextStyles.bodyMedium),
        ),
      ],
    );
  }
}

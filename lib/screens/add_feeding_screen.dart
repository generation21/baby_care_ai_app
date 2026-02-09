import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/segmented_control.dart';
import '../widgets/chip_button.dart';

class AddFeedingScreen extends StatefulWidget {
  const AddFeedingScreen({super.key});

  @override
  State<AddFeedingScreen> createState() => _AddFeedingScreenState();
}

class _AddFeedingScreenState extends State<AddFeedingScreen> {
  String _selectedType = 'Breast';
  String _selectedSide = 'Left';
  final TextEditingController _amountController = TextEditingController(text: '120');
  final TextEditingController _durationController = TextEditingController(text: '15');
  final TextEditingController _timeController = TextEditingController(text: '2026-02-08 14:30');
  final TextEditingController _notesController = TextEditingController(text: 'Add notes here...');

  @override
  void dispose() {
    _amountController.dispose();
    _durationController.dispose();
    _timeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            AppBarWidget(
              title: 'Add Feeding Record',
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            
            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Feeding Type
                    Text('Feeding Type', style: AppTextStyles.caption),
                    const SizedBox(height: 8),
                    SegmentedControl(
                      options: const ['Breast', 'Formula', 'Mixed'],
                      selectedOption: _selectedType,
                      onChanged: (value) {
                        setState(() {
                          _selectedType = value;
                        });
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Side
                    Text('Side', style: AppTextStyles.caption),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ChipButton(
                          label: 'Left',
                          isSelected: _selectedSide == 'Left',
                          onTap: () {
                            setState(() {
                              _selectedSide = 'Left';
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        ChipButton(
                          label: 'Right',
                          isSelected: _selectedSide == 'Right',
                          onTap: () {
                            setState(() {
                              _selectedSide = 'Right';
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        ChipButton(
                          label: 'Both',
                          isSelected: _selectedSide == 'Both',
                          onTap: () {
                            setState(() {
                              _selectedSide = 'Both';
                            });
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Amount
                    Text('Amount (ml)', style: AppTextStyles.caption),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Amount (ml)',
                        helperText: 'Optional for breast feeding',
                        helperStyle: AppTextStyles.captionSmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Duration
                    Text('Duration (minutes)', style: AppTextStyles.caption),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _durationController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Duration (minutes)',
                        helperText: 'Optional',
                        helperStyle: AppTextStyles.captionSmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Recorded Time
                    Text('Recorded Time', style: AppTextStyles.caption),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _timeController,
                      decoration: InputDecoration(
                        hintText: 'Recorded Time',
                        helperText: 'Default: current time',
                        helperStyle: AppTextStyles.captionSmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                        suffixIcon: const Icon(Icons.calendar_today, size: 20),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Notes
                    Text('Notes (optional)', style: AppTextStyles.caption),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _notesController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: 'Add notes here...',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom Actions
            Container(
              height: 80,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  top: BorderSide(color: AppColors.borderLight),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Save record
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.check, size: 20),
                      label: const Text('Save Record'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

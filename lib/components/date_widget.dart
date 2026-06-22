import '/components/app_branding.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'date_model.dart';
export 'date_model.dart';

class DateWidget extends StatefulWidget {
  const DateWidget({
    super.key,
    this.range,
    this.date,
  });

  final String? range;
  final String? date;

  @override
  State<DateWidget> createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  late DateModel _model;
  late DateTime _selectedDate;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DateModel());
    _selectedDate = _parseDate(
      widget.date ?? functions.dateSet('initial', 'date', '1', '1', '1'),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  DateTime _parseDate(String input) {
    final parts = input.split('-');
    if (parts.length != 3) {
      return DateTime.now();
    }

    final year = int.tryParse(parts[0]) ?? DateTime.now().year;
    final month = int.tryParse(parts[1]) ?? DateTime.now().month;
    final day = int.tryParse(parts[2]) ?? DateTime.now().day;
    return DateTime(year, month, day);
  }

  DateTime _dateWith({
    int? year,
    int? month,
    int? day,
  }) {
    final targetYear = year ?? _selectedDate.year;
    final targetMonth = month ?? _selectedDate.month;
    final requestedDay = day ?? _selectedDate.day;
    final lastDayOfMonth = DateTime(targetYear, targetMonth + 1, 0).day;
    final targetDay =
        requestedDay > lastDayOfMonth ? lastDayOfMonth : requestedDay;

    return DateTime(targetYear, targetMonth, targetDay);
  }

  void _adjustYear(int delta) {
    setState(() {
      _selectedDate = _dateWith(year: _selectedDate.year + delta);
    });
  }

  void _adjustMonth(int delta) {
    final absoluteMonth = (_selectedDate.year * 12) + (_selectedDate.month - 1);
    final nextAbsoluteMonth = absoluteMonth + delta;
    final nextYear = nextAbsoluteMonth ~/ 12;
    final nextMonth = (nextAbsoluteMonth % 12) + 1;

    setState(() {
      _selectedDate = _dateWith(
        year: nextYear,
        month: nextMonth,
      );
    });
  }

  void _adjustDay(int delta) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: delta));
    });
  }

  void _confirmSelection() {
    final formatted = functions.dateSet(
      'dateout',
      'yyyy-MM-dd',
      _selectedDate.year.toString(),
      _selectedDate.month.toString(),
      _selectedDate.day.toString(),
    );

    if (widget.range == 'bb') {
      FFAppState().bb = formatted;
    } else {
      FFAppState().ba = formatted;
    }

    context.safePop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22.0),
          decoration: AppBranding.panelDecoration(
            context,
            radius: 24.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      AppBranding.localized(
                        context,
                        zh: '選擇日期',
                        en: 'Choose Date',
                      ),
                      style: theme.titleLarge.override(
                        color: AppBranding.textStrong,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.safePop(),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppBranding.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6.0),
              Text(
                AppBranding.localized(
                  context,
                  zh: '使用加減按鈕調整年、月、日，再按下確定。',
                  en: 'Adjust the year, month, and day, then confirm.',
                ),
                style: theme.bodyMedium.override(
                  color: AppBranding.textMuted,
                  letterSpacing: 0.0,
                ),
              ),
              const SizedBox(height: 18.0),
              _DateAdjustRow(
                label: AppBranding.localized(
                  context,
                  zh: '年',
                  en: 'Year',
                ),
                value: _selectedDate.year.toString(),
                onDecrease: () => _adjustYear(-1),
                onIncrease: () => _adjustYear(1),
              ),
              const SizedBox(height: 12.0),
              _DateAdjustRow(
                label: AppBranding.localized(
                  context,
                  zh: '月',
                  en: 'Month',
                ),
                value: _selectedDate.month.toString().padLeft(2, '0'),
                onDecrease: () => _adjustMonth(-1),
                onIncrease: () => _adjustMonth(1),
              ),
              const SizedBox(height: 12.0),
              _DateAdjustRow(
                label: AppBranding.localized(
                  context,
                  zh: '日',
                  en: 'Day',
                ),
                value: _selectedDate.day.toString().padLeft(2, '0'),
                onDecrease: () => _adjustDay(-1),
                onIncrease: () => _adjustDay(1),
              ),
              const SizedBox(height: 18.0),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                decoration: AppBranding.softPanelDecoration(context),
                child: Row(
                  children: [
                    const Icon(
                      Icons.event_rounded,
                      color: AppBranding.actionColor,
                      size: 20.0,
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                      style: theme.bodyLarge.override(
                        color: AppBranding.textStrong,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18.0),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.safePop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppBranding.textStrong,
                        side: const BorderSide(
                          color: AppBranding.borderColor,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      child: Text(
                        AppBranding.localized(
                          context,
                          zh: '取消',
                          en: 'Cancel',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _confirmSelection,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppBranding.dangerColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      child: Text(
                        AppBranding.localized(
                          context,
                          zh: '確定',
                          en: 'Confirm',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateAdjustRow extends StatelessWidget {
  const _DateAdjustRow({
    required this.label,
    required this.value,
    required this.onDecrease,
    required this.onIncrease,
  });

  final String label;
  final String value;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Row(
      children: [
        SizedBox(
          width: 52.0,
          child: Text(
            label,
            style: theme.headlineSmall.override(
              color: AppBranding.textStrong,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 10.0),
        _AdjustButton(
          icon: Icons.remove_rounded,
          onTap: onDecrease,
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Container(
            height: 56.0,
            alignment: Alignment.center,
            decoration: AppBranding.softPanelDecoration(context),
            child: Text(
              value,
              style: theme.headlineSmall.override(
                color: AppBranding.textStrong,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10.0),
        _AdjustButton(
          icon: Icons.add_rounded,
          onTap: onIncrease,
        ),
      ],
    );
  }
}

class _AdjustButton extends StatelessWidget {
  const _AdjustButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50.0,
      height: 50.0,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppBranding.textStrong,
          side: const BorderSide(
            color: AppBranding.borderColor,
          ),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
        child: Icon(icon),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/color/app_color.dart';
import '../../bloc/local_noti/local_bloc.dart';
import '../../bloc/local_noti/local_event.dart';
import '../../bloc/local_noti/local_state.dart';
import '../notification/notification.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  static const Map<String, String> labels = {
    'generalNotification': 'General Notification',
    'sound': 'Sound',
    'soundCall': 'Sound Call',
    'vibrate': 'Vibrate',
    'transactionUpdate': 'Transaction Update',
    'expenseReminder': 'Expense Reminder',
    'budgetNotifications': 'Budget Notifications',
    'lowBalanceAlerts': 'Low Balance Alerts',
  };

  bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  TextStyle _text(
      BuildContext context,
      double size, {
        FontWeight weight = FontWeight.w400,
        Color? color,
      }) {
    final isDark = _isDark(context);

    return GoogleFonts.poppins(
      fontSize: size,
      fontWeight: weight,
      color: color ??
          (isDark ? AppColors.darkText : AppColors.darkGreen),
    );
  }

  Widget _header(BuildContext context) {
    final isDark = _isDark(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 24, 22),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: Icon(
              Icons.arrow_back,
              color: isDark ? AppColors.darkText : AppColors.white,
              size: 24,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Notification Settings',
                textAlign: TextAlign.center,
                style: _text(
                  context,
                  17,
                  weight: FontWeight.w600,
                  color: isDark ? AppColors.darkText : AppColors.white,
                ),
              ),
            ),
          ),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.lightGreen,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationScreen(),
                  ),
                );
              },
              icon: Icon(
                Icons.notifications_none_rounded,
                color: isDark ? AppColors.darkText : AppColors.darkGreen,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _switchRow(
      BuildContext context,
      String key,
      String label,
      NotificationSettingsState state,
      bool masterEnabled,
      ) {
    final isDark = _isDark(context);
    final value = state.settings[key] ?? true;
    final isMaster = key == 'generalNotification';
    final isSaving = state.savingKeys.contains(key);
    final enabled = isMaster || masterEnabled;

    return SizedBox(
      height: 52,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: _text(
                context,
                11.5,
                weight: FontWeight.w500,
                color: enabled
                    ? (isDark ? AppColors.darkText : AppColors.darkGreen)
                    : (isDark
                    ? AppColors.darkSecondaryText
                    : AppColors.darkGreen.withValues(alpha: 0.5)),
              ),
            ),
          ),
          if (isSaving)
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primaryGreen,
              ),
            )
          else
            Transform.scale(
              scale: 0.85,
              child: Switch(
                value: value,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                thumbColor: WidgetStateProperty.resolveWith((states) {
                  return states.contains(WidgetState.selected)
                      ? AppColors.white
                      : (isDark
                      ? AppColors.darkSecondaryText
                      : AppColors.primaryGreen);
                }),
                trackColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors.primaryGreen;
                  }
                  return isDark
                      ? AppColors.darkDivider
                      : AppColors.lightDivider;
                }),
                trackOutlineColor:
                WidgetStateProperty.all(Colors.transparent),
                onChanged: enabled
                    ? (newValue) {
                  context.read<NotificationSettingsBloc>().add(
                    UpdateNotificationSetting(
                      key: key,
                      value: newValue,
                    ),
                  );
                }
                    : null,
              ),
            ),
        ],
      ),
    );
  }

  Widget _content(
      BuildContext context,
      NotificationSettingsState state,
      ) {
    final isDark = _isDark(context);

    if (state.status == NotificationSettingsStatus.loading ||
        state.status == NotificationSettingsStatus.initial) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryGreen,
        ),
      );
    }

    if (state.status == NotificationSettingsStatus.failure &&
        state.settings.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                state.errorMessage ?? 'Unable to load settings.',
                textAlign: TextAlign.center,
                style: _text(context, 12),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  context
                      .read<NotificationSettingsBloc>()
                      .add(const LoadNotificationSettings());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: AppColors.darkGreen,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final masterEnabled =
        state.settings['generalNotification'] == true;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        36,
        38,
        32,
        20 + MediaQuery.of(context).padding.bottom,
      ),
      children: [
        for (final entry in labels.entries)
          _switchRow(
            context,
            entry.key,
            entry.value,
            state,
            masterEnabled,
          ),
        if (state.errorMessage != null) ...[
          const SizedBox(height: 12),
          Text(
            state.errorMessage!,
            style: _text(
              context,
              11,
              color: AppColors.error,
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _isDark(context);

    return Scaffold(
      backgroundColor:
      isDark ? AppColors.darkBackground : AppColors.primaryGreen,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _header(context),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurface
                      : AppColors.lightGreen,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(50),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(50),
                  ),
                  child: BlocConsumer<NotificationSettingsBloc,
                      NotificationSettingsState>(
                    listener: (context, state) {
                      if (state.errorMessage != null &&
                          state.settings.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.errorMessage!),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: isDark
                                ? AppColors.darkCard
                                : AppColors.darkGreen,
                          ),
                        );
                      }
                    },
                    builder: _content,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../bloc/local_noti/local_bloc.dart';
import '../../bloc/local_noti/local_event.dart';
import '../../bloc/local_noti/local_state.dart';
import '../notification/notification.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  static const Color mainGreen = Color(0xFF00D09E);
  static const Color lightGreen = Color(0xFFF1FFF3);
  static const Color darkGreen = Color(0xFF063F3F);
  static const Color offTrack = Color(0xFFC9F0E1);

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

  static TextStyle _text(
      double size, {
        FontWeight weight = FontWeight.w400,
        Color color = darkGreen,
      }) {
    return GoogleFonts.poppins(
      fontSize: size,
      fontWeight: weight,
      color: color,
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 24, 22),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 24,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Notification Settings',
                style: _text(17, weight: FontWeight.w600),
              ),
            ),
          ),
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: lightGreen,
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
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: darkGreen,
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
    final value = state.settings[key] ?? true;
    final isMaster = key == 'generalNotification';
    final isSaving = state.savingKeys.contains(key);
    final enabled = isMaster || masterEnabled;

    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: _text(11.5, weight: FontWeight.w500),
            ),
          ),
          if (isSaving)
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: mainGreen,
              ),
            )
          else
            Transform.scale(
              scale: 0.85,
              child: Switch(
                value: value,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                thumbColor: WidgetStateProperty.resolveWith(
                      (states) => states.contains(WidgetState.selected)
                      ? Colors.white
                      : mainGreen,
                ),
                trackColor: WidgetStateProperty.resolveWith(
                      (states) => states.contains(WidgetState.selected)
                      ? mainGreen
                      : offTrack,
                ),
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

  Widget _content(BuildContext context, NotificationSettingsState state) {
    if (state.status == NotificationSettingsStatus.loading ||
        state.status == NotificationSettingsStatus.initial) {
      return const Center(
        child: CircularProgressIndicator(color: mainGreen),
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
                style: _text(12),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  context
                      .read<NotificationSettingsBloc>()
                      .add(const LoadNotificationSettings());
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final masterEnabled = state.settings['generalNotification'] == true;

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
            style: _text(11, color: Colors.red.shade700),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainGreen,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _header(context),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.vertical(
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
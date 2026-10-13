import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  static const Color mainGreen = Color(0xFF00D09E);
  static const Color lightGreen = Color(0xFFF1FFF3);
  static const Color darkGreen = Color(0xFF063F3F);
  static const Color blue = Color(0xFF168BFF);
  static const Color softGreen = Color(0xFFDDF5E2);

  static const List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static TextStyle _t(
      double size, {
        FontWeight w = FontWeight.w400,
        Color c = darkGreen,
        double? height,
      }) =>
      GoogleFonts.poppins(
        fontSize: size,
        fontWeight: w,
        color: c,
        height: height,
      );

  DateTime? parseDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';

    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$hour:$minute - ${_months[date.month - 1]} ${date.day}';
  }

  String dateGroup(DateTime? date) {
    if (date == null) return 'Earlier';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);

    if (day == today) return 'Today';
    if (day == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    }

    final startOfWeek =
    today.subtract(Duration(days: today.weekday - DateTime.monday));
    final startOfLastWeek = startOfWeek.subtract(const Duration(days: 7));

    if (!day.isBefore(startOfWeek)) return 'This Week';
    if (!day.isBefore(startOfLastWeek)) return 'Last Week';

    return 'Earlier';
  }

  IconData notificationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'reminder':
      case 'expense_reminder':
        return Icons.notifications_none_rounded;
      case 'update':
        return Icons.star_border_rounded;
      case 'expense':
      case 'income':
      case 'transaction':
        return Icons.attach_money_rounded;
      case 'expense_record':
      case 'record':
        return Icons.south_east_rounded;
      case 'budget':
        return Icons.pie_chart_outline_rounded;
      case 'low_balance':
        return Icons.account_balance_wallet_outlined;
      default:
        return Icons.notifications_none_rounded;
    }
  }

  bool isOutlinedType(String type) {
    return const {
      'expense',
      'income',
      'transaction',
      'expense_record',
      'record',
    }.contains(type.toLowerCase());
  }

  Future<void> markAsRead(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('notifications')
        .doc(id)
        .update({'isRead': true});
  }

  Future<void> markAllAsRead(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
      ) async {
    final firestore = FirebaseFirestore.instance;

    for (var i = 0; i < docs.length; i += 400) {
      final batch = firestore.batch();
      final end = (i + 400 < docs.length) ? i + 400 : docs.length;

      for (final doc in docs.sublist(i, end)) {
        if (doc.data()['isRead'] != true) {
          batch.update(doc.reference, {'isRead': true});
        }
      }

      await batch.commit();
    }
  }

  Future<void> deleteAll(
      BuildContext context,
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
      ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete all notifications?'),
        content: const Text(
          'Your notification history will be deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Delete all',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      for (var i = 0; i < docs.length; i += 400) {
        final batch = FirebaseFirestore.instance.batch();
        final end = (i + 400 < docs.length) ? i + 400 : docs.length;

        for (final doc in docs.sublist(i, end)) {
          batch.delete(doc.reference);
        }

        await batch.commit();
      }

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notifications deleted successfully.'),
        ),
      );
    } catch (_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to delete notifications.'),
        ),
      );
    }
  }

  Future<void> _onMenuSelected(BuildContext context, String value, User user) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('notifications')
          .get();

      if (!context.mounted) return;

      if (value == 'read') {
        await markAllAsRead(snapshot.docs);
      } else if (value == 'delete') {
        await deleteAll(context, snapshot.docs);
      }
    } catch (_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to update notifications.'),
        ),
      );
    }
  }

  Widget _bellCircle() {
    return Container(
      width: 38,
      height: 38,
      decoration: const BoxDecoration(
        color: lightGreen,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.notifications_none_rounded,
        color: darkGreen,
        size: 22,
      ),
    );
  }

  Widget _header(BuildContext context, User? user) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 24, 22),
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
                'Notification',
                style: _t(18, w: FontWeight.w700),
              ),
            ),
          ),
          if (user != null)
            PopupMenuButton<String>(
              onSelected: (value) => _onMenuSelected(context, value, user),
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'read',
                  child: Text('Mark all read'),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete all'),
                ),
              ],
              child: _bellCircle(),
            )
          else
            _bellCircle(),
        ],
      ),
    );
  }

  Widget _badge(String type) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: mainGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: isOutlinedType(type)
          ? Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          border: Border.all(color: darkGreen, width: 1.6),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          notificationIcon(type),
          color: darkGreen,
          size: 15,
        ),
      )
          : Icon(
        notificationIcon(type),
        color: darkGreen,
        size: 25,
      ),
    );
  }

  Widget _tile(
      BuildContext context,
      QueryDocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data();
    final date = parseDate(data['createdAt']);
    final type = data['type']?.toString() ?? '';
    final isRead = data['isRead'] == true;
    final title = data['title']?.toString() ?? 'Notification';
    final message =
        data['message']?.toString() ?? data['body']?.toString() ?? '';
    final details = data['details']?.toString() ?? '';

    return InkWell(
      onTap: () async {
        try {
          await markAsRead(doc.id);
        } catch (_) {
          if (!context.mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to mark as read.'),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: mainGreen, width: 1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _badge(type),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: _t(13, w: FontWeight.w600),
                            ),
                          ),
                          if (!isRead)
                            const Icon(
                              Icons.circle,
                              color: blue,
                              size: 8,
                            ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        message,
                        style: _t(10.5, height: 1.35),
                      ),
                      if (details.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            details,
                            style: _t(9.5, w: FontWeight.w600, c: blue),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                formatDate(date),
                style: _t(9.5, c: blue),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body(User? user) {
    if (user == null) {
      return Center(
        child: Text(
          'Please log in to view notifications.',
          style: _t(12),
        ),
      );
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('notifications')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Unable to load notifications.',
              style: _t(12),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: mainGreen),
          );
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  size: 48,
                  color: mainGreen,
                ),
                const SizedBox(height: 8),
                Text('No notifications yet', style: _t(12)),
              ],
            ),
          );
        }

        final groups =
        <String, List<QueryDocumentSnapshot<Map<String, dynamic>>>>{};

        for (final doc in docs) {
          final group = dateGroup(parseDate(doc.data()['createdAt']));
          groups.putIfAbsent(group, () => []);
          groups[group]!.add(doc);
        }

        const groupOrder = [
          'Today',
          'Yesterday',
          'This Week',
          'Last Week',
          'Earlier',
        ];

        final rows = <Widget>[];

        for (final group in groupOrder.where(groups.containsKey)) {
          rows.add(
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 4),
              child: Text(
                group,
                style: _t(11, w: FontWeight.w500),
              ),
            ),
          );

          for (final doc in groups[group]!) {
            rows.add(_tile(context, doc));
          }
        }

        return ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            28,
            8,
            28,
            20 + MediaQuery.of(context).padding.bottom,
          ),
          children: rows,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: mainGreen,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _header(context, user),
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
                  child: _body(user),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
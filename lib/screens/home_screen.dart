import 'package:flutter/material.dart';

import '../routes/app_routes.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const Color _sidebar = Color(0xFF00695C);
  static const Color _accent = Color(0xFF00897B);
  static const Color _pageBg = Color(0xFFF4F7F6);

  static const List<IconData> _navIcons = <IconData>[
    Icons.dashboard_outlined,
    Icons.flight_takeoff,
    Icons.description_outlined,
    Icons.campaign_outlined,
    Icons.bar_chart,
    Icons.school_outlined,
    Icons.insights_outlined,
    Icons.person_outline,
  ];

  static const List<String> _navLabels = <String>[
    'Dashboard',
    'Travel Records',
    'Documents',
    'Announcements',
    'Reports',
    'College Records',
    'Analytics',
    'Profile / Settings',
  ];

  static const List<_Record> _records = <_Record>[
    _Record('Sep 10, 2026', 'Japan', 'Research', _Status.approved),
    _Record('Aug 28, 2026', 'Thailand', 'Conference', _Status.pending),
    _Record('Aug 15, 2026', 'South Korea', 'Training', _Status.approved),
    _Record('Jul 30, 2026', 'USA', 'Academic', _Status.rejected),
    _Record('Jul 12, 2026', 'Singapore', 'Seminar', _Status.approved),
  ];

  static const List<_Announcement> _announcements = <_Announcement>[
    _Announcement('Sep 18, 2026', 'New Travel Guidelines for SY 2026-2027'),
    _Announcement('Sep 12, 2026', 'Required Documents for Japan Travel'),
    _Announcement('Sep 05, 2026', 'OIGE Office will be closed on Sept 15'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Sidebar(color: _sidebar, navIcons: _navIcons, navLabels: _navLabels),
          Expanded(
            child: Column(
              children: [
                const _TopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _WelcomeBanner(color: _sidebar, accent: _accent),
                        const SizedBox(height: 16),
                        const Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: <Widget>[
                            _StatCard(
                              icon: Icons.flight_takeoff,
                              label: 'Total Travel Records',
                              value: '12',
                              hint: '↑ 2 this month',
                              tint: Color(0xFFE0F2F1),
                              accent: Color(0xFF00897B),
                            ),
                            _StatCard(
                              icon: Icons.description_outlined,
                              label: 'Documents Uploaded',
                              value: '18',
                              hint: '↑ 4 this month',
                              tint: Color(0xFFE3F2FD),
                              accent: Color(0xFF1565C0),
                            ),
                            _StatCard(
                              icon: Icons.verified_outlined,
                              label: 'Compliance Rate',
                              value: '92%',
                              hint: '↑ 6% this month',
                              tint: Color(0xFFFFF8E1),
                              accent: Color(0xFFFF8F00),
                            ),
                            _StatCard(
                              icon: Icons.campaign_outlined,
                              label: 'Announcements',
                              value: '5',
                              hint: '↑ 1 new',
                              tint: Color(0xFFF3E5F5),
                              accent: Color(0xFF6A1B9A),
                            ),
                            _StatCard(
                              icon: Icons.school_outlined,
                              label: 'Colleges',
                              value: '3',
                              hint: '— no change',
                              tint: Color(0xFFE8F5E9),
                              accent: Color(0xFF2E7D32),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        LayoutBuilder(
                          builder: (BuildContext context,
                                  BoxConstraints constraints) =>
                              constraints.maxWidth >= 850
                                  ? Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: _RecentRecordsCard(
                                              records: _records),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            children: [
                                              _AnnouncementsCard(
                                                  items: _announcements),
                                              const SizedBox(height: 16),
                                              _QuickActionsCard(
                                                  accent: _accent),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        _RecentRecordsCard(records: _records),
                                        const SizedBox(height: 16),
                                        _AnnouncementsCard(
                                            items: _announcements),
                                        const SizedBox(height: 16),
                                        _QuickActionsCard(accent: _accent),
                                      ],
                                    ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.color,
    required this.navIcons,
    required this.navLabels,
  });

  final Color color;
  final List<IconData> navIcons;
  final List<String> navLabels;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      height: double.infinity,
      color: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CSUCC - CABADBARAN',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'SmartTrack',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'AI-Based Travel Monitoring',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: navLabels.length,
              itemBuilder: (BuildContext context, int index) {
                final bool selected = index == 0;
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  child: Material(
                    color: selected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: index == 4
                          ? () => Navigator.pushNamed(
                                context,
                                AppRoutes.report,
                              )
                          : () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        child: Row(
                          children: [
                            Icon(
                              navIcons[index],
                              size: 20,
                              color: selected ? color : Colors.white70,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                navLabels[index],
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: selected ? color : Colors.white,
                                  fontWeight: selected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(color: Colors.white24, height: 1),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context, '/', (_) => false),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 26, vertical: 16),
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.white70, size: 20),
                    SizedBox(width: 12),
                    Text(
                      'Log Out',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Faculty Portal (Dashboard)',
              style: TextStyle(color: Colors.white54, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Text(
            'Dashboard',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Stack(
            children: [
              const Icon(Icons.notifications_outlined, size: 26),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          const CircleAvatar(
            backgroundColor: Color(0xFF00695C),
            child: Text('KL', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 10),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Khen L. Lumindas',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text('Faculty',
                  style: TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}

class _WelcomeBanner extends StatelessWidget {
  const _WelcomeBanner({required this.color, required this.accent});

  final Color color;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[color.withValues(alpha: 0.12), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Good Morning,', style: TextStyle(fontSize: 15)),
          const SizedBox(height: 2),
          Text(
            'Khen L.Lumindas',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Track. Manage. Advance.',
            style: TextStyle(
              color: accent,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Welcome to SmartTrack, your centralized platform for '
            'international travel monitoring and compliance.',
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              _chip(Icons.flight_takeoff, 'Travel Records Monitoring', color),
              _chip(Icons.description_outlined, 'Document Management', color),
              _chip(Icons.insights_outlined, 'AI-Powered Insights', color),
              _chip(Icons.public, 'Global Opportunities', color),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _chip(IconData icon, String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      );
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.hint,
    required this.tint,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final String value;
  final String hint;
  final Color tint;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accent, size: 22),
          const SizedBox(height: 10),
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(hint, style: TextStyle(fontSize: 11, color: accent)),
        ],
      ),
    );
  }
}

class _RecentRecordsCard extends StatelessWidget {
  const _RecentRecordsCard({required this.records});

  final List<_Record> records;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Travel Records',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text('View All',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Expanded(flex: 2, child: _HeaderCell('Date')),
              Expanded(flex: 2, child: _HeaderCell('Destination')),
              Expanded(flex: 2, child: _HeaderCell('Purpose')),
              Expanded(flex: 2, child: _HeaderCell('Status')),
            ],
          ),
          const Divider(height: 20),
          for (final _Record record in records)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                      flex: 2, child: Text(record.date, style: _cellStyle)),
                  Expanded(
                      flex: 2,
                      child: Text(record.destination, style: _cellStyle)),
                  Expanded(
                      flex: 2, child: Text(record.purpose, style: _cellStyle)),
                  Expanded(flex: 2, child: _StatusChip(status: record.status)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  static const TextStyle _cellStyle = TextStyle(fontSize: 13);
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
          fontWeight: FontWeight.w600,
        ),
      );
}

enum _Status { approved, pending, rejected }

class _Record {
  const _Record(this.date, this.destination, this.purpose, this.status);

  final String date;
  final String destination;
  final String purpose;
  final _Status status;
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final _Status status;

  @override
  Widget build(BuildContext context) {
    final (String label, Color color) = switch (status) {
      _Status.approved => ('Approved', const Color(0xFF2E7D32)),
      _Status.pending => ('Pending', const Color(0xFFEF6C00)),
      _Status.rejected => ('Rejected', const Color(0xFFC62828)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style:
            TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _Announcement {
  const _Announcement(this.date, this.title);

  final String date;
  final String title;
}

class _AnnouncementsCard extends StatelessWidget {
  const _AnnouncementsCard({required this.items});

  final List<_Announcement> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Announcements',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text('View All',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 8),
          for (final _Announcement item in items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.campaign_outlined,
                      size: 18, color: Colors.grey),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.title,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 2),
                        Text(item.date,
                            style: const TextStyle(
                                fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _QuickActionsCard extends StatelessWidget {
  const _QuickActionsCard({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Quick Actions',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),
          _action(Icons.add, 'Add Travel Record', accent),
          const SizedBox(height: 8),
          _action(Icons.upload_file_outlined, 'Upload Document', accent),
          const SizedBox(height: 8),
          _action(
            Icons.bar_chart,
            'File a Report',
            accent,
            onTap: () => Navigator.pushNamed(context, AppRoutes.report),
          ),
        ],
      ),
    );
  }

  Widget _action(
    IconData icon,
    String label,
    Color color, {
    VoidCallback? onTap,
  }) =>
      Material(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap ?? () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../core/app_colors.dart';
import '../../editor/screens/editor_screen.dart';
import '../widgets/clock_widget.dart';
import '../widgets/upcoming_tasks_widget.dart';
import '../widgets/calendar_view.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EditorScreen()),
                      );
                    },
                    child: Row(
                      children: [
                        const Icon(
                          LucideIcons.files,
                          color: AppColors.amber500,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Journal',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.zinc100 : AppColors.mist950,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          _showSearch(context);
                        },
                        icon: const Icon(LucideIcons.search),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(LucideIcons.settings),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClockWidget(dateTime: _now),
                          const SizedBox(height: 40),
                          Text(
                            DateFormat('EEEE, MMMM d').format(_now),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: isDark ? AppColors.zinc400 : AppColors.mist700,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.zinc900 : AppColors.mist100,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isDark ? AppColors.zinc800 : AppColors.mist300,
                                ),
                              ),
                              child: const DashboardCalendar(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40),
                    const Expanded(
                      flex: 1,
                      child: UpcomingTasksWidget(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditorScreen()),
          );
        },
        backgroundColor: AppColors.rose500,
        child: const Icon(LucideIcons.plus, color: Colors.white),
      ),
    );
  }

  void _showSearch(BuildContext context) {
    showSearch(
      context: context,
      delegate: BloksSearchDelegate(),
    );
  }
}

class BloksSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(icon: const Icon(LucideIcons.x), onPressed: () => query = ''),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(LucideIcons.arrowLeft),
    onPressed: () => close(context, null),
  );

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      children: const [
        ListTile(title: Text('Search pages, blocks, or tasks...')),
      ],
    );
  }
}

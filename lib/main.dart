import 'package:flutter/material.dart';
import 'screens/habit_list_screen.dart';
import 'screens/edit_list_screen.dart';
import 'screens/habit_detail_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/icon_gallery_screen.dart';
import 'models/habit.dart';

void main() {
  runApp(const HabitTrackerApp());
}

class HabitTrackerApp extends StatelessWidget {
  const HabitTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(primarySwatch: Colors.indigo),
      // маршрутиз навигация
      routes: {
        '/': (ctx) => const HomeShell(),
        '/list': (ctx) => const HabitListScreen(),
        '/edit': (ctx) => const EditHabitScreen(),
        '/stats': (ctx) => const StatsScreen(),
        '/icons': (ctx) => const IconGalleryScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final arg = settings.arguments;
          if (arg is Habit) {
            return MaterialPageRoute(builder: (_) => HabitDetailScreen(habit: arg, onUpdated: (_) {}));
          }
        }
        return null;
      },
      initialRoute: '/',
    );
  }
}


class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final tabs = const [Tab(text: 'Pages (гориз.)'), Tab(text: 'Routes (имена)')];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Навигация: Page + Routes'),
        bottom: TabBar(controller: _tabController, tabs: tabs),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          PagesDemo(),   // горизонт навигация
          RoutesDemo(),  // маршрутиз навигация
        ],
      ),
    );
  }
}

class PagesDemo extends StatefulWidget {
  const PagesDemo({super.key});
  @override
  State<PagesDemo> createState() => _PagesDemoState();
}

class _PagesDemoState extends State<PagesDemo> {
  final PageController _controller = PageController();
  int _index = 0;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _index > 0 ? () => _controller.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease) : null,
              ),
              Expanded(child: Center(child: Text('Страница ${_index + 1} из 5'))),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _index < 4 ? () => _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease) : null,
              ),
            ],
          ),
        ),
        Expanded(
          child: PageView(
            controller: _controller,
            onPageChanged: (i) => setState(() => _index = i),
            children: const [
              HabitListScreen(embedInPageView: true),
              EditHabitScreen(embedMode: true),
              HabitDetailPagePlaceholder(),
              StatsScreen(embedMode: true),
              IconGalleryScreen(embedMode: true),
            ],
          ),
        ),
      ],
    );
  }
}

class HabitDetailPagePlaceholder extends StatelessWidget {
  const HabitDetailPagePlaceholder({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Это место для детального экрана —\nв PageView показываем только демонстрацию.\nДля просмотра реальных деталей нажмите на привычку в списке и откройте вертикальный переход.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class RoutesDemo extends StatelessWidget {
  const RoutesDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ListView(
        children: [
          const Text(
            'Демонстрация маршрутизированной навигации с передачей данных:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/list'),
            child: const Text('Открыть: Список привычек'),
          ),

          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/edit'),
            child: const Text('Открыть: Создать привычку'),
          ),

          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/stats'),
            child: const Text('Открыть: Статистика'),
          ),

          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/icons'),
            child: const Text('Открыть: Галерея иконок'),
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),

          const Text(
            "Передача данных через Named Route:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: () {
              final exampleHabit = Habit(
                id: "demo123",
                title: "Демонстрационная привычка",
                description: "Показываем передачу объекта через pushNamed",
                iconUrl: "",
              );

              Navigator.pushNamed(
                context,
                '/detail',
                arguments: exampleHabit,
              );
            },
            child: const Text("Открыть HabitDetail через Named Route + аргумент"),
          ),
        ],
      ),
    );
  }
}

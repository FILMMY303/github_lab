import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _themePreferenceKey = 'isDarkMode';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = SharedPreferencesAsync();
  final isDarkMode = await preferences.getBool(_themePreferenceKey) ?? false;
  runApp(MyApp(preferences: preferences, initialDarkMode: isDarkMode));
}

class MyApp extends StatefulWidget {
  const MyApp({
    required this.preferences,
    required this.initialDarkMode,
    super.key,
  });

  final SharedPreferencesAsync preferences;
  final bool initialDarkMode;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isDarkMode = widget.initialDarkMode;

  Future<void> _toggleTheme() async {
    final newValue = !_isDarkMode;
    await widget.preferences.setBool(_themePreferenceKey, newValue);
    if (mounted) {
      setState(() => _isDarkMode = newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: MyPage(onToggleTheme: _toggleTheme),
    );
  }
}

class MyPage extends StatelessWidget {
  const MyPage({required this.onToggleTheme, super.key});

  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub Lab'),
        actions: [
          ThemeToggleButton(
            isDarkMode: Theme.of(context).brightness == Brightness.dark,
            onPressed: onToggleTheme,
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => ProfilePage(
                  onToggleTheme: onToggleTheme,
                ),
              ),
            );
          },
          child: const Text('Press'),
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({required this.onToggleTheme, super.key});

  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          ThemeToggleButton(
            isDarkMode: Theme.of(context).brightness == Brightness.dark,
            onPressed: onToggleTheme,
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 40, child: Icon(Icons.person, size: 48)),
            SizedBox(height: 16),
            Text('Profile', style: TextStyle(fontSize: 24)),
            SizedBox(height: 8),
            Text('Your profile details go here.'),
          ],
        ),
      ),
    );
  }
}

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({
    required this.isDarkMode,
    required this.onPressed,
    super.key,
  });

  final bool isDarkMode;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: isDarkMode ? 'Switch to light mode' : 'Switch to dark mode',
      onPressed: onPressed,
      icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
    );
  }
}

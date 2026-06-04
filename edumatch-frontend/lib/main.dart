import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'pages/role_selection_page.dart';
import 'pages/siswa/dashboard_page.dart';
import 'pages/tutor/dashboard_page.dart';

// Legacy imports (kept for named‑route access)
import 'models/tutor.dart';
import 'services/api_service.dart';
import 'widgets/tutor_tile.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const EduMatchApp(),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// App root
// ─────────────────────────────────────────────────────────────────────────────

class EduMatchApp extends StatelessWidget {
  const EduMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduMatch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.nunitoTextTheme(),
        colorSchemeSeed: const Color(0xFFF6D365),
      ),
      home: const AuthGate(),
      routes: {
        '/tutors': (context) => const TutorsPage(),
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AuthGate — decides what to show based on auth state
// ─────────────────────────────────────────────────────────────────────────────

/// Calls [AuthProvider.checkAuthStatus] once on init, then reactively
/// switches between the loading screen, role‑selection page, or the
/// correct dashboard.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final auth = context.read<AuthProvider>();
    await auth.checkAuthStatus();
    if (mounted) setState(() => _initialized = true);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    // ── Still checking SharedPreferences ──────────────────────────────
    if (!_initialized || auth.isLoading) {
      return const _JoyfulLoadingScreen();
    }

    // ── Authenticated → route to the right dashboard ─────────────────
    if (auth.isLoggedIn) {
      if (auth.role == 'tutor') {
        return const TutorDashboardPage();
      }
      return const SiswaDashboardPage();
    }

    // ── Not authenticated → role selection ────────────────────────────
    return const RoleSelectionPage();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Joyful Loading Screen
// ─────────────────────────────────────────────────────────────────────────────

class _JoyfulLoadingScreen extends StatefulWidget {
  const _JoyfulLoadingScreen();

  @override
  State<_JoyfulLoadingScreen> createState() => _JoyfulLoadingScreenState();
}

class _JoyfulLoadingScreenState extends State<_JoyfulLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _bounce;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _bounce = Tween<double>(begin: 0.0, end: -18.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF6D365), // mustard
              Color(0xFF96E6A1), // mint
              Color(0xFFA29BFE), // pastel purple
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Bouncing emoji logo
              AnimatedBuilder(
                animation: _bounce,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _bounce.value),
                    child: child,
                  );
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: const Center(
                    child: Text('✨', style: TextStyle(fontSize: 48)),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'EduMatch',
                style: GoogleFonts.nunito(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Memuat kebahagiaan…',
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.85),
                ),
              ),
              const SizedBox(height: 32),
              // Rounded loading indicator
              SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(
                  strokeWidth: 3.5,
                  color: Colors.white,
                  backgroundColor: Colors.white.withOpacity(0.2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Legacy TutorsPage (kept as named route '/tutors')
// ─────────────────────────────────────────────────────────────────────────────

class TutorsPage extends StatefulWidget {
  const TutorsPage({super.key});

  @override
  State<TutorsPage> createState() => _TutorsPageState();
}

class _TutorsPageState extends State<TutorsPage> {
  late Future<List<Tutor>> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService.fetchTutors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tutors')),
      body: FutureBuilder<List<Tutor>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final tutors = snapshot.data ?? [];
          if (tutors.isEmpty) return const Center(child: Text('No tutors found'));
          return ListView.builder(
            itemCount: tutors.length,
            itemBuilder: (context, i) => TutorTile(tutor: tutors[i]),
          );
        },
      ),
    );
  }
}

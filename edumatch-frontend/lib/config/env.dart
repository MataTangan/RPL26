/// ─────────────────────────────────────────────────────────────────────────────
///  EduMatch  ·  Environment / Feature-Flag Config
/// ─────────────────────────────────────────────────────────────────────────────
///
///  Toggle [useMockData] to switch between mock and real network calls:
///
///    true  → All API calls return data from [MockData] (safe for UI dev)
///    false → All API calls hit the real backend at [apiBase]
///
///  INTEGRATION NOTES:
///    • [apiBase] uses `10.0.2.2` which routes to the host machine's localhost
///      from within an Android emulator.
///    • For a physical device on the same network, replace with your machine's
///      local IP address (e.g. `http://192.168.1.x:3000`).
///    • For Chrome / web, use `http://localhost:3000`.
/// ─────────────────────────────────────────────────────────────────────────────

// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';

/// Set to [false] now that the real backend is running.
const bool useMockData = false;

/// Simulated network delay when [useMockData] is [true].
const Duration mockDelay = Duration(milliseconds: 800);

/// Base URL for the real API.
/// 10.0.2.2 → host machine localhost when running on Android emulator.
/// localhost → host machine localhost when running on Web.
final String apiBase = kIsWeb ? 'http://localhost:3000' : 'http://10.0.2.2:3000';

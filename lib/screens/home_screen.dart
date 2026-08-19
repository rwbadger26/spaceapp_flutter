import 'package:flutter/material.dart';
import '../models/apod.dart';
import '../services/apod_service.dart';
import '../widgets/apod_card.dart';
import '../widgets/loading_error_widgets.dart';

/// Main feed screen.
/// StatefulWidget is used because this screen must remember:
/// - whether it is loading
/// - whether there was an error
/// - the list of APOD items
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApodService _apodService = ApodService();

  List<Apod> _apods = [];
  bool _isLoading = true;
  String? _errorMessage; // null means "no error"

  // Runs once when this screen is first created.
  // Perfect place to start the first API call.
  @override
  void initState() {
    super.initState();
    _loadApods();
  }

  Future<void> _loadApods({bool forceRefresh = false}) async {
    // Show spinner and clear any previous error.
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apods = await _apodService.fetchRecentApods(forceRefresh: forceRefresh);

      // setState tells Flutter: "data changed, please rebuild the UI"
      setState(() {
        _apods = apods;
        _isLoading = false;
      });
    } catch (e) {
      // This is a safety net. The service usually returns fallback
      // instead of throwing, but we keep this just in case.
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CosmoPulse'),
      ),
      body: _buildBody(),
    );
  }

  /// Chooses what to show based on current state.
  /// This keeps build() small and easier to read.
  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingWidget();
    }

    if (_errorMessage != null) {
      return ErrorWidgetCustom(
        message: _errorMessage!,
        onRetry: _loadApods, // pass the function itself, don't call it here
      );
    }

    // RefreshIndicator gives us pull-to-refresh for free.
    return RefreshIndicator(
      onRefresh: () => _loadApods(forceRefresh: true),
      color: const Color(0xFF64B5F6),
      child: ListView.builder(
        itemCount: _apods.length,
        // itemBuilder only builds cards that are currently visible.
        // This is more efficient than creating all 20 widgets at once.
        itemBuilder: (context, index) {
          return ApodCard(apod: _apods[index]);
        },
      ),
    );
  }
}
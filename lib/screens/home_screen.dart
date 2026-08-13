import 'package:flutter/material.dart';
import '../models/apod.dart';
import '../services/apod_service.dart';
import '../widgets/apod_card.dart';
import '../widgets/loading_error_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApodService _apodService = ApodService();

  List<Apod> _apods = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadApods();
  }

  Future<void> _loadApods() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apods = await _apodService.fetchRecentApods();
      setState(() {
        _apods = apods;
        _isLoading = false;
      });
    } catch (e) {
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
        title: const Text('SpaceApp'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingWidget();
    }

    if (_errorMessage != null) {
      return ErrorWidgetCustom(
        message: _errorMessage!,
        onRetry: _loadApods,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadApods,
      color: const Color(0xFF64B5F6),
      child: ListView.builder(
        itemCount: _apods.length,
        itemBuilder: (context, index) {
          return ApodCard(apod: _apods[index]);
        },
      ),
    );
  }
}
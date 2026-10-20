import 'package:flutter/material.dart';

import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

enum ReportUiState { idle, loading, success, empty, error }

enum _ReportAction { submit, preview }

class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({super.key});

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  static const Color _teal = Color(0xFF00695C);
  static const List<String> _categories = <String>[
    'Travel Compliance',
    'Document Issue',
    'Incident Report',
    'Itinerary Change',
    'Other',
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _category = _categories.first;
  ReportUiState _uiState = ReportUiState.idle;
  _ReportAction _lastAction = _ReportAction.submit;
  String _statusTitle = '';
  String _statusMessage = '';
  final List<_SubmittedReport> _reports = <_SubmittedReport>[];

  bool get _isSubmitting => _uiState == ReportUiState.loading;

  // Hidden demo trigger: type the word "fail" in any field to simulate a
  // server error. Documented in the evidence report; remove when the real
  // REST API is connected.
  bool get _shouldSimulateFailure {
    final String input = _titleController.text +
        _destinationController.text +
        _descriptionController.text;
    return input.toLowerCase().contains('fail');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _destinationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> submitReport() async {
    if (_isSubmitting) return;
    if (!_formKey.currentState!.validate()) return;

    _lastAction = _ReportAction.submit;
    setState(() {
      _uiState = ReportUiState.loading;
      _statusTitle = 'Submitting report';
      _statusMessage = 'Sending your report to the OIGE office...';
    });

    try {
      // Simulated async submission; replace with the real REST API later.
      await Future<void>.delayed(const Duration(seconds: 3));
      if (_shouldSimulateFailure) {
        throw Exception('Server unreachable');
      }
      if (!mounted) return;
      setState(() {
        _reports.insert(
          0,
          _SubmittedReport(
            title: _titleController.text.trim(),
            category: _category,
            destination: _destinationController.text.trim(),
            description: _descriptionController.text.trim(),
            submittedAt: DateTime.now(),
          ),
        );
        _uiState = ReportUiState.success;
        _statusTitle = 'Report submitted';
        _statusMessage =
            'Your report has been recorded (simulated response). '
            'The OIGE office will review it soon.';
        _titleController.clear();
        _destinationController.clear();
        _descriptionController.clear();
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _uiState = ReportUiState.error;
        _statusTitle = 'Submission failed';
        _statusMessage =
            'The server could not be reached. Please check your '
            'connection and try again.';
      });
    }
  }

  Future<void> previewReports() async {
    if (_isSubmitting) return;
    _lastAction = _ReportAction.preview;
    setState(() {
      _uiState = ReportUiState.loading;
      _statusTitle = 'Loading reports';
      _statusMessage = 'Fetching the latest report records...';
    });

    // Simulated async fetch; replace with the real REST API later.
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    if (_reports.isEmpty) {
      setState(() {
        _uiState = ReportUiState.empty;
        _statusTitle = 'No reports available';
        _statusMessage =
            'There are no report records yet. Create the first report '
            'using the form above.';
      });
    } else {
      setState(() {
        _uiState = ReportUiState.success;
        _statusTitle = 'Reports loaded';
        _statusMessage =
            '${_reports.length} report record(s) are currently available.';
      });
    }
  }

  Future<void> _retry() async {
    if (_lastAction == _ReportAction.preview) {
      await previewReports();
    } else {
      await submitReport();
    }
  }

  void _resetToIdle() {
    setState(() {
      _uiState = ReportUiState.idle;
      _statusTitle = '';
      _statusMessage = '';
    });
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  }

  String? _validateTitle(String? value) {
    final String? requiredError = _validateRequired(value, 'Report title');
    if (requiredError != null) return requiredError;
    if (value!.trim().length < 5) {
      return 'Report title must be at least 5 characters.';
    }
    return null;
  }

  String? _validateDescription(String? value) {
    final String? requiredError = _validateRequired(value, 'Description');
    if (requiredError != null) return requiredError;
    if (value!.trim().length < 10) {
      return 'Description must be at least 10 characters.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: _teal,
        title: const Text(
          'Report Form',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildFormCard(),
                const SizedBox(height: 16),
                _buildStatusPanel(),
                if (_reports.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 16),
                  _buildReportsListCard(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _teal.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _teal.withValues(alpha: 0.25)),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Submit an OIGE Report',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'Report a travel-compliance issue, document problem, or '
              'incident related to international travel monitoring.',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
      );

  Widget _buildFormCard() => Container(
        padding: const EdgeInsets.all(20),
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Report Details',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Report Title',
                controller: _titleController,
                prefixIcon: Icons.title,
                hint: 'e.g. Missing travel clearance form',
                validator: _validateTitle,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category_outlined),
                  border: OutlineInputBorder(),
                ),
                items: _categories
                    .map(
                      (String category) => DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      ),
                    )
                    .toList(),
                onChanged: _isSubmitting
                    ? null
                    : (String? value) {
                        setState(() => _category = value ?? _categories.first);
                      },
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Destination / Location',
                controller: _destinationController,
                prefixIcon: Icons.public,
                hint: 'e.g. Japan, Tokyo Institute of Technology',
                validator: (String? value) =>
                    _validateRequired(value, 'Destination / location'),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Description',
                controller: _descriptionController,
                maxLines: 4,
                prefixIcon: Icons.notes,
                hint: 'Describe the issue or concern in detail...',
                validator: _validateDescription,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: _isSubmitting ? 'Submitting...' : 'Submit Report',
                      icon: _isSubmitting
                          ? Icons.hourglass_top
                          : Icons.send_rounded,
                      onPressed: _isSubmitting ? null : submitReport,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      label: 'Preview Reports',
                      icon: Icons.refresh,
                      onPressed: _isSubmitting ? null : previewReports,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _buildStatusPanel() {
    switch (_uiState) {
      case ReportUiState.idle:
        return const SizedBox.shrink();
      case ReportUiState.loading:
        return _statusContainer(
          color: Colors.blueGrey,
          icon: null,
          child: Row(
            children: [
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _statusTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(_statusMessage,
                        style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 4),
                    const Text(
                      'Please wait — duplicate submissions are disabled.',
                      style: TextStyle(fontSize: 11, color: Colors.black45),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      case ReportUiState.success:
        return _statusContainer(
          color: const Color(0xFF2E7D32),
          icon: Icons.check_circle_outline,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _statusTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 2),
              Text(_statusMessage, style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 12),
              AppButton(
                label: 'Back to Form',
                icon: Icons.edit_outlined,
                onPressed: _resetToIdle,
              ),
            ],
          ),
        );
      case ReportUiState.empty:
        return _statusContainer(
          color: const Color(0xFFEF6C00),
          icon: Icons.inbox_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _statusTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 2),
              Text(_statusMessage, style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 12),
              AppButton(
                label: 'Create a Report',
                icon: Icons.add,
                onPressed: _resetToIdle,
              ),
            ],
          ),
        );
      case ReportUiState.error:
        return _statusContainer(
          color: const Color(0xFFC62828),
          icon: Icons.error_outline,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _statusTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 2),
              Text(_statusMessage, style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 12),
              Row(
                children: [
                  AppButton(
                    label: 'Retry',
                    icon: Icons.refresh,
                    onPressed: _retry,
                  ),
                  const SizedBox(width: 12),
                  AppButton(
                    label: 'Edit Report',
                    icon: Icons.edit_outlined,
                    onPressed: _resetToIdle,
                  ),
                ],
              ),
            ],
          ),
        );
    }
  }

  Widget _statusContainer({
    required Color color,
    required IconData? icon,
    required Widget child,
  }) =>
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.30)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...<Widget>[
              Icon(icon, color: color, size: 26),
              const SizedBox(width: 14),
            ],
            Expanded(child: child),
          ],
        ),
      );

  Widget _buildReportsListCard() => Container(
        padding: const EdgeInsets.all(18),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Submitted Reports',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  '${_reports.length} record(s)',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),
            for (final _SubmittedReport report in _reports)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F7F6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            report.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _teal.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            report.category,
                            style: TextStyle(
                              fontSize: 11,
                              color: _teal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Destination: ${report.destination}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      report.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Submitted: ${report.submittedAt.toLocal()}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
}

class _SubmittedReport {
  const _SubmittedReport({
    required this.title,
    required this.category,
    required this.destination,
    required this.description,
    required this.submittedAt,
  });

  final String title;
  final String category;
  final String destination;
  final String description;
  final DateTime submittedAt;
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';

import '../../../core/theme/pro9_theme.dart';
import '../../../core/services/preferences_service.dart';
import '../cubit/editor_cubit.dart';
import '../data/datasources/ffmpeg_local_data_source.dart';
import '../models/editor_state.dart';

/// Export modal dialog with independent Intro & Outro toggles,
/// conditional Incident Report form fields & validation, and
/// zero-friction FFmpeg auto-configuration.
class ExportReportDialog extends StatefulWidget {
  const ExportReportDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider.value(
        value: context.read<EditorCubit>(),
        child: const ExportReportDialog(),
      ),
    );
  }

  @override
  State<ExportReportDialog> createState() => _ExportReportDialogState();
}

class _ExportReportDialogState extends State<ExportReportDialog> {
  final _formKey = GlobalKey<FormState>();
  final _prefs = PreferencesService();

  late final TextEditingController _monitorCodeCtrl;
  late final TextEditingController _caseNameCtrl;
  late final TextEditingController _incidentTimeCtrl;
  late final TextEditingController _detailsCtrl;

  bool _includeIntro = true;
  bool _includeOutro = true;
  bool _isExporting = false;
  double _progress = 0;
  String _statusMessage = '';
  String? _errorMessage;
  String? _outputDir;
  String? _detectedFfmpegPath;

  @override
  void initState() {
    super.initState();
    final cubitState = context.read<EditorCubit>().state;
    final report = cubitState.incidentReport ?? const IncidentReport();

    _monitorCodeCtrl = TextEditingController(
      text: report.monitorCode.isNotEmpty ? report.monitorCode : _prefs.monitorCode,
    );
    _caseNameCtrl = TextEditingController(text: report.caseName);
    _incidentTimeCtrl = TextEditingController(text: report.incidentTime);
    _detailsCtrl = TextEditingController(text: report.incidentDetails);

    _includeIntro = cubitState.includeIntro;
    _includeOutro = cubitState.includeOutro;

    // Default export directory = Videos\PCut9_Reports
    final userProfile = Platform.environment['USERPROFILE'] ?? 'C:\\Users\\User';
    final defaultReportsDir = '${userProfile}\\Videos\\PCut9_Reports';
    _outputDir = _prefs.defaultExportDir.isNotEmpty
        ? _prefs.defaultExportDir
        : defaultReportsDir;

    // Ensure output directory exists
    try {
      Directory(_outputDir!).createSync(recursive: true);
    } catch (_) {}

    _checkFfmpeg();
  }

  Future<void> _checkFfmpeg() async {
    try {
      final p = await FfmpegLocalDataSource.resolveFfmpegExecutablePath();
      if (mounted) setState(() => _detectedFfmpegPath = p);
    } catch (_) {
      if (mounted) setState(() => _detectedFfmpegPath = null);
    }
  }

  @override
  void dispose() {
    _monitorCodeCtrl.dispose();
    _caseNameCtrl.dispose();
    _incidentTimeCtrl.dispose();
    _detailsCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickCustomFfmpeg() async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Select ffmpeg.exe',
      type: FileType.custom,
      allowedExtensions: ['exe'],
    );

    if (result != null && result.files.single.path != null) {
      final pickedPath = result.files.single.path!;
      _prefs.customFfmpegPath = pickedPath;
      FfmpegLocalDataSource.clearCache();
      await _checkFfmpeg();
      setState(() => _errorMessage = null);
    }
  }

  Future<void> _startExport() async {
    // Only validate incident report fields when Outro is enabled!
    if (_includeOutro && !_formKey.currentState!.validate()) {
      return;
    }

    // Save preferences
    if (_monitorCodeCtrl.text.trim().isNotEmpty) {
      _prefs.monitorCode = _monitorCodeCtrl.text.trim();
    }
    if (_outputDir != null && _outputDir!.isNotEmpty) {
      _prefs.defaultExportDir = _outputDir!;
    }

    final report = IncidentReport(
      monitorCode: _monitorCodeCtrl.text.trim(),
      caseName: _caseNameCtrl.text.trim(),
      incidentTime: _incidentTimeCtrl.text.trim(),
      incidentDetails: _detailsCtrl.text.trim(),
      includeIntro: _includeIntro,
      includeOutro: _includeOutro,
    );

    final cubit = context.read<EditorCubit>();
    cubit.updateIncidentReport(report);

    setState(() {
      _isExporting = true;
      _progress = 0;
      _statusMessage = 'Starting export...';
      _errorMessage = null;
    });

    FfmpegLocalDataSource.onProgress = (p, msg) {
      if (mounted) {
        setState(() {
          _progress = p;
          _statusMessage = msg;
        });
      }
    };

    try {
      final outputPath = await FfmpegLocalDataSource.export(
        clips: cubit.state.clips,
        report: report,
        includeIntro: _includeIntro,
        includeOutro: _includeOutro,
        outputDir: _outputDir!,
      );

      if (mounted) {
        setState(() {
          _isExporting = false;
          _statusMessage = 'Export complete!';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Video exported successfully:\n$outputPath'),
            backgroundColor: Pro9Theme.successGreen,
            duration: const Duration(seconds: 6),
          ),
        );
        Navigator.of(context).pop();
        cubit.resetAfterExport();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isExporting = false;
          _errorMessage = e.toString();
          _statusMessage = 'Export failed';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Pro9Theme.cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Pro9Theme.cardBorder),
      ),
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 760),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTitle(),
                  const SizedBox(height: 20),
                  // ── Independent Intro & Outro Toggles ──────────────────
                  _buildToggles(),
                  const SizedBox(height: 16),
                  const Divider(color: Pro9Theme.cardBorder),
                  const SizedBox(height: 12),
                  // ── Conditional Incident Report Fields ──────────────────
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 250),
                    crossFadeState: _includeOutro
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: _buildFormFields(),
                    secondChild: _buildNoOutroNotice(),
                  ),
                  const SizedBox(height: 18),
                  _buildOutputDirPicker(),
                  const SizedBox(height: 16),
                  _buildFfmpegPathInfo(),
                  const SizedBox(height: 16),
                  if (_errorMessage != null) ...[
                    _buildError(),
                    const SizedBox(height: 16),
                  ],
                  if (_isExporting) ...[
                    _buildProgress(),
                    const SizedBox(height: 16),
                  ],
                  _buildActions(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Pro9Theme.primaryBlue.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.movie_creation, color: Pro9Theme.primaryBlue, size: 24),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Export Report Video',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Pro9Theme.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Configure Intro, Outro, and Incident Report details',
                style: TextStyle(color: Pro9Theme.textMuted, fontSize: 13),
              ),
            ],
          ),
        ),
        if (!_isExporting)
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: Pro9Theme.textMuted),
          ),
      ],
    );
  }

  Widget _buildToggles() {
    return Column(
      children: [
        // 1. Intro Toggle
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Pro9Theme.scaffoldBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Pro9Theme.cardBorder),
          ),
          child: Row(
            children: [
              const Icon(Icons.play_circle, color: Pro9Theme.glowCyan, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Include Fast Logo Intro (إضافة مقدمة اللوجو)',
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Pro9Theme.textPrimary,
                      ),
                    ),
                    const Text(
                      'Prepends animated logo intro sped up to 1.5x',
                      style: TextStyle(color: Pro9Theme.textMuted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _includeIntro,
                onChanged: _isExporting ? null : (v) => setState(() => _includeIntro = v),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // 2. Outro Toggle
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Pro9Theme.scaffoldBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _includeOutro ? Pro9Theme.primaryBlue.withValues(alpha: 0.5) : Pro9Theme.cardBorder,
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.smart_display, color: Pro9Theme.glowCyan, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Include Incident Report Outro (إضافة خاتمة التقرير)',
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Pro9Theme.textPrimary,
                      ),
                    ),
                    const Text(
                      'Appends animated HUD outro with monitor code & report',
                      style: TextStyle(color: Pro9Theme.textMuted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _includeOutro,
                onChanged: _isExporting ? null : (v) => setState(() => _includeOutro = v),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNoOutroNotice() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Pro9Theme.primaryBlue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Pro9Theme.primaryBlue.withValues(alpha: 0.25)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: Pro9Theme.glowCyan, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Outro disabled: Export will merge your CCTV clips directly with Pro 9 neon frame and logo watermark without requiring any report text.',
              style: TextStyle(color: Pro9Theme.textSecondary, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Incident Report Details',
          style: GoogleFonts.montserrat(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Pro9Theme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        // Monitor Code
        TextFormField(
          controller: _monitorCodeCtrl,
          enabled: !_isExporting,
          decoration: const InputDecoration(
            labelText: 'Monitor Code',
            hintText: 'e.g. M002 or A004',
            prefixIcon: Icon(Icons.badge, color: Pro9Theme.textMuted),
          ),
          validator: (v) {
            if (!_includeOutro) return null;
            return (v == null || v.trim().isEmpty) ? 'Required for Outro HUD' : null;
          },
        ),
        const SizedBox(height: 12),
        // Case Name
        TextFormField(
          controller: _caseNameCtrl,
          enabled: !_isExporting,
          decoration: const InputDecoration(
            labelText: 'Case Name (اسم الحالة)',
            hintText: 'e.g. Reported theft incident',
            prefixIcon: Icon(Icons.description, color: Pro9Theme.textMuted),
          ),
          validator: (v) {
            if (!_includeOutro) return null;
            return (v == null || v.trim().isEmpty) ? 'Required for Outro HUD' : null;
          },
        ),
        const SizedBox(height: 12),
        // Incident Time
        TextFormField(
          controller: _incidentTimeCtrl,
          enabled: !_isExporting,
          decoration: const InputDecoration(
            labelText: 'Incident Time (وقت الحالة)',
            hintText: 'DD-MM-YYYY_HH:MM',
            prefixIcon: Icon(Icons.schedule, color: Pro9Theme.textMuted),
          ),
          validator: (v) {
            if (!_includeOutro) return null;
            return (v == null || v.trim().isEmpty) ? 'Required for Outro HUD' : null;
          },
        ),
        const SizedBox(height: 12),
        // Incident Details
        TextFormField(
          controller: _detailsCtrl,
          enabled: !_isExporting,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Incident Details (التفاصيل)',
            hintText: 'Describe what happened...',
            prefixIcon: Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Icon(Icons.notes, color: Pro9Theme.textMuted),
            ),
            alignLabelWithHint: true,
          ),
          validator: (v) {
            if (!_includeOutro) return null;
            return (v == null || v.trim().isEmpty) ? 'Required for Outro HUD' : null;
          },
        ),
      ],
    );
  }

  Widget _buildOutputDirPicker() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Pro9Theme.scaffoldBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Pro9Theme.cardBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.folder, color: Pro9Theme.textMuted, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Output Folder',
                  style: TextStyle(color: Pro9Theme.textSecondary, fontSize: 11),
                ),
                Text(
                  _outputDir ?? 'Not set',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Pro9Theme.textPrimary, fontSize: 12),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _isExporting
                ? null
                : () async {
                    final dir = await FilePicker.platform.getDirectoryPath(
                      dialogTitle: 'Choose export folder',
                    );
                    if (dir != null) setState(() => _outputDir = dir);
                  },
            child: const Text('Browse', style: TextStyle(color: Pro9Theme.glowCyan)),
          ),
        ],
      ),
    );
  }

  Widget _buildFfmpegPathInfo() {
    final isResolved = _detectedFfmpegPath != null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Pro9Theme.cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isResolved
              ? Pro9Theme.cardBorder
              : Pro9Theme.errorRed.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isResolved ? Icons.check_circle : Icons.warning_amber,
            size: 16,
            color: isResolved ? Pro9Theme.successGreen : Pro9Theme.errorRed,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isResolved
                  ? 'FFmpeg Ready: ${_detectedFfmpegPath!}'
                  : 'FFmpeg not detected automatically.',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isResolved ? Pro9Theme.textMuted : Pro9Theme.errorRed,
                fontSize: 11,
                fontFamily: 'monospace',
              ),
            ),
          ),
          TextButton(
            onPressed: _isExporting ? null : _pickCustomFfmpeg,
            child: Text(
              isResolved ? 'Change' : 'Locate ffmpeg.exe',
              style: const TextStyle(color: Pro9Theme.glowCyan, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Pro9Theme.errorRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Pro9Theme.errorRed.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.error_outline, color: Pro9Theme.errorRed, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Pro9Theme.errorRed, fontSize: 12),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: _pickCustomFfmpeg,
              icon: const Icon(Icons.folder_open, size: 16),
              label: const Text('Locate ffmpeg.exe / Auto-Configure'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Pro9Theme.errorRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                _statusMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Pro9Theme.textSecondary, fontSize: 13),
              ),
            ),
            Text(
              '${(_progress * 100).toInt()}%',
              style: const TextStyle(
                color: Pro9Theme.glowCyan,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: _progress,
            minHeight: 8,
            backgroundColor: Pro9Theme.cardBorder,
            valueColor: const AlwaysStoppedAnimation(Pro9Theme.primaryBlue),
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (!_isExporting)
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: Pro9Theme.textSecondary)),
          ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: _isExporting ? null : _startExport,
          icon: _isExporting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.movie_creation),
          label: Text(_isExporting ? 'Exporting...' : 'Export Now'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Pro9Theme.primaryBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
      ],
    );
  }
}

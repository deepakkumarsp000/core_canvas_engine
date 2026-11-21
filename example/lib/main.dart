// FILE: example/lib/main.dart
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// Single import via test_registry (re-exports full Core Canvas Engine API)
import 'test_registry.dart'
    show
    AppTestRegistry,
    CanvasCapabilities,
    CanvasEngineException,
    CanvasExportResult,
    CoreCanvasEngine,
    TargetFormat,
    TestCase;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EngineTesterHome(),
    );
  }
}

class EngineTesterHome extends StatefulWidget {
  const EngineTesterHome({super.key});

  @override
  State<EngineTesterHome> createState() => _EngineTesterHomeState();
}

class _EngineTesterHomeState extends State<EngineTesterHome> {
  bool isProcessing = false;
  String? generatedFilePath;
  CanvasEngineException? lastError;
  CanvasExportResult? lastResult;
  TargetFormat activeFormat = TargetFormat.pdf;
  int renderVersion = 0;

  String selectedCategory = 'All';

  List<String> get availableCategories {
    final Set<String> categories = <String>{'All'};
    for (final TestCase test in AppTestRegistry.getAllTests()) {
      categories.add(test.category ?? 'General');
    }
    return categories.toList();
  }

  List<TestCase> get filteredTests {
    if (selectedCategory == 'All') return AppTestRegistry.getAllTests();
    return AppTestRegistry.getAllTests()
        .where((TestCase t) => (t.category ?? 'General') == selectedCategory)
        .toList();
  }

  late TestCase selectedTest;

  @override
  void initState() {
    super.initState();
    selectedTest = filteredTests.first;
  }

  String _getExtensionForFormat(TargetFormat fmt) {
    switch (fmt) {
      case TargetFormat.png:
        return 'png';
      case TargetFormat.html:
        return 'html';
      case TargetFormat.jpg:
        return 'jpg';
      case TargetFormat.webp:
        return 'webp';
      case TargetFormat.gif:
        return 'gif';
      case TargetFormat.pdf:
        return 'pdf';
    }
  }

  String _getMimeTypeForFormat(TargetFormat fmt) {
    switch (fmt) {
      case TargetFormat.png:
        return 'image/png';
      case TargetFormat.html:
        return 'text/html';
      case TargetFormat.jpg:
        return 'image/jpeg';
      case TargetFormat.webp:
        return 'image/webp';
      case TargetFormat.gif:
        return 'image/gif';
      case TargetFormat.pdf:
        return 'application/pdf';
    }
  }

  void showMsg(String msg, {Color color = const Color(0xFF15803D)}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(color: Colors.white, fontSize: 13.5),
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showCapabilitiesDialog() {
    final CanvasCapabilities caps = CoreCanvasEngine.capabilities;
    final int pingStatus = CoreCanvasEngine.pingEngine();

    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0F172A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF334155)),
          ),
          title: const Text(
            'Native Engine Capabilities',
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Native Ping: ${pingStatus == 200 ? 'OK (200)' : 'UNAVAILABLE ($pingStatus)'}',
                style: TextStyle(
                  color: pingStatus == 200
                      ? const Color(0xFF4ADE80)
                      : Colors.redAccent,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Enabled Modules (Compiled):',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: caps.enabledModules
                    .map(
                      (String m) => Chip(
                    label: Text(
                      m,
                      style: const TextStyle(
                        color: Color(0xFF052E16),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    backgroundColor: const Color(0xFF4ADE80),
                    visualDensity: VisualDensity.compact,
                  ),
                )
                    .toList(),
              ),
              if (caps.disabledModules.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Text(
                  'Disabled Modules (Stripped at Compile Time):',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: caps.disabledModules
                      .map(
                        (String m) => Chip(
                      label: Text(
                        m,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                      backgroundColor: const Color(0xFF334155),
                      visualDensity: VisualDensity.compact,
                    ),
                  )
                      .toList(),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.cyanAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> shareOutputFile() async {
    if (generatedFilePath == null) {
      showMsg(
        'Generate an output file before sharing.',
        color: Colors.orange.shade800,
      );
      return;
    }

    final File outFile = File(generatedFilePath!);
    if (!outFile.existsSync()) {
      showMsg('Output file was not found on disk.', color: Colors.redAccent);
      return;
    }

    try {
      final String mimeType = _getMimeTypeForFormat(activeFormat);
      final String ext = _getExtensionForFormat(activeFormat).toUpperCase();
      final XFile xFile = XFile(outFile.path, mimeType: mimeType);

      await SharePlus.instance.share(
        ShareParams(
          files: <XFile>[xFile],
          text: '${selectedTest.name} ($ext) - Generated by Core Canvas Engine',
        ),
      );
    } catch (e) {
      showMsg('Share failed: $e', color: Colors.redAccent);
    }
  }

  Future<void> fireEngine() async {
    if (selectedTest.needsSvgFile) {
      final PlatformFile? svgFile = await FilePicker.pickFile(
        type: FileType.any,
      );
      if (svgFile != null && svgFile.path != null) {
        try {
          final List<int> fileBytes = await File(svgFile.path!).readAsBytes();
          final String rawSvg = utf8.decode(fileBytes, allowMalformed: true);
          AppTestRegistry.globalCustomSvgPath = jsonEncode(rawSvg);
        } catch (e) {
          showMsg('SVG read error: $e', color: Colors.redAccent);
          return;
        }
      } else if (AppTestRegistry.globalCustomSvgPath.isEmpty) {
        showMsg(
          'Cancelled: no SVG file selected.',
          color: Colors.orange.shade800,
        );
        return;
      }
    }

    if (selectedTest.needsImageFile) {
      final PlatformFile? imgFile = await FilePicker.pickFile(
        type: FileType.image,
      );
      if (imgFile != null && imgFile.path != null) {
        try {
          final List<int> imageBytes = await File(imgFile.path!).readAsBytes();
          AppTestRegistry.globalCustomImagePath = base64Encode(imageBytes);
        } catch (e) {
          showMsg('Image read error: $e', color: Colors.redAccent);
          return;
        }
      } else if (AppTestRegistry.globalCustomImagePath.isEmpty) {
        showMsg(
          'Cancelled: no image file selected.',
          color: Colors.orange.shade800,
        );
        return;
      }
    }

    setState(() {
      isProcessing = true;
      generatedFilePath = null;
      lastError = null;
      lastResult = null;
    });

    try {
      final TargetFormat targetFmt = selectedTest.document.targetFormat;
      final String ext = _getExtensionForFormat(targetFmt);

      String jsonPayload = selectedTest.document.toJsonPayload();

      if (selectedTest.needsSvgFile &&
          AppTestRegistry.globalCustomSvgPath.isNotEmpty) {
        jsonPayload = jsonPayload.replaceAll(
          '"DYNAMIC_SVG_PLACEHOLDER"',
          AppTestRegistry.globalCustomSvgPath,
        );
      }
      if (selectedTest.needsImageFile &&
          AppTestRegistry.globalCustomImagePath.isNotEmpty) {
        jsonPayload = jsonPayload.replaceAll(
          'DYNAMIC_IMAGE_PLACEHOLDER',
          AppTestRegistry.globalCustomImagePath,
        );
      }

      final Directory targetDir = await getApplicationDocumentsDirectory();
      final String fileName = selectedTest.name.replaceAll(
        RegExp(r'[\\/:*?"<>|.\s\[\]()]+'),
        '_',
      );
      final String outputPath = '${targetDir.path}/$fileName.$ext';

      try {
        final File file = File(outputPath);
        if (file.existsSync()) {
          await FileImage(file).evict();
          file.deleteSync();
        }
      } catch (_) {}

      // Enterprise typed export API (Pre-flight capability check + structured diagnostics)
      final CanvasExportResult result = await CoreCanvasEngine.exportFromJson(
        jsonPayload,
        outputPath,
      );

      if (result.isSuccess) {
        await FileImage(File(outputPath)).evict();

        setState(() {
          generatedFilePath = outputPath;
          activeFormat = targetFmt;
          lastResult = result;
          lastError = null;
          renderVersion++;
          isProcessing = false;
        });

        try {
          Directory? downDir;
          if (Platform.isAndroid) {
            downDir = Directory('/storage/emulated/0/Download');
          } else {
            downDir = await getDownloadsDirectory();
          }

          if (downDir != null && downDir.existsSync()) {
            final String downPath = '${downDir.path}/$fileName.$ext';
            File(outputPath).copySync(downPath);
          }
        } catch (_) {}

        showMsg(result.summary);
      } else {
        setState(() {
          isProcessing = false;
          lastResult = result;
          lastError = result.error;
        });
        showMsg(
          result.error?.shortMessage ?? 'Export failed',
          color: const Color(0xFFB91C1C),
        );
      }
    } catch (e) {
      setState(() => isProcessing = false);
      showMsg('Unexpected error: $e', color: Colors.redAccent);
    }
  }

  Widget _buildErrorPanel(CanvasEngineException err) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1B24),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFEF4444), width: 1.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Color(0xFFF87171),
                  size: 22,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    err.errorCode.code,
                    style: const TextStyle(
                      color: Color(0xFFF87171),
                      fontFamily: 'monospace',
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              err.message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (err.cause != null) ...[
              const SizedBox(height: 14),
              const Text(
                'CAUSE',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                err.cause!,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
            if (err.resolution != null) ...[
              const SizedBox(height: 14),
              const Text(
                'RESOLUTION',
                style: TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: SelectableText(
                  err.resolution!,
                  style: const TextStyle(
                    color: Color(0xFF86EFAC),
                    fontFamily: 'monospace',
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOutputViewer() {
    if (lastError != null) {
      return _buildErrorPanel(lastError!);
    }

    if (generatedFilePath == null) {
      return const Center(
        child: Text(
          'Select a test case and tap Generate',
          style: TextStyle(color: Colors.white54, fontSize: 15),
        ),
      );
    }

    final File outFile = File(generatedFilePath!);
    if (!outFile.existsSync()) {
      return const Center(
        child: Text(
          'Output artifact not found on disk.',
          style: TextStyle(color: Colors.redAccent, fontSize: 15),
        ),
      );
    }

    final String timingBadge =
    lastResult != null ? ' • ${lastResult!.elapsed.inMilliseconds} ms' : '';

    if (activeFormat == TargetFormat.pdf) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SfPdfViewer.file(
              outFile,
              key: ValueKey('$generatedFilePath-$renderVersion'),
              canShowScrollHead: false,
              canShowScrollStatus: false,
            ),
          ),
          if (lastResult != null)
            Positioned(
              top: 10,
              right: 10,
              child: _buildTelemetryBadge(
                'PDF • ${(outFile.lengthSync() / 1024).ceil()} KB$timingBadge',
              ),
            ),
        ],
      );
    }

    if (activeFormat == TargetFormat.png ||
        activeFormat == TargetFormat.jpg ||
        activeFormat == TargetFormat.webp ||
        activeFormat == TargetFormat.gif) {
      final int sizeKb = (outFile.lengthSync() / 1024).ceil();
      final String fmtBadge = activeFormat.name.toUpperCase();

      return Stack(
        children: [
          Positioned.fill(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 5.0,
              child: Center(
                child: Image.file(
                  outFile,
                  key: ValueKey('$generatedFilePath-$renderVersion'),
                  gaplessPlayback: true,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: _buildTelemetryBadge('$fmtBadge • $sizeKb KB$timingBadge'),
          ),
        ],
      );
    }

    final String htmlContent = outFile.readAsStringSync();
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blueGrey[900],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.lightBlueAccent),
            ),
            child: Row(
              children: [
                const Icon(Icons.html, color: Colors.lightBlueAccent, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'HTML5 Exported$timingBadge\nPath: ${outFile.path}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: SelectableText(
                htmlContent,
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTelemetryBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.cyanAccent, width: 1.2),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.cyanAccent,
          fontSize: 11.5,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool canShare = !isProcessing && generatedFilePath != null;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text(
          'Core Canvas Engine',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        backgroundColor: Colors.black,
        toolbarHeight: 50,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.cyanAccent),
            tooltip: 'Native Capabilities',
            onPressed: _showCapabilitiesDialog,
          ),
          if (canShare)
            IconButton(
              icon: const Icon(Icons.share, color: Colors.greenAccent),
              tooltip: 'Share Output',
              onPressed: shareOutputFile,
            ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            tooltip: 'Filter Category',
            onSelected: (String category) {
              setState(() {
                selectedCategory = category;
                if (filteredTests.isNotEmpty) {
                  selectedTest = filteredTests.first;
                  generatedFilePath = null;
                  lastError = null;
                }
              });
            },
            itemBuilder: (BuildContext context) {
              return availableCategories.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Row(
                    children: [
                      Icon(
                        selectedCategory == choice
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: selectedCategory == choice
                            ? Colors.blueAccent
                            : Colors.grey,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(choice),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedTest.name,
                        dropdownColor: Colors.white,
                        isExpanded: true,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        items: filteredTests.map((TestCase test) {
                          return DropdownMenuItem<String>(
                            value: test.name,
                            child: Text(
                              test.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newName) {
                          if (newName != null) {
                            setState(() {
                              selectedTest = filteredTests.firstWhere(
                                    (TestCase t) => t.name == newName,
                              );
                              generatedFilePath = null;
                              lastError = null;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 48,
                  width: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed:
                    isProcessing || filteredTests.isEmpty
                        ? null
                        : fireEngine,
                    child: isProcessing
                        ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                        : const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 48,
                  width: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      canShare ? Colors.green[600] : Colors.grey[700],
                      disabledBackgroundColor: Colors.grey[800],
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: canShare ? shareOutputFile : null,
                    child: Icon(
                      Icons.share,
                      color: canShare ? Colors.white : Colors.white38,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white24),
              ),
              child: _buildOutputViewer(),
            ),
          ),
        ],
      ),
    );
  }
}
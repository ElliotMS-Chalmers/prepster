import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prepster/model/repositories/settings_repository.dart';
import 'package:prepster/utils/logger.dart';

import '../../model/repositories/resources_repository.dart';
import '../../model/services/settings_service.dart';

class ResourcesPage extends StatefulWidget {
  const ResourcesPage({super.key});

  @override
  State<ResourcesPage> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  ResourcesRepository? repository;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadResources();
  }

  Future<void> _loadResources() async {
    setState(() {
      isLoading = true;
    });

    try {
      SettingsRepository settings = SettingsRepository(SettingsService.instance);
      String language = await settings.getSelectedLanguage() ?? settings.getFallbackLanguage();

      // Initialize the repository with the language
      repository = await ResourcesRepository.create(language);
      logger.i('Loaded resources with language: $language');
    } catch (e) {
      logger.e('Error loading resources: $e');
      setState(() {
        isLoading = false;
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _openPdfViewer(String title, String assetPath) async {
    try {
      // Get the temporary directory to store the PDF file
      final dir = await getTemporaryDirectory();
      final String fileName = assetPath.split('/').last;
      final File file = File('${dir.path}/$fileName');

      // Check if the file already exists
      if (!file.existsSync()) {
        // Copy the asset to a temporary file
        final ByteData data = await rootBundle.load(assetPath);
        final List<int> bytes = data.buffer.asUint8List();
        await file.writeAsBytes(bytes);
        logger.i('Copied asset to temporary file: ${file.path}');
      }

      // now open the file
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewerPage(title: title, filePath: file.path),
        ),
      );
    } catch (e) {
      logger.e('Error opening PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening PDF: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resources'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : repository!.data.isEmpty
          ? const Center(child: Text('No resources available'))
          : ListView.builder(
        itemCount: repository!.data.length,
        itemBuilder: (context, index) {
          final resourceName = repository!.data[index][0];
          final resourcePath = repository!.data[index][1];

          return ListTile(
            title: Text(resourceName),
            leading: const Icon(Icons.picture_as_pdf),
            onTap: () => _openPdfViewer(resourceName, resourcePath),
          );
        },
      ),
    );
  }
}

class PdfViewerPage extends StatefulWidget {
  final String title;
  final String filePath;

  const PdfViewerPage({
    super.key,
    required this.title,
    required this.filePath,
  });

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  final Completer<PDFViewController> _controller = Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (pages != null && pages! > 0)
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Center(
                child: Text(
                  '${(currentPage ?? 0) + 1} / $pages',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          PDFView(
            filePath: widget.filePath,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: false,
            backgroundColor: Colors.grey,
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              print(error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onPageChanged: (page, total) {
              setState(() {
                currentPage = page;
              });
              print('page change: $page/$total');
            },
          ),
          !isReady
              ? const Center(child: CircularProgressIndicator())
              : Container(),
          errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : Container(),
        ],
      ),
    );
  }
}
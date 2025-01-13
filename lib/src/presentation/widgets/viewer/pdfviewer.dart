import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerWidget extends StatefulWidget {
  final String pdfData;

  const PdfViewerWidget({super.key, required this.pdfData});

  @override
  State<PdfViewerWidget> createState() => _PdfViewerWidgetState();
}

class _PdfViewerWidgetState extends State<PdfViewerWidget> {
  final PdfViewerController _pdfViewerController = PdfViewerController();

  double _dialogHeight = Get.height * 0.6;

  void _updateDialogHeight(int pageCount) {
    setState(() {
      _dialogHeight = pageCount > 1 ? Get.height * 0.8 : Get.height * 0.6;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.9,
      height: _dialogHeight,
      child: SfPdfViewer.file(
        File(widget.pdfData),
        controller: _pdfViewerController,
        onDocumentLoaded: (details) {
          _updateDialogHeight(details.document.pages.count);
        },
        key: const Key('pdfViewerKey'),
      ),
    );
  }
}

void fetchAndShowPdfDialog(BuildContext context, String response) {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Container(
        width: Get.width * 0.9,
        height: 600,
        child: Column(
          children: [
            Container(
              color: Theme.of(context).appBarTheme.backgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () async {
                      await OpenFile.open(response);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ],
              ),
            ),
            PdfViewerWidget(pdfData: response),
          ],
        ),
      ),
    ),
    barrierDismissible: false,
  );
}

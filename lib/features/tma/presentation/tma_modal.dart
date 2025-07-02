import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tg_test/constants/modal_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Модальне вікно з WebView
class TmaModal extends StatefulWidget {
  /// URL-Адресса, яка буде завантажуватися у WebView
  final String url;

  /// Конструктор [TmaModal] з URL, переданим до конструктору
  const TmaModal({required this.url, super.key});

  @override
  State<TmaModal> createState() => _TmaModalState();
}

class _TmaModalState extends State<TmaModal> {
  /// Контроллер WebView
  final WebViewController _controller = WebViewController();

  /// Контроллер для відстеження положення модального вікна
  final DraggableScrollableController _draggableController =
      DraggableScrollableController();

  /// Чи завантажується WebView
  bool isLoading = true;

  /// Чи знаходиться модальне вікно в розгорнутому стані
  bool isAtBottom = true;

  @override
  void initState() {
    super.initState();

    // Налаштування WebView
    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            setState(() => isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));

    // Слухач положення DraggableScrollableSheet
    _draggableController.addListener(() {
      final position = _draggableController.size;
      setState(() {
        isAtBottom = position > ModalConstants.minExtent;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size.width;

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: DraggableScrollableSheet(
        controller: _draggableController,
        minChildSize: ModalConstants.minExtent,
        maxChildSize: ModalConstants.maxExtent,
        expand: false,
        shouldCloseOnMinExtent: false,
        builder: (_, scrollController) {
          return isLoading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : ListView(
                  controller: scrollController,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    // Верхній бар з кнопкою
                    Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.grey.shade900),
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Ліва кнопка: Done или Close
                          if (!isAtBottom)
                            IconButton(
                              onPressed: () => Navigator.maybePop(context),
                              icon: const Icon(
                                Icons.close,
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                          if (isAtBottom)
                            TextButton(
                              onPressed: () {
                                _draggableController.animateTo(
                                  ModalConstants.minExtent,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },

                              child: const Text(
                                'Done',
                                style: TextStyle(
                                  color: Colors.indigoAccent,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          const Text(
                            'TMB ModalSheet',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: screenSize * 0.1),
                        ],
                      ),
                    ),

                    // WebView
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.85,
                      child: WebViewWidget(
                        controller: _controller,
                        gestureRecognizers: const {
                          Factory<OneSequenceGestureRecognizer>(
                            EagerGestureRecognizer.new,
                          ),
                        },
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }

  @override
  void dispose() {
    _draggableController.dispose();
    super.dispose();
  }
}

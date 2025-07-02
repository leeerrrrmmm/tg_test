import 'package:flutter/material.dart';
import 'package:tg_test/features/tma/presentation/tma_modal.dart';

/// Кнопка, яка відкриває модальне вікно з WebView при натисканні
class TmaButton extends StatelessWidget {
  /// Конструктор [TmaButton]
  const TmaButton({super.key});

  /// Метод для відображення [showTmaModal]
  void showTmaModal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const TmaModal(url: 'https://pub.dev'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => showTmaModal(context),
      child: const Text('Показати модальне вікно'),
    );
  }
}

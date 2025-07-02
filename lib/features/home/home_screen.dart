import 'package:flutter/material.dart';
import 'package:tg_test/features/tma/widgets/tma_button.dart';

/// Головний екран застосунку, що показує кнопку для відкриття модального вікна
class HomeScreen extends StatelessWidget {
  /// Конструктор головного екрану
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(child: TmaButton()),
    );
  }
}

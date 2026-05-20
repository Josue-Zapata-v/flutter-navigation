import 'package:flutter/material.dart';
import '../models/faq_item.dart';
import '../models/faq_data.dart';
import '../theme/app_theme.dart';
import '../theme/app_routes.dart';
import '../widgets/app_drawer.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preguntas Frecuentes'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color:        AppTheme.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${faqData.length} preguntas',
                  style: const TextStyle(
                    color:      AppTheme.primary,
                    fontSize:   13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(currentRoute: AppRoutes.faq),
      body: Column(
        children: [
          // ── Header decorativo ──────────────────────────────────────────
          _FaqHeader(),

          // ── Lista de preguntas ─────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              padding:     const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount:   faqData.length,
              itemBuilder: (context, index) => _FaqTile(
                item:  faqData[index],
                index: index,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Header de FAQ ────────────────────────────────────────────────────────────
class _FaqHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      color:   AppTheme.surface,
      child: Row(
        children: [
          Container(
            padding:    const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color:        AppTheme.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.help_outline_rounded,
              color: AppTheme.primary,
              size:  22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Centro de Ayuda',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'Respuestas a las preguntas más comunes',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tile de una FAQ ──────────────────────────────────────────────────────────
class _FaqTile extends StatelessWidget {
  final FaqItem item;
  final int     index;

  const _FaqTile({required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 4,
            ),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            leading: Container(
              width:      32,
              height:     32,
              decoration: BoxDecoration(
                color:        AppTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color:      AppTheme.primary,
                    fontWeight: FontWeight.w700,
                    fontSize:   13,
                  ),
                ),
              ),
            ),
            title: Text(
              item.question,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            children: [
              const Divider(height: 1),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:        AppTheme.background.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: AppTheme.accent,
                      size:  18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item.answer,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.55,
                          color:  AppTheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
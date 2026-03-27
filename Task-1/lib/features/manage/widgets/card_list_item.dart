// lib/features/manage/widgets/card_list_item.dart

import 'package:flutter/material.dart';
import '../../../data/models/flashcard.dart';

class CardListItem extends StatelessWidget {
  final Flashcard card;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const CardListItem({
    super.key,
    required this.card,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(card.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red.shade100,
        child: Icon(Icons.delete, color: Colors.red.shade700),
      ),
      onDismissed: (_) => onDelete(),
      child: ListTile(
        onTap: onTap,
        title: Text(
          card.question,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          card.answer,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.grey.shade600),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

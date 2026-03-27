// lib/features/manage/manage_screen.dart

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'manage_controller.dart';
import 'widgets/card_list_item.dart';
import 'widgets/card_form_sheet.dart';

class ManageScreen extends GetView<ManageController> {
  const ManageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Deck'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_upload_outlined),
            tooltip: 'Import CSV',
            onPressed: () => controller.importFromCsv(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => CardFormSheet.show(),
        label: const Text('Add Card'),
        icon: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search flashcards...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) => controller.searchQuery.value = value,
            ),
          ),

          // Card List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.allCards.isEmpty) {
                return const Center(
                  child: Text('Your deck is empty.\nTap + to add cards!'),
                );
              }

              if (controller.filteredCards.isEmpty) {
                return const Center(
                  child: Text('No matching flashcards found.'),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: controller.filteredCards.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final card = controller.filteredCards[index];
                  return CardListItem(
                    card: card,
                    onTap: () => CardFormSheet.show(card: card),
                    onDelete: () => controller.deleteCard(card.id),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

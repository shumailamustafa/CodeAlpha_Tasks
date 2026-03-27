import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_controller.dart';
import 'widgets/flip_card.dart';
import '../../app/routes/app_routes.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'FlashMind',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.dashboard_customize_rounded),
            onPressed: () => Get.toNamed(Routes.manage),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.cards.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.layers_clear_outlined,
                    size: 100,
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No flashcards yet!',
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Create some to start learning',
                    style: GoogleFonts.outfit(color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () => Get.toNamed(Routes.manage),
                    icon: const Icon(Icons.add),
                    label: const Text('Go to Manage'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              const SizedBox(height: kToolbarHeight + 40),
              // Progress indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'YOUR PROGRESS',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Text(
                          '${controller.currentIndex.value + 1}/${controller.cards.length}',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: (controller.currentIndex.value + 1) /
                            controller.cards.length,
                        minHeight: 8,
                        backgroundColor:
                            Theme.of(context).primaryColor.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  itemCount: controller.cards.length,
                  onPageChanged: controller.onPageChanged,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final card = controller.cards[index];
                    
                    return Obx(() {
                      return AnimatedBuilder(
                        animation: controller.pageController,
                        builder: (context, child) {
                          double value = 1.0;
                          if (controller.pageController.position.haveDimensions) {
                            value = controller.pageController.page! - index;
                            value = (1 - (value.abs() * 0.2)).clamp(0.0, 1.0);
                          }
                          return Center(
                            child: SizedBox(
                              height: Curves.easeOut.transform(value) * 600,
                              width: Curves.easeOut.transform(value) * 400,
                              child: child,
                            ),
                          );
                        },
                        child: FlipCard(
                          isFlipped: controller.currentIndex.value == index &&
                              controller.isFlipped.value,
                          onTap: controller.toggleFlip,
                          front: _buildCardFace(
                            context,
                            card.question,
                            'QUESTION',
                            [Colors.blue.shade400, Colors.blue.shade700],
                          ),
                          back: _buildCardFace(
                            context,
                            card.answer,
                            'ANSWER',
                            [Colors.teal.shade400, Colors.teal.shade700],
                          ),
                        ),
                      );
                    });
                  },
                ),
              ),

              const SizedBox(height: 32),

              // Custom Navigation Controls
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _navButton(
                      icon: Icons.chevron_left_rounded,
                      onPressed: controller.currentIndex.value > 0
                          ? controller.previousCard
                          : null,
                    ),
                    const SizedBox(width: 40),
                    _navButton(
                      icon: Icons.chevron_right_rounded,
                      onPressed: controller.currentIndex.value <
                              controller.cards.length - 1
                          ? controller.nextCard
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildCardFace(BuildContext context, String text, String label, List<Color> colors) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.last.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative patterns
          Positioned(
            right: -20,
            top: -20,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white.withOpacity(0.1),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 4,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const Spacer(),
                Expanded(
                  flex: 10,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 28,
                          height: 1.3,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.touch_app_outlined,
                  color: Colors.white.withOpacity(0.5),
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navButton({required IconData icon, VoidCallback? onPressed}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: onPressed != null ? Colors.white : Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          boxShadow: onPressed != null ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: Icon(
          icon,
          size: 32,
          color: onPressed != null ? Colors.blue.shade700 : Colors.grey.shade400,
        ),
      ),
    );
  }
}

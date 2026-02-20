import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../core/constants.dart';
import '../core/font_styles.dart';
import '../core/responsive.dart';
import '../core/widgets.dart';
import '../viewmodels/app_viewmodel.dart';

class ProjectDetailView extends ConsumerWidget {
  final String projectId;
  const ProjectDetailView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectAsync = ref.watch(projectByIdProvider(projectId));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Project Details"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: projectAsync.when(
        data: (project) {
          if (project == null) return const Center(child: Text("Project not found"));
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Image
                Hero(
                  tag: 'project_${project.id}',
                  child: CachedNetworkImage(
                    imageUrl: project.imageUrl,
                    width: double.infinity,
                    height: 400,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const ShimmerBox(width: double.infinity, height: 400),
                  ),
                ),
                
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.isDesktop(context) ? 100 : 20,
                    vertical: 40,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(project.title, style: AppFontStyles.h2),
                      const SizedBox(height: 10),
                      Text(project.description, style: AppFontStyles.h3.copyWith(color: AppConstants.primaryColor)),
                      const SizedBox(height: 30),
                      
                      // Vlog Section
                      const SectionHeader(title: "Project Vlog", subtitle: "See Our Impact in Motion"),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        height: Responsive.isDesktop(context) ? 500 : 250,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Opacity(
                              opacity: 0.6,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  imageUrl: project.imageUrl,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.play_circle_fill, color: Colors.white.withOpacity(0.9), size: 80),
                                const SizedBox(height: 10),
                                const Text(
                                  "Watch the Story",
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 50),
                      
                      // Detailed Content
                      const SectionHeader(title: "The Story", subtitle: "A Journey of Hope"),
                      const SizedBox(height: 20),
                      Text(
                        project.longDescription,
                        style: AppFontStyles.bodyLarge,
                      ),
                      const SizedBox(height: 20),
                      // Multi-paragraph support
                      Text(
                        "Through your generous contributions, we've been able to expand our reach and provide sustainable solutions that the communities can maintain themselves. This isn't just a temporary fix; it's a foundation for a brighter future. Every dollar donated goes directly into the field, ensuring maximum impact for those who need it most.\n\nWe continue to monitor our progress and adapt our strategies based on real-time feedback from local partners. Together, we are building a legacy of change that will be felt for generations to come. Thank you for being a part of the BrightLemon Foundation family.",
                        style: AppFontStyles.bodyLarge,
                      ),
                      
                      const SizedBox(height: 60),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                          ),
                          child: const Text("Support This Cause Now"),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Footer
                Container(
                  width: double.infinity,
                  color: AppConstants.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text(
                      "© 2026 BrightLemon Foundation. All Rights Reserved.",
                      style: AppFontStyles.bodyMedium.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text("Error: $e")),
      ),
    );
  }
}

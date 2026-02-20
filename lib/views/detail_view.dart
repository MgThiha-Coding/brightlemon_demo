import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../core/constants.dart';
import '../core/font_styles.dart';
import '../core/responsive.dart';
import '../core/widgets.dart';
import '../viewmodels/app_viewmodel.dart';
import '../core/footer.dart';

class ProjectDetailView extends ConsumerWidget {
  final String projectId;
  const ProjectDetailView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectAsync = ref.watch(projectByIdProvider(projectId));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text("Project Details"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
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
                      
                      // Project Showcase Image (Static)
                      const SectionHeader(title: "Project Impact", subtitle: "Visualizing Our Progress"),
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          imageUrl: project.imageUrl,
                          width: double.infinity,
                          height: Responsive.isDesktop(context) ? 500 : 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 50),
                      
                      // Vlog Section (Text-based)
                      if (project.vlogContent != null) ...[
                        const SectionHeader(title: "Project Diary", subtitle: "Latest Project Vlog"),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppConstants.primaryColor.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppConstants.primaryColor.withOpacity(0.1)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: AppConstants.primaryColor,
                                    child: const Icon(Icons.edit_note, color: Colors.white),
                                  ),
                                  const SizedBox(width: 15),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Field Officer Update", style: AppFontStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppConstants.textMainColor)),
                                      Text("Feb 21, 2026", style: AppFontStyles.bodyMedium.copyWith(fontSize: 12)),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                project.vlogContent!,
                                style: AppFontStyles.bodyLarge.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: AppConstants.textSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),
                      ],
                      
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
                        child: ModernButton(
                          onPressed: () {},
                          text: "Support This Cause Now",
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Footer
                const FooterSection(),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../core/constants.dart';
import '../core/font_styles.dart';
import '../core/responsive.dart';
import '../core/widgets.dart';
import '../viewmodels/app_viewmodel.dart';
import '../models/app_models.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  @override
  ConsumerState<MainView> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  final List<String> _sections = [
    'Home',
    'About',
    'Projects',
    'Gallery',
    'Contact',
  ];

  @override
  void initState() {
    super.initState();
    _itemPositionsListener.itemPositions.addListener(_updateActiveSection);
  }

  void _updateActiveSection() {
    final positions = _itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return;

    // Find the item that is most prominent in the viewport
    int current = positions
        .where((pos) => pos.itemLeadingEdge < 0.5 && pos.itemTrailingEdge > 0.1)
        .fold(-1, (prev, pos) => pos.index);

    if (current != -1 && ref.read(activeSectionProvider) != current) {
      // Use microtask to avoid building while notifying
      Future.microtask(
        () => ref.read(activeSectionProvider.notifier).state = current,
      );
    }
  }

  void _scrollToSection(int index) {
    _itemScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildNavbar(context),
      drawer: Responsive.isMobile(context) ? _buildDrawer() : null,
      body: ScrollablePositionedList.builder(
        itemCount: _sections.length,
        itemScrollController: _itemScrollController,
        itemPositionsListener: _itemPositionsListener,
        itemBuilder: (context, index) {
          switch (index) {
            case 0:
              return const HomeSection();
            case 1:
              return const AboutSection();
            case 2:
              return const ProjectsSection();
            case 3:
              return const GallerySection();
            case 4:
              return const ContactSection();
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }

  PreferredSizeWidget _buildNavbar(BuildContext context) {
    final activeIndex = ref.watch(activeSectionProvider);
    final isDesktop = Responsive.isDesktop(context);

    return AppBar(
      backgroundColor: Colors.white.withOpacity(0.9),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      title: Text(
        AppConstants.appName.toUpperCase(),
        style: AppFontStyles.h3.copyWith(
          color: AppConstants.primaryColor,
          letterSpacing: 2,
        ),
      ),
      actions: isDesktop
          ? [
              ..._sections.asMap().entries.map((entry) {
                final index = entry.key;
                final label = entry.value;
                final isActive = activeIndex == index;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextButton(
                    onPressed: () => _scrollToSection(index),
                    child: Text(
                      label,
                      style: AppFontStyles.navLink.copyWith(
                        color: isActive
                            ? AppConstants.primaryColor
                            : AppConstants.textSecondaryColor,
                        fontWeight: isActive
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(width: 20),
            ]
          : null,
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Center(
              child: Text(
                AppConstants.appName,
                style: AppFontStyles.h3.copyWith(
                  color: AppConstants.primaryColor,
                ),
              ),
            ),
          ),
          ..._sections.asMap().entries.map((entry) {
            return ListTile(
              title: Text(entry.value),
              onTap: () {
                Navigator.pop(context);
                _scrollToSection(entry.key);
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}

// --- SECTIONS ---

class HomeSection extends ConsumerWidget {
  const HomeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeData = ref.watch(homeDataProvider);
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.8 - kToolbarHeight,
      width: double.infinity,
      child: Stack(
        children: [
          // Banner Background
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl:
                  'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?auto=format&fit=crop&w=1920&q=80',
              fit: BoxFit.cover,
              placeholder: (context, url) => const ShimmerBox(
                width: double.infinity,
                height: double.infinity,
                borderRadius: 0,
              ),
            ),
          ),
          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.isDesktop(context) ? 100 : 40,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                homeData.when(
                  data: (text) => ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: Text(
                      text,
                      style: AppFontStyles.h1.copyWith(
                        color: Colors.white,
                        fontSize: Responsive.isDesktop(context) ? 56 : 36,
                      ),
                    ),
                  ),
                  loading: () => const ShimmerBox(width: 600, height: 100),
                  error: (e, s) => const Text("Welcome to Lemon Solution"),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Support Our Mission"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AboutSection extends ConsumerWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aboutData = ref.watch(aboutDataProvider);
    final isDesktop = Responsive.isDesktop(context);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 100,
        horizontal: isDesktop ? 100 : 20,
      ),
      child: Column(
        children: [
          const SectionHeader(
            title: "Our Mission",
            subtitle: "Compassion in Action",
          ),
          const SizedBox(height: 60),
          aboutData.when(
            data: (data) => Column(
              children: [
                Responsive(
                  desktop: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['title']!, style: AppFontStyles.h3),
                            const SizedBox(height: 20),
                            Text(
                              data['description']!,
                              style: AppFontStyles.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 60),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            imageUrl: data['imageUrl']!,
                            height: 400,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const ShimmerBox(
                              width: double.infinity,
                              height: 400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  mobile: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          imageUrl: data['imageUrl']!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(data['title']!, style: AppFontStyles.h3),
                      const SizedBox(height: 20),
                      Text(
                        data['description']!,
                        style: AppFontStyles.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            loading: () =>
                const ShimmerBox(width: double.infinity, height: 400),
            error: (e, s) => const Text("Error loading content"),
          ),
        ],
      ),
    );
  }
}

class ProjectsSection extends ConsumerWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsData = ref.watch(projectsDataProvider);
    final isDesktop = Responsive.isDesktop(context);

    return Container(
      color: AppConstants.cardColor,
      padding: EdgeInsets.symmetric(
        vertical: 100,
        horizontal: isDesktop ? 100 : 20,
      ),
      child: Column(
        children: [
          const SectionHeader(
            title: "Our Causes",
            subtitle: "Project Impact Areas",
          ),
          const SizedBox(height: 60),
          projectsData.when(
            data: (projects) => GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isDesktop
                    ? 3
                    : (Responsive.isTablet(context) ? 2 : 1),
                crossAxisSpacing: 30,
                mainAxisSpacing: 30,
                childAspectRatio: 1.2,
              ),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return _ProjectCard(project: project);
              },
            ),
            loading: () => GridView.count(
              shrinkWrap: true,
              crossAxisCount: isDesktop ? 3 : 1,
              mainAxisSpacing: 30,
              crossAxisSpacing: 30,
              children: List.generate(
                3,
                (i) => const ShimmerBox(width: 300, height: 300),
              ),
            ),
            error: (e, s) => const Text("Error loading activities"),
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final ProjectModel project;
  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/project/${project.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: Hero(
                  tag: 'project_${project.id}',
                  child: CachedNetworkImage(
                    imageUrl: project.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const ShimmerBox(
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.title,
                    style: AppFontStyles.h3.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    project.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppFontStyles.bodyMedium,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Learn More",
                    style: TextStyle(
                      color: AppConstants.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GallerySection extends ConsumerWidget {
  const GallerySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final galleryData = ref.watch(galleryDataProvider);
    final isDesktop = Responsive.isDesktop(context);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 100,
        horizontal: isDesktop ? 100 : 20,
      ),
      child: Column(
        children: [
          const SectionHeader(
            title: "Impact Gallery",
            subtitle: "Moments of Change",
          ),
          const SizedBox(height: 60),
          galleryData.when(
            data: (images) => GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isDesktop
                    ? 4
                    : (Responsive.isTablet(context) ? 3 : 2),
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) => ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: images[index].imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const ShimmerBox(width: 150, height: 150),
                ),
              ),
            ),
            loading: () =>
                const ShimmerBox(width: double.infinity, height: 400),
            error: (e, s) => const Text("Error loading gallery"),
          ),
        ],
      ),
    );
  }
}

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    return Container(
      color: AppConstants.primaryColor,
      padding: EdgeInsets.symmetric(
        vertical: 100,
        horizontal: isDesktop ? 100 : 20,
      ),
      child: Column(
        children: [
          const SectionHeader(
            title: "Join Us",
            subtitle: "Every Contribution Matters",
            light: true,
          ),
          const SizedBox(height: 60),
          Responsive(
            desktop: Row(
              children: [
                Expanded(child: _buildContactInfo()),
                const SizedBox(width: 80),
                Expanded(child: _buildContactForm()),
              ],
            ),
            mobile: Column(
              children: [
                _buildContactInfo(),
                const SizedBox(height: 60),
                _buildContactForm(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoItem(
          Icons.location_on,
          "123 Innovation Drive, Silicon Valley, CA",
        ),
        const SizedBox(height: 20),
        _infoItem(Icons.email, "hello@lemonsolution.com"),
        const SizedBox(height: 20),
        _infoItem(Icons.phone, "+1 (555) 789-2345"),
      ],
    );
  }

  Widget _infoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(width: 20),
        Expanded(
          child: Text(
            text,
            style: AppFontStyles.bodyMedium.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildContactForm() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const TextField(decoration: InputDecoration(hintText: "Name")),
          const SizedBox(height: 20),
          const TextField(decoration: InputDecoration(hintText: "Email")),
          const SizedBox(height: 20),
          const TextField(
            maxLines: 4,
            decoration: InputDecoration(hintText: "Message"),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text("Send Message"),
            ),
          ),
        ],
      ),
    );
  }
}

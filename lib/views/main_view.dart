import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../core/constants.dart';
import '../core/font_styles.dart';
import '../core/responsive.dart';
import '../core/widgets.dart';
import '../core/scroll_reveal.dart';
import '../viewmodels/app_viewmodel.dart';
import '../models/app_models.dart';
import '../core/footer.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  @override
  ConsumerState<MainView> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  bool _showBackToTop = false;

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
    
    // Restore scroll position after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final savedIndex = ref.read(scrollOffsetProvider);
      if (savedIndex != 0) {
        _itemScrollController.jumpTo(index: savedIndex);
      }
    });
  }

  void _updateActiveSection() {
    final positions = _itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return;

    // Find the item that is most prominent in the viewport
    int current = positions
        .where((pos) => pos.itemLeadingEdge < 0.5 && pos.itemTrailingEdge > 0.1)
        .fold(-1, (prev, pos) => pos.index);

    if (current != -1) {
      if (ref.read(activeSectionProvider) != current) {
        Future.microtask(
          () => ref.read(activeSectionProvider.notifier).state = current,
        );
      }
      // Save current position for restoration
      if (ref.read(scrollOffsetProvider) != current) {
        Future.microtask(
          () => ref.read(scrollOffsetProvider.notifier).state = current,
        );
      }
    }

    // Update back to top visibility
    final firstItem = positions.first;
    final show = firstItem.index > 0 || firstItem.itemLeadingEdge < -0.2;
    if (show != _showBackToTop) {
      setState(() {
        _showBackToTop = show;
      });
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
        itemCount: _sections.length + 1,
        itemScrollController: _itemScrollController,
        itemPositionsListener: _itemPositionsListener,
        itemBuilder: (context, index) {
          switch (index) {
            case 0:
              return const HomeSection();
            case 1:
              return const ScrollReveal(
                duration: Duration(milliseconds: 900),
                slideOffset: 50,
                child: AboutSection(),
              );
            case 2:
              return const ScrollReveal(
                duration: Duration(milliseconds: 900),
                slideOffset: 50,
                child: ProjectsSection(),
              );
            case 3:
              return const ScrollReveal(
                duration: Duration(milliseconds: 900),
                slideOffset: 50,
                child: GallerySection(),
              );
            case 4:
              return const ScrollReveal(
                duration: Duration(milliseconds: 900),
                slideOffset: 50,
                child: ContactSection(),
              );
            case 5:
              return const ScrollReveal(
                duration: Duration(milliseconds: 600),
                slideOffset: 20,
                child: FooterSection(),
              );
            default:
              return const SizedBox();
          }
        },
      ),
      floatingActionButton: _showBackToTop
          ? FloatingActionButton(
              onPressed: () => _scrollToSection(0),
              backgroundColor: AppConstants.primaryColor,
              mini: true,
              child: const Icon(Icons.keyboard_arrow_up, color: Colors.white),
            )
          : null,
    );
  }

  PreferredSizeWidget _buildNavbar(BuildContext context) {
    final activeIndex = ref.watch(activeSectionProvider);
    final isDesktop = Responsive.isDesktop(context);

    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: RichText(
        text: TextSpan(
          style: AppFontStyles.h3.copyWith(
            color: AppConstants.primaryColor,
            letterSpacing: -1,
          ),
          children: const [
            TextSpan(
              text: 'Lemon',
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
            TextSpan(
              text: 'Bright',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            TextSpan(
              text: ' Foundation',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
            ),
          ],
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
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.05),
            ),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: AppFontStyles.h3.copyWith(
                  color: AppConstants.primaryColor,
                  letterSpacing: -0.5,
                ),
                children: const [
                  TextSpan(
                    text: 'Lemon',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  TextSpan(
                    text: 'Bright',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: _sections.asMap().entries.map((entry) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    title: Text(
                      entry.value,
                      style: AppFontStyles.navLink.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _scrollToSection(entry.key);
                    },
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              "© 2026 LemonBright Foundation",
              style: AppFontStyles.bodyMedium.copyWith(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// --- SECTIONS ---

class HomeSection extends ConsumerStatefulWidget {
  const HomeSection({super.key});

  @override
  ConsumerState<HomeSection> createState() => _HomeSectionState();
}

class _HomeSectionState extends ConsumerState<HomeSection>
    with TickerProviderStateMixin {
  // --- Image Carousel ---
  static const _heroImages = [
    'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?auto=format&fit=crop&w=1920&q=80',
    'https://images.unsplash.com/photo-1509099836639-18ba1795216d?auto=format&fit=crop&w=1920&q=80',
    'https://images.unsplash.com/photo-1593113598332-cd288d649433?auto=format&fit=crop&w=1920&q=80',
    'https://images.unsplash.com/photo-1517677208171-0bc6725a3e60?auto=format&fit=crop&w=1920&q=80',
  ];
  int _currentImageIndex = 0;

  // --- Text Entrance Animation ---
  late final AnimationController _textController;
  late final Animation<double> _titleOpacity;
  late final Animation<double> _titleSlide;
  late final Animation<double> _buttonOpacity;
  late final Animation<double> _buttonSlide;

  // --- Image Crossfade Animation ---
  late final AnimationController _imageController;
  late final Animation<double> _imageFade;
  bool _carouselStarted = false;

  @override
  void initState() {
    super.initState();

    // Text entrance: 1200ms total, title first then button
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _titleOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _textController, curve: const Interval(0.0, 0.6, curve: Curves.easeOut)),
    );
    _titleSlide = Tween<double>(begin: 40, end: 0).animate(
      CurvedAnimation(parent: _textController, curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic)),
    );
    _buttonOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _textController, curve: const Interval(0.4, 1.0, curve: Curves.easeOut)),
    );
    _buttonSlide = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: _textController, curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic)),
    );

    // Image crossfade: 1200ms smooth transition
    _imageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _imageFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _imageController, curve: Curves.easeInOut),
    );

    // Start text animation after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _textController.forward().then((_) {
          // After text animation completes, start the image carousel
          if (mounted) _startCarousel();
        });
      }
    });
  }

  void _startCarousel() {
    _carouselStarted = true;
    Future.delayed(const Duration(seconds: 5), () => _cycleImage());
  }

  void _cycleImage() {
    if (!mounted || !_carouselStarted) return;

    final nextIndex = (_currentImageIndex + 1) % _heroImages.length;

    // Reset and play crossfade
    _imageController.reset();
    setState(() => _currentImageIndex = nextIndex);
    _imageController.forward().then((_) {
      // Wait 5 seconds then cycle again
      Future.delayed(const Duration(seconds: 5), () => _cycleImage());
    });
  }

  @override
  void dispose() {
    _carouselStarted = false;
    _textController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeData = ref.watch(homeDataProvider);
    final size = MediaQuery.of(context).size;
    final isMobile = Responsive.isMobile(context);

    // Previous and current image indices for crossfade
    final prevIndex = (_currentImageIndex - 1 + _heroImages.length) % _heroImages.length;

    return SizedBox(
      height: isMobile ? size.height * 0.6 : size.height * 0.8 - kToolbarHeight,
      width: double.infinity,
      child: Stack(
        children: [
          // --- Background Image Carousel with Crossfade ---
          // Previous image (fades out)
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: _heroImages[prevIndex],
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.black),
              errorWidget: (context, url, error) => Container(color: Colors.black),
            ),
          ),
          // Current image (fades in on top)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _imageFade,
              builder: (context, child) {
                return Opacity(
                  opacity: _imageFade.value.clamp(0.0, 1.0),
                  child: child,
                );
              },
              child: CachedNetworkImage(
                imageUrl: _heroImages[_currentImageIndex],
                fit: BoxFit.cover,
                placeholder: (context, url) => const SizedBox.shrink(),
                errorWidget: (context, url, error) => const SizedBox.shrink(),
              ),
            ),
          ),

          // --- Gradient Overlay ---
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.75),
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // --- Animated Text Content ---
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : (Responsive.isDesktop(context) ? 100 : 40),
            ),
            child: AnimatedBuilder(
              animation: _textController,
              builder: (context, _) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Animated Title
                    Opacity(
                      opacity: _titleOpacity.value.clamp(0.0, 1.0),
                      child: Transform.translate(
                        offset: Offset(0, _titleSlide.value),
                        child: homeData.when(
                          data: (text) => ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 700),
                            child: Text(
                              text,
                              style: AppFontStyles.h1.copyWith(
                                color: Colors.white,
                                fontSize: Responsive.isDesktop(context) ? 56 : 36,
                                height: 1.1,
                              ),
                            ),
                          ),
                          loading: () => const ShimmerBox(width: 600, height: 100),
                          error: (e, s) => const Text(
                            "Welcome to LemonBright Foundation",
                            style: TextStyle(color: Colors.white, fontSize: 36),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Animated Button
                    Opacity(
                      opacity: _buttonOpacity.value.clamp(0.0, 1.0),
                      child: Transform.translate(
                        offset: Offset(0, _buttonSlide.value),
                        child: ModernButton(
                          text: "Support Our Mission",
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // --- Carousel Indicator Dots ---
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_heroImages.length, (i) {
                final isActive = i == _currentImageIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: isActive ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.white : Colors.white38,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
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
        vertical: Responsive.isMobile(context) ? 60 : 100,
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
        vertical: Responsive.isMobile(context) ? 60 : 100,
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

class _ProjectCard extends StatefulWidget {
  final ProjectModel project;
  const _ProjectCard({required this.project});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => context.push('/project/${widget.project.id}'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()
            ..translate(0.0, _isHovered ? -8.0 : 0.0, 0.0)
            ..scale(_isHovered ? 1.02 : 1.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? AppConstants.primaryColor.withOpacity(0.15)
                    : Colors.black.withOpacity(0.05),
                blurRadius: _isHovered ? 25 : 10,
                spreadRadius: _isHovered ? 5 : 2,
                offset: Offset(0, _isHovered ? 12 : 2),
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
                    tag: 'project_${widget.project.id}',
                    child: CachedNetworkImage(
                      imageUrl: widget.project.imageUrl,
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
                      widget.project.title,
                      style: AppFontStyles.h3.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.project.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppFontStyles.bodyMedium,
                    ),
                    const SizedBox(height: 15),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 250),
                      style: TextStyle(
                        color: _isHovered
                            ? AppConstants.accentColor
                            : AppConstants.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Learn More"),
                          const SizedBox(width: 4),
                          AnimatedPadding(
                            duration: const Duration(milliseconds: 300),
                            padding: EdgeInsets.only(left: _isHovered ? 6 : 0),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              color: _isHovered
                                  ? AppConstants.accentColor
                                  : AppConstants.primaryColor,
                            ),
                          ),
                        ],
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

class GallerySection extends ConsumerWidget {
  const GallerySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final galleryData = ref.watch(galleryDataProvider);
    final isDesktop = Responsive.isDesktop(context);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Responsive.isMobile(context) ? 60 : 100,
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
              itemBuilder: (context, index) => _HoverScaleImage(
                imageUrl: images[index].imageUrl,
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

class _HoverScaleImage extends StatefulWidget {
  final String imageUrl;
  const _HoverScaleImage({required this.imageUrl});

  @override
  State<_HoverScaleImage> createState() => _HoverScaleImageState();
}

class _HoverScaleImageState extends State<_HoverScaleImage> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedScale(
              scale: _isHovered ? 1.08 : 1.0,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const ShimmerBox(width: 150, height: 150),
              ),
            ),
            // Subtle overlay on hover
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              color: _isHovered
                  ? AppConstants.primaryColor.withOpacity(0.15)
                  : Colors.transparent,
            ),
          ],
        ),
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
      color: AppConstants.cardColor,
      padding: EdgeInsets.symmetric(
        vertical: Responsive.isMobile(context) ? 60 : 100,
        horizontal: isDesktop ? 100 : 20,
      ),
      child: Column(
        children: [
          const SectionHeader(
            title: "Join Us",
            subtitle: "Every Contribution Matters",
            light: false,
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
          "No. 45, Pyay Road, Mayangone Township, Yangon, Myanmar",
        ),
        const SizedBox(height: 20),
        _infoItem(Icons.email, "contact@lemonbright.org"),
        const SizedBox(height: 20),
        _infoItem(Icons.phone, "+95 9 789 234 567"),
      ],
    );
  }

  Widget _infoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppConstants.primaryColor, size: 28),
        const SizedBox(width: 20),
        Expanded(
          child: Text(
            text,
            style: AppFontStyles.bodyMedium.copyWith(color: AppConstants.textMainColor),
          ),
        ),
      ],
    );
  }

  Widget _buildContactForm() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Send a Message",
                style: AppFontStyles.h3.copyWith(
                  fontSize: 22, 
                  color: AppConstants.primaryColor,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 24),
              _compactInput(label: "Name", hint: "Enter your full name"),
              const SizedBox(height: 16),
              _compactInput(label: "Email", hint: "your@email.com"),
              const SizedBox(height: 16),
              _compactInput(
                label: "Message", 
                hint: "Tell us about your interest...", 
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ModernButton(
                  onPressed: () {},
                  text: "Send Message",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _compactInput({required String label, required String hint, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppFontStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: AppConstants.textMainColor.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          maxLines: maxLines,
          style: AppFontStyles.bodyMedium.copyWith(fontSize: 15, color: AppConstants.textMainColor),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppFontStyles.bodyMedium.copyWith(fontSize: 14, color: Colors.grey[400]),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppConstants.primaryColor, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

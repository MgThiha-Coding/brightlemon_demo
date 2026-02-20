import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';
import '../../core/font_styles.dart';
import '../../core/responsive.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  String _activeMenu = "Projects";

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Row(
        children: [
          if (isDesktop) _buildSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: _buildContent(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 260,
      color: AppConstants.primaryColor,
      child: Column(
        children: [
          const SizedBox(height: 40),
          _logo(),
          const SizedBox(height: 50),
          _sidebarItem(Icons.folder_copy_rounded, "Projects"),
          _sidebarItem(Icons.collections_rounded, "Gallery"),
          _sidebarItem(Icons.message_rounded, "Contact Inbox"),
          const Spacer(),
          _sidebarItem(Icons.logout_rounded, "Exit to Site"),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _logo() {
    return RichText(
      text: TextSpan(
        style: AppFontStyles.h3.copyWith(color: Colors.white, fontSize: 20),
        children: const [
          TextSpan(text: 'Lemon', style: TextStyle(fontWeight: FontWeight.w400)),
          TextSpan(text: 'CMS', style: TextStyle(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _sidebarItem(IconData icon, String label) {
    final bool isActive = _activeMenu == label;
    return GestureDetector(
      onTap: () {
      if (label == "Exit to Site") {
        context.go('/');
        return;
      }
      setState(() => _activeMenu = label);
    },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: isActive ? Colors.white : Colors.white60, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white60,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 70,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          Text(_activeMenu, style: AppFontStyles.h3.copyWith(fontSize: 18)),
          const Spacer(),
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppConstants.accentColor,
            child: Icon(Icons.person, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          const Text("Administrator", style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_activeMenu) {
      case "Projects":
        return _projectsView();
      case "Gallery":
        return _galleryView();
      case "Contact Inbox":
        return _messagesView();
      default:
        return const Center(child: Text("Select a menu"));
    }
  }

  Widget _projectsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _sectionTitle("Manage Projects", "Post new projects and field updates."),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("New Project", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.accentColor,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        _buildProjectGrid(),
      ],
    );
  }

  Widget _buildProjectGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Responsive.isDesktop(context) ? 3 : 1,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        mainAxisExtent: 360,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  "https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?q=80&w=400",
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Clean Water Initiative", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text("Feb 21, 2026", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                    const SizedBox(height: 12),
                    const Text(
                      "Our team is deploying high-efficiency filters to 12 new villages...",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        TextButton(onPressed: () {}, child: const Text("Edit")),
                        TextButton(onPressed: () {}, child: const Text("Manage Vlog")),
                        const Spacer(),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _galleryView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _sectionTitle("Media Gallery", "Upload high-quality images for your impact showcase."),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.cloud_upload_rounded, color: Colors.white),
              label: const Text("Upload Images", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: List.generate(8, (index) => _galleryEntry()),
        ),
      ],
    );
  }

  Widget _galleryEntry() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ).copyWith(
        image: const DecorationImage(
          image: NetworkImage("https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?q=80&w=300"),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 8,
            top: 8,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.black45,
              child: IconButton(
                icon: const Icon(Icons.close, size: 14, color: Colors.white),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _messagesView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Inquiries", "Respond to supporters and community members."),
        const SizedBox(height: 32),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: const EdgeInsets.all(20),
                leading: const CircleAvatar(backgroundColor: Color(0xFFF1F5F9), child: Icon(Icons.person, color: Colors.grey)),
                title: const Text("U Kyaw Swar (Donor)", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text("I am interested in supporting the clean water mission in Myingyan. Please send details."),
                trailing: Text("2h ago", style: TextStyle(color: Colors.grey[400], fontSize: 12)),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppFontStyles.h2.copyWith(fontSize: 24)),
        Text(subtitle, style: AppFontStyles.bodyMedium.copyWith(color: Colors.grey)),
      ],
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_models.dart';
import '../core/constants.dart';

final activeSectionProvider = StateProvider<int>((ref) => 0);
final scrollOffsetProvider = StateProvider<int>((ref) => 0);

final homeDataProvider = FutureProvider<String>((ref) async {
  await Future.delayed(AppConstants.mockDelay);
  return "Empowering Communities, Changing Lives through Your Kindness.";
});

final aboutDataProvider = FutureProvider<Map<String, String>>((ref) async {
  await Future.delayed(AppConstants.mockDelay);
  return {
    "title": "Dedicated to Human Welfare Since 2010",
    "description": "LemonBright Foundation is a non-profit organization committed to providing clean water, education, and healthcare to underserved regions. We believe that every individual deserves a chance to thrive, and together, we can make that a reality. Join us in our journey of compassion.",
    "imageUrl": "https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?auto=format&fit=crop&w=1000&q=80",
  };
});

final projectsDataProvider = FutureProvider<List<ProjectModel>>((ref) async {
  await Future.delayed(AppConstants.mockDelay);
  final projectImages = [
    "https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?q=80&w=800&auto=format&fit=crop",
    "https://images.unsplash.com/photo-1509099836639-18ba1795216d?q=80&w=800&auto=format&fit=crop",
    "https://images.unsplash.com/photo-1518391846015-55a9cc003b25?q=80&w=800&auto=format&fit=crop",
    "https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?q=80&w=800&auto=format&fit=crop",
    "https://images.unsplash.com/photo-1593113598332-cd288d649433?q=80&w=800&auto=format&fit=crop",
    "https://images.unsplash.com/photo-1517677208171-0bc6725a3e60?q=80&w=800&auto=format&fit=crop",
  ];
  final projectTitles = [
    "Clean Water Initiative",
    "Education for All",
    "Emergency Relief Fund",
    "Reforestation Mission",
    "Sustainable Farming",
    "Child Health Program",
  ];
  final projectDescs = [
    "Bringing safe drinking water to remote villages.",
    "Providing quality learning materials for children.",
    "Rapid response to natural disasters and crises.",
    "Planting trees to restore local ecosystems.",
    "Empowering farmers with modern eco-techniques.",
    "Ensuring every child has access to basic medicine."
  ];

  return List.generate(
    6,
    (index) => ProjectModel(
      id: index.toString(),
      title: projectTitles[index],
      imageUrl: projectImages[index],
      description: projectDescs[index],
      longDescription: "Our mission with the ${projectTitles[index]} is to create a lasting impact on the lives of those in need. We believe that by providing direct support and fostering community involvement, we can overcome challenges like never before. This initiative has already reached over 5,000 individuals, but there is still much more to be done. Your contribution helps us provide the necessary resources, expertise, and time required to make this world a better place.",
      vlogContent: "Today was a momentous day for the ${projectTitles[index]}. Our team arrived on-site early this morning to find the local community already gathered and eager to participate. We've seen a 30% increase in engagement since our last visit, and the results are truly heart-warming. One local resident, Daw Aye Aye, shared how this project has changed her daily life by saving her hours of travel time every day. These stories are why we do what we do. We are currently planning the next phase which will involve more sustainable infrastructure for the local school.",
    ),
  );
});

final projectByIdProvider = FutureProvider.family<ProjectModel?, String>((ref, id) async {
  final projects = await ref.watch(projectsDataProvider.future);
  return projects.firstWhere((p) => p.id == id, orElse: () => projects.first);
});

final galleryDataProvider = FutureProvider<List<GalleryModel>>((ref) async {
  await Future.delayed(AppConstants.mockDelay);
  final galleryImages = [
    "https://images.unsplash.com/photo-1504159506876-f8338247a14a?q=80&w=500&auto=format&fit=crop",
    "https://images.unsplash.com/photo-1511632765486-a01980e01a18?q=80&w=500&auto=format&fit=crop",
    "https://images.unsplash.com/photo-1531206715517-5c0ba140b2b8?q=80&w=500&auto=format&fit=crop",
    "https://images.unsplash.com/photo-1582213782179-e0d53f98f2ca?q=80&w=500&auto=format&fit=crop",
  ];
  return List.generate(
    galleryImages.length,
    (index) => GalleryModel(
      id: index.toString(),
      imageUrl: galleryImages[index],
    ),
  );
});

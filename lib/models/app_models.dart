class SectionModel {
  final String id;
  final String title;

  SectionModel({required this.id, required this.title});
}

class ProjectModel {
  final String id;
  final String title;
  final String imageUrl;
  final String description;
  final String longDescription;
  final String? vlogUrl;

  ProjectModel({
    required this.id, 
    required this.title, 
    required this.imageUrl,
    required this.description,
    required this.longDescription,
    this.vlogUrl,
  });
}

class GalleryModel {
  final String id;
  final String imageUrl;

  GalleryModel({required this.id, required this.imageUrl});
}

enum MemoryType { photo, voice, story, note }

class MemoryItem {
  final String title;
  final String date;
  final String image; // للصور
  final MemoryType type;
  final String? duration; // للصوت مثلاً "2:45 MIN"
  final String? badge; // "STORY AI" أو "RK" أو null
  final bool isFeatured;

  MemoryItem({
    required this.title,
    required this.date,
    required this.image,
    required this.type,
    required this.duration,
    required this.badge,
    // عشان نعرف هل هيبقى كارت كبير ولا صغير
    required this.isFeatured,
  });
}

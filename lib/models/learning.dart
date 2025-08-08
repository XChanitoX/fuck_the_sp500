class LearningCategory {
  final String id;
  final String title;
  final String description;
  final List<LearningModule> modules;

  LearningCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.modules,
  });
}

class LearningModule {
  final String id;
  final String title;
  final String description;
  final String level; // Básico / Intermedio / Avanzado
  final List<LearningLesson> lessons;

  LearningModule({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.lessons,
  });
}

class LearningLesson {
  final String id;
  final String title;
  final String summary;
  final int durationMin;
  final List<LessonSection> sections;

  LearningLesson({
    required this.id,
    required this.title,
    required this.summary,
    required this.durationMin,
    required this.sections,
  });
}

class LessonSection {
  final String heading;
  final String body; // Plain text for now; can be Markdown later

  LessonSection({required this.heading, required this.body});
}

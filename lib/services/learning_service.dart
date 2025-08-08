import '../models/learning.dart';

class LearningService {
  // Later: fetch from API / CMS. For now: local seed data.
  static Future<List<LearningCategory>> getCatalog() async {
    final basics = LearningCategory(
      id: 'basics',
      title: 'Fundamentos',
      description: 'Conceptos esenciales para empezar en finanzas e inversión.',
      modules: [
        LearningModule(
          id: 'markets_intro',
          title: 'Introducción a los Mercados',
          description: 'Qué es la bolsa, instrumentos y participantes.',
          level: 'Básico',
          lessons: [
            LearningLesson(
              id: 'what_is_stock_market',
              title: '¿Qué es la bolsa?',
              summary: 'Funcionamiento de los mercados y cómo invertir.',
              durationMin: 8,
              sections: [
                LessonSection(
                  heading: 'Definición y propósito',
                  body:
                      'La bolsa es un mercado donde se negocian activos como acciones y ETFs. Permite a empresas financiarse y a inversores participar en su crecimiento.',
                ),
                LessonSection(
                  heading: 'Participantes',
                  body:
                      'Emisores, inversores, brokers y reguladores. Cada uno cumple un rol para el correcto funcionamiento del mercado.',
                ),
              ],
            ),
            LearningLesson(
              id: 'what_is_etf',
              title: '¿Qué es un ETF?',
              summary: 'Fondo cotizado que replica un índice u estrategia.',
              durationMin: 6,
              sections: [
                LessonSection(
                  heading: 'Concepto',
                  body:
                      'Un ETF agrupa un conjunto de activos y cotiza como una acción. Ofrece diversificación y costos bajos.',
                ),
              ],
            ),
          ],
        ),
      ],
    );

    final advanced = LearningCategory(
      id: 'advanced',
      title: 'Avanzado',
      description: 'Análisis fundamental, valoración y estrategias.',
      modules: [
        LearningModule(
          id: 'fundamental_analysis',
          title: 'Análisis Fundamental',
          description: 'Estados financieros, KPIs y valoración.',
          level: 'Intermedio',
          lessons: [
            LearningLesson(
              id: 'income_statement',
              title: 'Estado de Resultados',
              summary: 'Ingresos, costos, márgenes y utilidad.',
              durationMin: 10,
              sections: [
                LessonSection(
                  heading: 'Márgenes',
                  body:
                      'Analiza margen bruto, operativo y neto para entender la rentabilidad y eficiencia.',
                ),
              ],
            ),
          ],
        ),
      ],
    );

    return [basics, advanced];
  }
}

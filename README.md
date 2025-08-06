# Top Stocks - Ranking de Acciones con IA

Una aplicación móvil elegante desarrollada en Flutter que presenta un ranking de las mejores acciones del mercado americano, con análisis impulsado por inteligencia artificial.

## 🎨 Características de Diseño

- **Diseño Glass**: Efecto de cristal esmerilado estilo iPhone con transparencias y blur
- **Tema Oscuro**: Paleta de colores elegante con gradientes oscuros
- **Animaciones Fluidas**: Transiciones suaves y efectos visuales modernos
- **UX/UI Premium**: Interfaz intuitiva con la mejor experiencia de usuario

## 🚀 Funcionalidades

### Pantalla Principal (Ranking)

- **Lista de Acciones**: Ranking de las top acciones con información detallada
- **Filtros por Sector**: Filtrado dinámico por sector (Tecnología, Finanzas, etc.)
- **Pull to Refresh**: Actualización de datos con gesto de deslizar
- **Loading States**: Estados de carga con shimmer effects elegantes

### Tarjetas de Acción

- **Información Completa**: Símbolo, empresa, precio, cambio, ranking
- **Indicadores Visuales**: Colores para cambios positivos/negativos
- **Métricas Clave**: P/E Ratio, Dividend Yield, Sector
- **Análisis IA**: Explicación de por qué es una buena opción de compra

### Pantalla de Detalle

- **Vista Expandida**: Información completa de la acción seleccionada
- **Análisis Técnico**: Indicadores y métricas avanzadas
- **Análisis Fundamental**: Datos financieros y ratios
- **Recomendaciones IA**: Sugerencias de compra/venta/mantener

## 🛠 Tecnologías Utilizadas

- **Flutter**: Framework de desarrollo móvil
- **Dart**: Lenguaje de programación
- **HTTP**: Cliente para APIs REST
- **Shared Preferences**: Almacenamiento local
- **Flutter Animate**: Animaciones avanzadas
- **Shimmer**: Efectos de carga
- **Intl**: Formateo de números y fechas

## 📱 Arquitectura

```text
lib/
├── main.dart                 # Punto de entrada de la aplicación
├── models/
│   └── stock.dart           # Modelo de datos para acciones
├── services/
│   └── stock_service.dart   # Servicio para manejo de datos
├── screens/
│   ├── ranking_screen.dart  # Pantalla principal del ranking
│   └── stock_detail_screen.dart # Pantalla de detalle
└── widgets/
    ├── stock_card.dart      # Widget de tarjeta de acción
    └── stock_shimmer.dart   # Widget de loading
```

## 🎯 Características Técnicas

### Diseño Glass

- Efectos de transparencia con `BackdropFilter`
- Gradientes sutiles para profundidad visual
- Bordes con opacidad para efecto cristal
- Sombras para elevación

### Animaciones

- Entrada escalonada de elementos
- Transiciones suaves entre pantallas
- Efectos de hover y tap
- Animaciones de carga

### Estado de la Aplicación

- Gestión de estado con `StatefulWidget`
- Carga asíncrona de datos
- Manejo de errores elegante
- Estados de loading optimizados

## 🔌 Integración con Backend

La aplicación está preparada para conectarse con un backend que proporcione:

### Endpoints Esperados

- `GET /api/stocks` - Lista de acciones rankeadas
- `GET /api/stocks/{symbol}/analysis` - Análisis detallado por acción

### Formato de Datos

```json
{
  "symbol": "AAPL",
  "companyName": "Apple Inc.",
  "currentPrice": 175.43,
  "change": 2.15,
  "changePercent": 1.24,
  "marketCap": 2750000000000,
  "volume": 45678900,
  "rank": 1,
  "aiAnalysis": "Análisis de IA...",
  "recommendation": "COMPRAR",
  "targetPrice": 185.00,
  "sector": "Tecnología",
  "peRatio": 28.5,
  "dividendYield": 0.5
}
```

## 🚀 Instalación y Ejecución

1. **Clonar el repositorio**

   ```bash
   git clone <repository-url>
   cd fuck_the_sp500
   ```

2. **Instalar dependencias**

   ```bash
   flutter pub get
   ```

3. **Ejecutar la aplicación**

   ```bash
   flutter run
   ```

## 📦 Dependencias

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  shared_preferences: ^2.2.2
  flutter_animate: ^4.2.0+1
  glassmorphism: ^3.0.0
  cupertino_icons: ^1.0.2
  intl: ^0.18.1
  shimmer: ^3.0.0
```

## 🎨 Paleta de Colores

- **Fondo Principal**: `#0A0A0A`
- **Fondo Secundario**: `#1A1A2E`
- **Acento Azul**: `#4A90E2`
- **Acento Púrpura**: `#9B59B6`
- **Verde Positivo**: `#4CAF50`
- **Rojo Negativo**: `#F44336`

## 📱 Compatibilidad

- **iOS**: 12.0+
- **Android**: API 21+
- **Flutter**: 3.5.4+

## 🔮 Próximas Características

- [ ] Gráficos interactivos de precios
- [ ] Notificaciones push para cambios importantes
- [ ] Modo offline con caché local
- [ ] Favoritos y watchlist personal
- [ ] Comparación de acciones
- [ ] Alertas de precio
- [ ] Integración con brokers

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## 📞 Contacto

Para preguntas o soporte, contacta al equipo de desarrollo.

---

## Desarrollado con ❤️ usando Flutter

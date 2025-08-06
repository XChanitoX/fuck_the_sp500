# 🚀 Fuck The SP500 - App de Recomendaciones de Acciones

Una aplicación Flutter moderna para mostrar recomendaciones de acciones del mercado americano con datos en tiempo real, análisis de IA y logos de empresas.

## ✨ Características

- 📊 **Datos en Tiempo Real**: Precios actuales del mercado americano
- 🎯 **Análisis de IA**: Recomendaciones inteligentes basadas en datos del mercado
- 🏢 **Logos de Empresas**: Logos oficiales de las empresas más importantes
- 📱 **UI Moderna**: Interfaz elegante con efectos glassmorphism
- 🔄 **Actualización en Vivo**: Pull-to-refresh para datos actualizados
- 📈 **Filtros por Sector**: Filtra acciones por sector económico
- 💰 **Información Fundamental**: P/E ratio, dividend yield, market cap

## 🛠️ Configuración de APIs

### 1. Yahoo Finance API (Actualmente en uso - Gratuita)

La app ahora usa **Yahoo Finance API** que es completamente gratuita y no requiere API key:

- ✅ **Sin límites de requests**
- ✅ **Datos en tiempo real**
- ✅ **No requiere registro**
- ✅ **Información de precios actualizada**

### 2. Alpha Vantage API (Alternativa)

Si prefieres usar Alpha Vantage:

1. Ve a [Alpha Vantage](https://www.alphavantage.co/)
2. Regístrate para obtener una API key gratuita
3. Abre `lib/config/api_config.dart`
4. Reemplaza `'TU_API_KEY_AQUI'` con tu API key real

```dart
static const String alphaVantageApiKey = 'TU_API_KEY_REAL_AQUI';
```

**Plan Gratuito**: 25 requests/día (no 500 como antes), datos en tiempo real

### 2. Alternativas de APIs

#### Yahoo Finance API
- **URL**: https://rapidapi.com/apidojo/api/yahoo-finance1/
- **Ventajas**: Datos gratuitos, muy completa, incluye logos
- **Configuración**: Agregar API key en `api_config.dart`

#### Finnhub API
- **URL**: https://finnhub.io/
- **Ventajas**: API robusta, websockets, datos profesionales
- **Plan Gratuito**: 60 requests/minuto

#### IEX Cloud API
- **URL**: https://iexcloud.io/
- **Ventajas**: Datos de alta calidad, bien documentada
- **Plan Gratuito**: 50,000 requests/mes

### 3. Logos de Empresas

La app usa **Clearbit Logo API** para mostrar logos oficiales:
- **URL**: `https://logo.clearbit.com/{domain}`
- **Ejemplo**: `https://logo.clearbit.com/apple.com`
- **Configuración**: Automática, no requiere API key

## 🚀 Instalación

1. **Clona el repositorio**
```bash
git clone <tu-repositorio>
cd fuck_the_sp500
```

2. **Instala las dependencias**
```bash
flutter pub get
```

3. **Configuración (Opcional)**
- La app usa Yahoo Finance por defecto (no requiere configuración)
- Si quieres usar Alpha Vantage, abre `lib/config/api_config.dart` y reemplaza `'TU_API_KEY_AQUI'` con tu API key

4. **Ejecuta la app**
```bash
flutter run
```

## 📱 Uso

1. **Pantalla Principal**: Muestra el ranking de acciones recomendadas
2. **Filtros**: Usa los chips para filtrar por sector
3. **Pull to Refresh**: Desliza hacia abajo para actualizar datos
4. **Detalles**: Toca una acción para ver análisis detallado

## 🏗️ Estructura del Proyecto

```
lib/
├── config/
│   └── api_config.dart          # Configuración de APIs
├── models/
│   └── stock.dart               # Modelo de datos de acciones
├── screens/
│   ├── ranking_screen.dart      # Pantalla principal
│   └── stock_detail_screen.dart # Detalles de acción
├── services/
│   └── stock_service.dart       # Servicios de API
├── widgets/
│   ├── stock_card.dart          # Tarjeta de acción
│   └── stock_shimmer.dart       # Loading placeholder
└── main.dart                    # Punto de entrada
```

## 🔧 Configuración Avanzada

### Cambiar Proveedor de API

Para usar una API diferente, modifica `StockService`:

```dart
// En lib/services/stock_service.dart
static Future<Map<String, dynamic>?> getRealTimeQuote(String symbol) async {
  // Cambiar URL y parámetros según la API elegida
  final response = await http.get(
    Uri.parse('${ApiConfig.yahooFinanceBaseUrl}/$symbol'),
    headers: {'X-RapidAPI-Key': 'TU_API_KEY'},
  );
  // Procesar respuesta según formato de la API
}
```

### Agregar Nuevas Acciones

1. Agrega el símbolo en `ApiConfig.popularSymbols`
2. Agrega el dominio en `ApiConfig.symbolToDomain`
3. La app automáticamente incluirá la nueva acción

### Personalizar Análisis de IA

Modifica `_generateAIAnalysis()` en `StockService` para personalizar las recomendaciones:

```dart
static String _generateAIAnalysis(String symbol, Map<String, dynamic>? overviewData) {
  // Tu lógica personalizada aquí
  return 'Análisis personalizado para $symbol';
}
```

## 📊 Datos Disponibles

### Información en Tiempo Real
- Precio actual
- Cambio diario
- Porcentaje de cambio
- Volumen
- Máximo/Mínimo del día

### Información Fundamental
- Nombre de la empresa
- Sector e industria
- Capitalización de mercado
- Ratio P/E
- Dividend yield
- Descripción de la empresa

## 🎨 Personalización

### Temas
- Modifica `lib/main.dart` para cambiar colores y estilos
- La app usa un tema oscuro moderno por defecto

### Animaciones
- Usa `flutter_animate` para personalizar animaciones
- Modifica duraciones y curvas en los widgets

## 🚨 Limitaciones

### Alpha Vantage Free Tier
- 500 requests/día
- La app limita a 5 acciones por carga para respetar límites
- Considera actualizar a plan premium para más datos

### Logos
- Algunos logos pueden no cargar si el dominio no existe
- La app muestra fallback con inicial de la empresa

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## 🆘 Soporte

Si tienes problemas:

1. Verifica que tu API key sea válida
2. Revisa los límites de tu plan de API
3. Asegúrate de tener conexión a internet
4. Revisa la consola para errores específicos

## 🔮 Próximas Características

- [ ] Gráficos de precios históricos
- [ ] Alertas de precio
- [ ] Portfolio personal
- [ ] Noticias de mercado
- [ ] Análisis técnico avanzado
- [ ] Exportar datos
- [ ] Modo offline

---

**¡Disfruta analizando el mercado! 📈**

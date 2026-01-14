# 💳 Sistema Inteligente de Detección de Fraude Financiero

**Autor:** Ing. Daniel Varela Pérez
📧 bedaniele0@gmail.com | 📱 +52 55 4189 3428
**Metodología:** DVP-PRO (Data Science Professional Framework)

[![Python](https://img.shields.io/badge/Python-3.10+-blue.svg)](https://python.org)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.104+-green.svg)](https://fastapi.tiangolo.com)
[![Streamlit](https://img.shields.io/badge/Streamlit-1.25+-red.svg)](https://streamlit.io)
[![Tests](https://img.shields.io/badge/Tests-34%2F34-success.svg)](#testing)
[![ROC-AUC](https://img.shields.io/badge/ROC--AUC-95.28%25-brightgreen.svg)](#métricas-del-modelo)
[![Status](https://img.shields.io/badge/Status-Portfolio%20Demo-success.svg)](#)

---

## 📋 Tabla de Contenidos

- [Objetivo General](#-objetivo-general)
- [Características Principales](#-características-principales)
- [Métricas del Modelo](#-métricas-del-modelo)
- [Arquitectura del Sistema](#️-arquitectura-del-sistema)
- [Instalación](#-instalación)
- [Guía de Uso](#-guía-de-uso)
- [Testing](#-testing)
- [Documentación DVP-PRO](#-documentación-dvp-pro)
- [Stack Tecnológico](#-stack-tecnológico)
- [Roadmap](#-roadmap)
- [Contacto](#-contacto)

---

## 🎯 Objetivo General

Sistema de detección de fraude financiero en formato portafolio, implementado con **metodología DVP-PRO**, que incluye:

- ✅ **Pipeline ML reproducible** con Random Forest optimizado
- ✅ **API REST** con autenticación JWT para predicciones en tiempo real
- ✅ **Dashboard interactivo** para análisis y visualización
- ✅ **Suite completa de tests** (34/34 pasando)
- ✅ **Monitoreo (opcional)** con Prometheus/Grafana
- ✅ **Docker (opcional)** para entorno reproducible

**Valor de Negocio:** Reducción de fraude con 95.28% ROC-AUC y 93.62% precisión, minimizando falsos positivos.

---

## ✨ Características Principales

### 🤖 Machine Learning
- **Modelo:** Random Forest Classifier optimizado para datos desbalanceados
- **Técnicas:** SMOTE para balanceo de clases, optimización de threshold
- **Versionado:** Artefactos del modelo guardados con metadata en `models/`
- **Threshold ajustable:** Configurable según estrategia de negocio (default: 0.300)

### 🛠️ Pipeline MLOps
- **Entrenamiento:** Script automatizado con validación cruzada
- **Evaluación:** Métricas comprehensivas en test set
- **Predicciones:** Batch predictions con exportación a CSV
- **Monitoreo:** Detección de data drift y model performance

### 🌐 API REST
- **Framework:** FastAPI con Swagger docs auto-generados
- **Autenticación:** JWT tokens para seguridad
- **Endpoints:**
  - `POST /api/v1/predict` — Predicción individual
  - `POST /api/v1/predict/batch` — Predicciones batch (≤1000)
  - `GET /api/v1/model/info` — Información del modelo
  - `PUT /api/v1/model/threshold` — Actualizar threshold
  - `GET /api/v1/metrics` — Métricas del modelo

### 📊 Dashboard Streamlit
- **Módulo 1:** Predicción individual con visualización de probabilidades
- **Módulo 2:** Análisis batch con carga de archivos CSV/Parquet
- **Módulo 3:** Métricas en tiempo real y acumuladas
- **Módulo 4:** Visualizaciones interactivas con Plotly

### 🧪 Testing Comprehensivo
- **34 tests unitarios y de integración**
- **Cobertura:** API endpoints, data pipeline, model inference
- **Framework:** pytest con fixtures y mocking
- **CI/CD Ready:** Configuración para GitHub Actions

### 📈 Monitoreo y Observabilidad
- **Prometheus:** Métricas de sistema y modelo
- **Grafana:** Dashboards de visualización
- **Alerting:** Configuración de alertas básicas
- **Logging:** Structured logging con niveles configurables

---

## 📊 Métricas del Modelo

### Resultados en Test Set (Evaluación Final)

| Métrica | Valor | Interpretación |
|---------|-------|----------------|
| **Precision** | **93.62%** | De cada 100 transacciones marcadas como fraude, 94 son realmente fraude |
| **Recall** | **72.13%** | El modelo detecta 72 de cada 100 fraudes reales |
| **F1-Score** | **81.48%** | Balance óptimo entre precisión y recall |
| **Accuracy** | **99.96%** | Exactitud global del modelo |
| **ROC-AUC** | **95.28%** | Excelente capacidad discriminativa |
| **Threshold Óptimo** | **0.300** | Optimizado para maximizar F1-Score con énfasis en recall |

**Métricas en Validation Set (Training):**
- Precision: 93.62% | Recall: 72.13% | F1: 81.48% | ROC-AUC: 95.28%

**Generalización:** El modelo mantiene métricas estables entre validation y test, indicando **buena capacidad de generalización** sin overfitting ✅

### Análisis de Performance

**Fortalezas:**
- ✅ ROC-AUC de 95.28% indica excelente separación entre clases
- ✅ Precision de 93.62% minimiza falsos positivos (útil en escenarios reales)
- ✅ F1-Score balanceado para casos de uso reales
- ✅ Modelo generaliza bien (métricas estables)

**Trade-offs:**
- Threshold ajustable permite priorizar precision vs recall según estrategia de negocio
- Modelo optimizado para minimizar costos de falsos positivos

---

## 💰 ROI Demo (con supuestos explícitos)

**Supuestos conservadores:**
- Volumen: 120M transacciones/año
- Tasa de fraude: 0.20% (240,000 fraudes/año)
- Costo promedio por fraude: $150 USD
- Precision: 93.62% | Recall: 72.13%
- Costo por falsa alerta (revisión): $2 USD

**Estimación rápida:**
```
TP ≈ 173,115 fraudes detectados/año
FP ≈ 11,803 alertas falsas/año
Ahorro potencial ≈ $25.9M/año
Ahorro conservador (30% captura operativa) ≈ $7.8M/año
```

> Estimación de demo basada en métricas reales del modelo; en producción depende de procesos y capacidad operativa.

## ⚙️ Arquitectura del Sistema

### Estructura del Proyecto (DVP-PRO)

```
fraud_detection/
├── api/                          # API REST (FastAPI)
│   ├── main.py                   # Endpoints principales
│   ├── auth.py                   # Autenticación JWT
│   └── routers/                  # Routers modulares
├── dashboard/                    # Dashboard interactivo (Streamlit)
│   └── fraud_detection_dashboard.py
├── src/
│   ├── models/                   # ML Pipeline
│   │   ├── train_fraud.py        # Entrenamiento del modelo
│   │   ├── evaluate.py           # Evaluación en test set
│   │   └── predict.py            # Predicciones batch
│   ├── monitoring/               # Monitoreo y alertas
│   │   ├── drift_detection.py    # Detección de data drift
│   │   └── monitoring_run.py     # Script de monitoreo
│   ├── data/                     # Data processing
│   └── utils/                    # Utilidades
├── data/
│   ├── raw/                      # Datos originales (no versionados)
│   └── processed/                # Datos procesados (Parquet)
│       ├── train_clean.parquet/
│       ├── validation_clean.parquet/
│       └── test_clean.parquet/
├── models/                       # Modelos entrenados
│   ├── improved_recall_threshold_model.pkl
│   ├── simple_fraud_model.pkl
│   └── threshold_config.json
├── tests/                        # Suite de tests
│   ├── test_api.py               # Tests de API (30 tests)
│   ├── test_data_pipeline.py     # Tests de datos (3 tests)
│   └── test_model_inference.py   # Tests de modelo (2 tests)
├── docs/                         # Documentación DVP-PRO
│   ├── F0_problem_statement.md   # Fase 0: Definición del problema
│   ├── F1_setup.md               # Fase 1: Setup del proyecto
│   ├── F2_architecture.md        # Fase 2: Arquitectura
│   ├── F3_eda.md                 # Fase 3: EDA
│   ├── F4_feature_engineering.md # Fase 4: Feature Engineering
│   ├── F5_modeling.md            # Fase 5: Modelado
│   ├── F6_evaluation.md          # Fase 6: Evaluación
│   └── F9_closure.md             # Fase 9: Cierre
├── notebooks/                    # Jupyter notebooks para análisis
├── reports/                      # Reportes y resultados
│   └── predictions/              # Predicciones generadas
├── config/                       # Archivos de configuración
├── docker-compose.monitoring.yml # Stack de monitoreo
├── Dockerfile                    # Containerización
├── requirements.txt              # Dependencias
├── setup.py                      # Instalación del paquete
├── train_model.sh               # Script de entrenamiento
└── README.md                     # Este archivo
```

### Diagrama de Flujo

```
┌─────────────────┐
│  Raw Data       │
│  (Parquet)      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Data Processing │
│ & Validation    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐      ┌──────────────┐
│ Feature Eng.    │─────▶│  Train/Val   │
│ + SMOTE         │      │  Split       │
└─────────────────┘      └──────┬───────┘
                                │
                                ▼
                         ┌──────────────┐
                         │ Random Forest│
                         │ Training     │
                         └──────┬───────┘
                                │
                                ▼
                         ┌──────────────┐
                         │ Threshold    │
                         │ Optimization │
                         └──────┬───────┘
                                │
         ┌──────────────────────┼──────────────────────┐
         │                      │                      │
         ▼                      ▼                      ▼
  ┌─────────────┐      ┌──────────────┐      ┌──────────────┐
  │   FastAPI   │      │  Streamlit   │      │  Monitoring  │
  │   :8000     │      │   :8501      │      │ Prom/Grafana │
  └─────────────┘      └──────────────┘      └──────────────┘
```

---

## 🚀 Instalación

### Requisitos Previos

- Python 3.10 o superior
- pip (gestor de paquetes de Python)
- Git

### Opción 1: Instalación Estándar

```bash
# 1. Clonar el repositorio
git clone https://github.com/tu-usuario/fraud_detection.git
cd fraud_detection

# 2. Crear entorno virtual
python3 -m venv venv
source venv/bin/activate  # En Windows: venv\Scripts\activate

# 3. Instalar dependencias
pip install --upgrade pip setuptools wheel
pip install -r requirements.txt

# 4. Instalar el paquete (para comandos CLI)
pip install -e .
```

### Opción 2: Instalación con Docker

```bash
# 1. Construir imagen
docker build -t fraud-detection .

# 2. Ejecutar contenedor
docker run -p 8000:8000 fraud-detection
```

### Verificación de Instalación

```bash
# Ejecutar tests
pytest -v

# Resultado esperado: 34/34 passed ✅
```

---

## 📖 Guía de Uso

### 1️⃣ Entrenar el Modelo

**Opción A: Script automático (recomendado)**

```bash
./train_model.sh
```

**Opción B: Python directo**

```bash
python3 src/models/train_fraud.py \
    --train-path data/processed/train_clean.parquet/part.0.parquet \
    --val-path data/processed/validation_clean.parquet
```

**Output esperado:**
```
🚀 Entrenando modelo de detección de fraude...
✅ Modelo entrenado y artefactos guardados
   • Modelo: models/improved_recall_threshold_model.pkl
   • Threshold óptimo: 0.300
   • Métricas val: {'precision': 0.9362, 'recall': 0.7213, ...}
```

### 2️⃣ Evaluar el Modelo

```bash
python3 src/models/evaluate.py \
    --test-path data/processed/test_clean.parquet
```

### 3️⃣ Hacer Predicciones Batch

```bash
python3 src/models/predict.py \
    --input-path data/processed/test_clean.parquet \
    --output-path reports/predictions/predicciones.csv
```

### 4️⃣ Lanzar API REST

```bash
# Opción 1: Uvicorn directo
python3 -m uvicorn api.main:app --reload

# Opción 2: Con configuración personalizada
python3 -m uvicorn api.main:app --host 0.0.0.0 --port 8000 --reload
```

**Acceder a la documentación:**
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

**Ejemplo completo de uso de la API:**

```bash
# 1. Obtener token de autenticación
curl -X POST "http://localhost:8000/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=admin&password=admin123"

# Response:
# {"access_token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...","token_type":"bearer"}

# 2. Hacer predicción individual (usar el token obtenido)
curl -X POST "http://localhost:8000/api/v1/predict" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -d '{
    "Time": 120,
    "V1": -1.5,
    "V2": 0.8,
    "V3": 1.2,
    "V4": -0.5,
    "V5": 0.3,
    "V6": -0.7,
    "V7": 0.9,
    "V8": -0.2,
    "V9": 0.6,
    "V10": -1.1,
    "V11": 0.4,
    "V12": -0.8,
    "V13": 0.1,
    "V14": -0.3,
    "V15": 0.7,
    "V16": -0.4,
    "V17": 0.5,
    "V18": -0.6,
    "V19": 0.2,
    "V20": -0.9,
    "V21": 0.8,
    "V22": -0.1,
    "V23": 0.4,
    "V24": -0.5,
    "V25": 0.6,
    "V26": -0.7,
    "V27": 0.3,
    "V28": -0.2,
    "Amount": 150.0
  }'
```

**Response:**
```json
{
  "fraud_probability": 0.12,
  "is_fraud": false,
  "threshold": 0.30,
  "model_version": "1.0.0",
  "timestamp": "2024-12-25T22:45:00.123456"
}
```

**Interpretación:**
- **Probabilidad de fraude:** 12% (bajo riesgo)
- **Decisión:** NO es fraude (probabilidad < threshold 0.30)
- **Recomendación:** Aprobar transacción automáticamente

### 5️⃣ Lanzar Dashboard Streamlit

```bash
python3 -m streamlit run dashboard/fraud_detection_dashboard.py
```

**Acceder al dashboard:**
- URL: http://localhost:8501

**Funcionalidades disponibles:**
- 🔍 Predicción individual con visualización de probabilidades
- 📂 Análisis batch (carga de CSV/Parquet)
- 📈 Métricas en tiempo real
- 📊 Visualizaciones interactivas

### 6️⃣ Monitoreo (Opcional)

```bash
# Levantar stack de monitoreo (Prometheus + Grafana)
docker-compose -f docker-compose.monitoring.yml up -d

# Acceder a:
# - Prometheus: http://localhost:9090
# - Grafana: http://localhost:3000 (admin/admin)
```

---

## 🧪 Testing

### Ejecutar Suite Completa

```bash
# Tests con output detallado
pytest -v

# Tests con cobertura
pytest --cov=src --cov=api --cov=dashboard --cov-report=html

# Abrir reporte de cobertura
open htmlcov/index.html
```

### Distribución de Tests

| Módulo | Tests | Descripción |
|--------|-------|-------------|
| `test_api.py` | 29 | Tests de endpoints, autenticación, validación |
| `test_data_pipeline.py` | 3 | Tests de calidad y procesamiento de datos |
| `test_model_inference.py` | 2 | Tests de carga y predicción del modelo |
| **Total** | **34** | **Cobertura 19%** |

### Tests Específicos

```bash
# Solo tests de API
pytest tests/test_api.py -v

# Solo tests de modelo
pytest tests/test_model_inference.py -v

# Tests con marca específica
pytest -m "integration" -v
```

---

## 📚 Documentación DVP-PRO

Este proyecto sigue la **metodología DVP-PRO** (Data Science Professional Framework) con documentación completa en cada fase:

### Documentación por Fase

| Fase | Documento | Descripción |
|------|-----------|-------------|
| **F0** | [Problem Statement](docs/F0_problem_statement.md) | Definición del problema de negocio |
| **F1** | [Setup](docs/F1_setup.md) | Configuración del entorno |
| **F2** | [Architecture](docs/F2_architecture.md) | Diseño arquitectónico |
| **F3** | [EDA](docs/F3_eda.md) | Análisis exploratorio de datos |
| **F4** | [Feature Engineering](docs/F4_feature_engineering.md) | Ingeniería de features |
| **F5** | [Modeling](docs/F5_modeling.md) | Desarrollo del modelo |
| **F6** | [Evaluation](docs/F6_evaluation.md) | Evaluación y validación |
| **F7** | Ops (opcional) | Docker/monitoreo si se requiere |
| **F8** | Observabilidad (opcional) | Métricas y alertas si se requiere |
| **F9** | [Closure](docs/F9_closure.md) | Cierre y lecciones aprendidas |

### Documentación Adicional

- [Inicio Rápido](INICIO_RAPIDO.md) - Guía de 5 minutos
- [Instrucciones de Setup](INSTRUCCIONES_SETUP.md) - Setup detallado
- [Validación Portfolio](VALIDACION_PORTFOLIO.md) - Demos para entrevistas
- [Comandos Directos](COMANDOS_DIRECTOS.md) - Referencia rápida

---

## 🛠️ Stack Tecnológico

### Core ML/Data Science
- **Python** 3.10+ - Lenguaje principal
- **pandas** 2.1+ - Manipulación de datos
- **numpy** 1.26+ - Operaciones numéricas
- **scikit-learn** 1.3+ - Machine Learning
- **imbalanced-learn** 0.11+ - Manejo de datos desbalanceados
- **pyarrow** 12.0+ - Formato Parquet eficiente

### API & Web
- **FastAPI** 0.104+ - Framework web moderno
- **Uvicorn** 0.24+ - ASGI server
- **Streamlit** 1.25+ - Dashboard interactivo
- **Pydantic** 2.0+ - Validación de datos
- **python-jose** 3.3+ - JWT tokens
- **passlib** 1.7+ - Hashing de passwords

### Machine Learning Avanzado
- **XGBoost** 2.0+ - Gradient boosting
- **LightGBM** 4.0+ - Gradient boosting eficiente
- **SHAP** 0.42+ - Explicabilidad del modelo

### Testing & Quality
- **pytest** 7.4+ - Framework de testing
- **pytest-cov** 4.1+ - Cobertura de código
- **pytest-mock** 3.10+ - Mocking
- **httpx** 0.25+ - Cliente HTTP async
- **black** 23.7+ - Formateo de código
- **ruff** 0.1+ - Linting

### Infraestructura (opcional)
- **Docker** - Containerización local
- **docker-compose** - Orquestación básica
- **Prometheus** - Métricas
- **Grafana** - Visualización de métricas

### Desarrollo
- **Jupyter** 1.0+ - Notebooks interactivos
- **IPython** 8.0+ - Shell interactivo
- **python-dotenv** 1.0+ - Variables de entorno

---

## 🔄 Workflow de Desarrollo

### 1. Desarrollo de Features

```bash
# 1. Crear rama
git checkout -b feature/nueva-funcionalidad

# 2. Desarrollar
# ... código ...

# 3. Ejecutar tests
pytest -v

# 4. Formatear código
black src/ api/ dashboard/

# 5. Linting
ruff check src/ api/ dashboard/

# 6. Commit
git add .
git commit -m "feat: descripción de la feature"

# 7. Push
git push origin feature/nueva-funcionalidad
```

### 2. Docker (opcional)

```bash
# 1. Build de imagen Docker
docker build -t fraud-detection:latest .

# 2. Run local
docker run -p 8000:8000 fraud-detection:latest

# 3. Nota: integraciones cloud se documentan fuera del demo
```

---

## 🗺️ Roadmap

### ✅ Completado (v1.0)

- [x] Pipeline ML end-to-end
- [x] Modelo Random Forest optimizado (95.28% ROC-AUC)
- [x] API REST con autenticación JWT
- [x] Dashboard Streamlit interactivo
- [x] Suite de tests (34/34 pasando)
- [x] Documentación DVP-PRO completa
- [x] Containerización con Docker

### 🚧 En Progreso (v1.1)

- [ ] Integración con MLflow para experiment tracking
- [ ] A/B testing de modelos (entorno de demo)
- [ ] CI/CD pipeline con GitHub Actions
- [ ] Mejoras en el dashboard (más visualizaciones)

### 📋 Planificado (v2.0)

- [ ] Modelo ensemble (Random Forest + XGBoost + LightGBM)
- [ ] Feature store con Feast
- [ ] Streaming de datos con Kafka
- [ ] Detección automática de data drift con Evidently
- [ ] API rate limiting y caching con Redis
- [ ] Despliegue multi-cloud (si se requiere)
- [ ] Explainability avanzada con SHAP
- [ ] Retraining automático con Airflow

---

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

### Guía de Contribución

- Seguir PEP8 para código Python
- Añadir tests para nuevas funcionalidades
- Actualizar documentación según cambios
- Ejecutar `black` y `ruff` antes de commit

---

## 📄 Licencia

Este proyecto está bajo la licencia MIT. Ver archivo [LICENSE](LICENSE) para más detalles.

---

## 🙏 Agradecimientos

- Dataset original: [Kaggle Credit Card Fraud Detection](https://www.kaggle.com/mlg-ulb/creditcardfraud)
- Metodología DVP-PRO desarrollada por Ing. Daniel Varela Perez
- Comunidad open-source de scikit-learn, FastAPI y Streamlit

---

## 📬 Contacto Profesional

**Ing. Daniel Varela Pérez**
Senior Data Scientist & ML Engineer

📧 **Email:** bedaniele0@gmail.com
📱 **Tel:** +52 55 4189 3428
💼 **LinkedIn:** [Tu perfil LinkedIn]
🐙 **GitHub:** [Tu perfil GitHub]

### Especialidades

- Machine Learning & Deep Learning
- MLOps & ML Systems
- API Development (FastAPI, Flask)
- Data Engineering & Pipelines
- Cloud Architecture (AWS, GCP, Azure)

### Disponibilidad

✅ Disponible para:
- Consultoría en proyectos de ML/AI
- Code review y arquitectura de sistemas
- Training y workshops técnicos
- Desarrollo de proyectos end-to-end

---

## 📊 Estadísticas del Proyecto

- **Líneas de código:** ~4,700
- **Tests:** 34/34 pasando (100%)
- **Cobertura:** 19%
- **Modelo:** 95.28% ROC-AUC (test set)
- **API endpoints:** 10+
- **Tiempo de response:** <100ms
- **Documentación:** 8 fases DVP-PRO

---

**© 2024 - Ing. Daniel Varela Pérez | Metodología DVP-PRO**

*Sistema de Detección de Fraude Financiero - Portfolio Demo*

---

## 🔖 Tags

`machine-learning` `fraud-detection` `random-forest` `fastapi` `streamlit` `mlops` `python` `data-science` `dvp-pro` `portfolio-project`

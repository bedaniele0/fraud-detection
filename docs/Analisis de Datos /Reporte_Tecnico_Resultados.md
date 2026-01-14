# Reporte Tecnico de Resultados - Fraud Detection

## 1. Resumen tecnico
Este reporte interpreta los resultados del modelo de deteccion de fraude en el proyecto `fraud_detection`. El modelo principal busca maximizar el equilibrio precision/recall con umbral ajustado (threshold=0.30) y esta desplegado via API y dashboard.

## 2. Modelo y datos
- Modelo principal: `models/improved_recall_threshold_model.pkl`
- Umbral operativo: 0.30 (optimizado para F1 con enfasis en recall)
- Dataset base: `data/raw/creditcard.csv`
- Datos procesados: `data/processed/train_clean.parquet`, `validation_clean.parquet`, `test_clean.parquet`
- Pipeline incluye limpieza, balanceo y feature engineering

## 3. Metricas principales
### 3.1 Validacion (archivo oficial)
Fuente: `reports/metrics/model_metrics.json`
- Precision: 0.9362
- Recall: 0.7213
- F1-score: 0.8148
- Accuracy: 0.9997
- ROC-AUC: 0.9528

### 3.2 Evaluacion en test (registro de ejecucion)
Fuente: `docs/F9_closure.md`
- Precision: 0.9362
- Recall: 0.7213
- F1-score: 0.8148
- ROC-AUC: 0.9528

**Interpretacion:** el modelo mantiene alta precision y AUC en test, con recall en torno a 0.72. El umbral 0.30 prioriza reducir falsos positivos sin sacrificar en exceso la deteccion de fraude.

## 4. Calibracion y umbral
- Threshold=0.30 mejora F1 y mantiene precision alta
- Umbral configurable via API para ajustar sensibilidad segun tolerancia de negocio

## 5. Infraestructura operativa
- API con endpoints de prediccion, batch, metricas y configuracion de umbral
- Dashboard interactivo para analisis y monitoreo
- Monitoreo de drift y alertas basicas
- Tests automatizados (API, pipeline y modelo)

## 6. Limitaciones
- Desbalance extremo de clases: accuracy alta no refleja performance real
- Recall debajo de 0.80 (objetivo ideal) en algunos escenarios
- Dataset historico, requiere validacion con datos recientes en produccion real

## 7. Recomendaciones tecnicas
1. Ajustar umbral segun costo FP/FN y capacidad operativa de revision.
2. Explorar modelos ensemble (LightGBM/XGBoost) para aumentar recall.
3. Reentrenar con datos recientes y validar drift periodicamente.
4. Incorporar monitoreo continuo de performance con alertas por degradacion.

---

Fuentes:
- `reports/metrics/model_metrics.json`
- `docs/F9_closure.md`

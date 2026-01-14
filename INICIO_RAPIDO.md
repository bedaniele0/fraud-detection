# 🚀 INICIO RÁPIDO - Sistema de Detección de Fraude

**Autor:** Ing. Daniel Varela Pérez
📧 bedaniele0@gmail.com | 📱 +52 55 4189 3428

---

## ⚡ Configuración en 2 Pasos (5 minutos)

### Paso 1: Ejecutar Setup Automático

```bash
cd ~/Desktop/fraud_detection
./setup_project.sh
```

Esto:
- ✅ Activa el entorno virtual `venv_fraud/`
- ✅ Instala todas las dependencias
- ✅ Instala el paquete en modo editable
- ✅ Habilita los comandos CLI (`fraud-train`, `fraud-api`, etc.)

### Paso 2: Ejecutar Tests

```bash
pytest -v
```

Esto valida que el entorno y el pipeline base están funcionando:
- ✅ Tests (34/34 passing)

---

## 🎯 Uso del Sistema

### 1️⃣ Pipeline ML (CLI)

```bash
# Activar entorno (si no está activo)
source venv_fraud/bin/activate

# Entrenar modelo
fraud-train --train-path data/processed/train_clean.parquet/part.0.parquet \
            --val-path data/processed/validation_clean.parquet

# Evaluar modelo
fraud-evaluate --test-path data/processed/test_clean.parquet

# Predicciones batch
fraud-predict --input-path data/processed/test_clean.parquet \
              --output-path reports/predictions/predicciones.csv
```

### 2️⃣ API REST

```bash
# Opción 1: Comando simplificado
fraud-api

# Opción 2: Uvicorn directo
uvicorn api.main:app --reload
```

**Acceder a:**
- Swagger Docs: http://localhost:8000/docs
- Redoc: http://localhost:8000/redoc

**Test rápido:**
```bash
# 1. Obtener token
curl -X POST "http://localhost:8000/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=admin&password=admin123"

# 2. Copiar el token y usar en /docs
```

### 3️⃣ Dashboard Interactivo

```bash
# Opción 1: Comando simplificado
fraud-dashboard

# Opción 2: Streamlit directo
streamlit run dashboard/fraud_detection_dashboard.py
```

**Acceder a:** http://localhost:8501

**Módulos disponibles:**
- 🔍 Predicción Individual
- 📂 Análisis por Lote
- 📈 Métricas en Tiempo Real
- 📊 Métricas Acumuladas

### 4️⃣ Tests

```bash
# Suite completa
pytest -v

# Con cobertura
pytest --cov=src --cov=api --cov-report=html

# Abrir reporte
open htmlcov/index.html
```

---

## 🐛 Problemas Comunes

### ❌ "fraud-train: command not found"

**Solución:**
```bash
source venv_fraud/bin/activate
pip install -e .
```

### ❌ "ModuleNotFoundError: No module named 'models'"

**Solución:**
```bash
pip install -e .
```

### ❌ Tests fallan

**Solución:**
```bash
# Re-instalar paquete
pip install -e .

# Verificar pytest
pytest -v
```

### ❌ API no carga modelo

**Solución:**
```bash
# Entrenar modelo primero
fraud-train --train-path data/processed/train_clean.parquet/part.0.parquet \
            --val-path data/processed/validation_clean.parquet

# Verificar que models/fraud_model.pkl existe
ls -lh models/
```

---

## 📋 Checklist Rápido

Antes de presentar el proyecto:

```bash
# 1. Activar entorno
source venv_fraud/bin/activate

# 2. Ejecutar setup (si es primera vez)
./setup_project.sh

# 3. Ejecutar tests
pytest -v

# 5. Entrenar modelo (si no existe)
fraud-train --train-path data/processed/train_clean.parquet/part.0.parquet \
            --val-path data/processed/validation_clean.parquet

# 6. Lanzar servicios
fraud-api        # Terminal 1
fraud-dashboard  # Terminal 2
```

---

## 📚 Documentación Adicional

- **Setup detallado:** `INSTRUCCIONES_SETUP.md`
- **Validación completa:** `VALIDACION_PORTFOLIO.md`
- **README principal:** `README.md`
- **Docs DVP-PRO:** `docs/F0_*.md` hasta `docs/F9_*.md`

---

## 🆘 Soporte

**Ing. Daniel Varela Pérez**
📧 bedaniele0@gmail.com
📱 +52 55 4189 3428

---

**© 2024 - Sistema de Detección de Fraude | Metodología DVP-PRO**

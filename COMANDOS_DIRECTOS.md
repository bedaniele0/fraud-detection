# 🎯 SOLUCIÓN INMEDIATA - Comandos Directos con Python

**Autor:** Ing. Daniel Varela Pérez
📧 bedaniele0@gmail.com | 📱 +52 55 4189 3428

---

## 🔍 PROBLEMA IDENTIFICADO

Los entry points de `setup.py` no se crean porque `dashboard/` y `api/` están **fuera de `src/`**, pero el setup.py solo incluye paquetes de `src/`.

---

## ✅ SOLUCIÓN (mientras arreglamos el setup.py)

### Usa Python directamente:

**En tu terminal con el entorno activado `(venv)`:**

```bash
# 1. Entrenar modelo
python src/models/train_fraud.py --train-path data/processed/train_clean.parquet/part.0.parquet \
                                 --val-path data/processed/validation_clean.parquet

# 2. Evaluar modelo
python src/models/evaluate.py --test-path data/processed/test_clean.parquet

# 3. Predicciones
python src/models/predict.py --input-path data/processed/test_clean.parquet \
                             --output-path reports/predictions/predicciones.csv

# 4. Lanzar API
python -m uvicorn api.main:app --reload

# 5. Lanzar Dashboard
python -m streamlit run dashboard/fraud_detection_dashboard.py
```

---

## 🚀 QUICK START (Copiar y Pegar)

**Ejecuta esto EN TU TERMINAL (ya tienes venv activado):**

### 1️⃣ Entrenar Modelo

```bash
python src/models/train_fraud.py --train-path data/processed/train_clean.parquet/part.0.parquet --val-path data/processed/validation_clean.parquet
```

### 2️⃣ Evaluar Modelo

```bash
python src/models/evaluate.py --test-path data/processed/test_clean.parquet
```

### 3️⃣ Lanzar API

```bash
python -m uvicorn api.main:app --reload
```

Luego abre: http://localhost:8000/docs

### 4️⃣ Lanzar Dashboard

```bash
python -m streamlit run dashboard/fraud_detection_dashboard.py
```

Luego abre: http://localhost:8501

---

## 📝 ALIASES TEMPORALES (Opcional)

Puedes crear aliases en tu terminal actual:

```bash
# Copiar y pegar todo esto en tu terminal
alias fraud-train='python src/models/train_fraud.py'
alias fraud-evaluate='python src/models/evaluate.py'
alias fraud-predict='python src/models/predict.py'
alias fraud-api='python -m uvicorn api.main:app --reload'
alias fraud-dashboard='python -m streamlit run dashboard/fraud_detection_dashboard.py'

# Ahora puedes usar:
fraud-train --help
fraud-api
fraud-dashboard
```

**NOTA:** Estos aliases solo funcionan en la sesión actual de terminal.

---

## 🔧 SOLUCIÓN PERMANENTE (Para Después)

Voy a corregir el `setup.py` para incluir `api/` y `dashboard/` correctamente. Mientras tanto, usa los comandos de arriba.

---

## ✅ VALIDACIÓN

Ejecuta esto para verificar que todo funciona:

```bash
# 1. Verificar que Python encuentra los módulos
python -c "import src.models.train_fraud; print('✅ Module loaded')"

# 2. Ver ayuda de entrenamiento
python src/models/train_fraud.py --help

# 3. Verificar API
python -c "import api.main; print('✅ API module loaded')"

# 4. Verificar Dashboard
python -c "import dashboard.fraud_detection_dashboard; print('✅ Dashboard module loaded')"
```

---

## 📊 RESUMEN

| Comando Esperado | Comando Actual (que funciona) |
|------------------|-------------------------------|
| `fraud-train` | `python src/models/train_fraud.py` |
| `fraud-evaluate` | `python src/models/evaluate.py` |
| `fraud-predict` | `python src/models/predict.py` |
| `fraud-api` | `python -m uvicorn api.main:app --reload` |
| `fraud-dashboard` | `python -m streamlit run dashboard/fraud_detection_dashboard.py` |

---

## 🎯 SIGUIENTE ACCIÓN

**Copia y pega esto para entrenar el modelo:**

```bash
python src/models/train_fraud.py --train-path data/processed/train_clean.parquet/part.0.parquet --val-path data/processed/validation_clean.parquet
```

Esto debería tomar unos minutos y crear el modelo en `models/fraud_model.pkl`.

---

**© 2024 - Ing. Daniel Varela Perez | Metodología DVP-PRO**

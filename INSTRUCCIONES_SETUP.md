# 🛠️ Instrucciones de Configuración - Sistema de Detección de Fraude

**Autor:** Ing. Daniel Varela Pérez
📧 bedaniele0@gmail.com | 📱 +52 55 4189 3428

---

## 🎯 Problema Identificado

Tu proyecto está **correctamente estructurado**, pero falta instalarlo en modo editable para que los comandos CLI (`fraud-train`, `fraud-predict`, etc.) estén disponibles.

### ❌ Errores Observados:
```bash
# Error 1: Entorno virtual no encontrado
source venv/bin/activate
-bash: venv/bin/activate: No such file or directory

# Error 2: Comandos CLI no disponibles
fraud-train --train-path ...
-bash: fraud-train: command not found
```

### ✅ Causa Raíz:
- El entorno virtual existe como `venv_fraud/` (no `venv/`)
- El paquete **NO** está instalado en modo editable (`pip install -e .`)
- Los entry points del `setup.py` requieren la instalación del paquete

---

## 🚀 Solución Rápida (Opción Automática)

### Ejecutar el script de setup automático:

```bash
# Desde la raíz del proyecto fraud_detection/
./setup_project.sh
```

Este script:
1. ✅ Verifica Python 3
2. ✅ Activa `venv_fraud/` (o crea entorno si no existe)
3. ✅ Actualiza pip, setuptools, wheel
4. ✅ Instala todas las dependencias desde `requirements.txt`
5. ✅ Instala el paquete en modo editable (`pip install -e .`)
6. ✅ Verifica que los comandos CLI estén disponibles

---

## 🔧 Solución Manual (Paso a Paso)

Si prefieres hacerlo manualmente:

### 1️⃣ Activar el Entorno Virtual

```bash
cd ~/Desktop/fraud_detection
source venv_fraud/bin/activate
```

### 2️⃣ Actualizar pip

```bash
pip install --upgrade pip setuptools wheel
```

### 3️⃣ Instalar Dependencias

```bash
pip install -r requirements.txt
```

### 4️⃣ **CRÍTICO**: Instalar el Paquete en Modo Editable

```bash
pip install -e .
```

Esto:
- Registra los comandos CLI definidos en `setup.py` → `entry_points`
- Permite ejecutar `fraud-train`, `fraud-predict`, etc.
- Hace que el código en `src/` sea importable

### 5️⃣ Verificar Instalación

```bash
# Verificar comandos disponibles
which fraud-train
which fraud-predict
which fraud-evaluate
which fraud-dashboard
which fraud-api

# Deben aparecer rutas como:
# /Users/danielevarella/Desktop/fraud_detection/venv_fraud/bin/fraud-train
```

---

## ✅ Validación Post-Instalación

### 1️⃣ Ejecutar Tests

```bash
pytest -v
```

Esperado: `34 passed` ✅

### 2️⃣ Entrenar Modelo

```bash
fraud-train --train-path data/processed/train_clean.parquet/part.0.parquet \
            --val-path data/processed/validation_clean.parquet
```

### 3️⃣ Evaluar Modelo

```bash
fraud-evaluate --test-path data/processed/test_clean.parquet
```

### 4️⃣ Hacer Predicciones

```bash
fraud-predict --input-path data/processed/test_clean.parquet \
              --output-path reports/predictions/predicciones.csv
```

### 5️⃣ Lanzar API

```bash
fraud-api
# o
uvicorn api.main:app --reload
```

Abrir: http://localhost:8000/docs

### 6️⃣ Lanzar Dashboard

```bash
fraud-dashboard
# o
streamlit run dashboard/fraud_detection_dashboard.py
```

Abrir: http://localhost:8501

---

## 📊 Entry Points Configurados (setup.py)

```python
entry_points={
    "console_scripts": [
        "fraud-train=models.train_fraud:main",
        "fraud-predict=models.predict:main",
        "fraud-evaluate=models.evaluate:main",
        "fraud-dashboard=dashboard.fraud_detection_dashboard:main",
        "fraud-api=api.main:main",
        "fraud-monitor=monitoring.monitoring_run:main",
    ],
}
```

Estos comandos **SOLO** funcionan después de `pip install -e .`

---

## 🐛 Troubleshooting

### Problema: "ModuleNotFoundError: No module named 'models'"

**Solución:**
```bash
pip install -e .
```

### Problema: "fraud-train: command not found" después de instalar

**Solución:**
```bash
# Re-activar el entorno
deactivate
source venv_fraud/bin/activate

# Verificar PATH
echo $PATH | grep venv_fraud
```

### Problema: Tests fallan con "no module named 'api'"

**Solución:**
```bash
# El paquete debe estar instalado en modo editable
pip install -e .
pytest -v
```

---

## 📋 Checklist Pre-Demo para Portfolio

- [ ] Entorno virtual activado (`venv_fraud/`)
- [ ] Paquete instalado en modo editable (`pip install -e .`)
- [ ] Tests ejecutados exitosamente (`pytest -v` → 34/34 ✅)
- [ ] Modelo entrenado y guardado en `models/`
- [ ] API funcionando en http://localhost:8000
- [ ] Dashboard funcionando en http://localhost:8501
- [ ] Documentación README actualizada
- [ ] `.gitignore` configurado (no subir `venv_fraud/`, `__pycache__/`, etc.)

---

## 🎯 Comandos de Referencia Rápida

```bash
# Activar entorno
source venv_fraud/bin/activate

# Tests
pytest -v

# Pipeline ML completo
fraud-train --train-path data/processed/train_clean.parquet/part.0.parquet \
            --val-path data/processed/validation_clean.parquet
fraud-evaluate --test-path data/processed/test_clean.parquet
fraud-predict --input-path data/processed/test_clean.parquet \
              --output-path reports/predictions/predicciones.csv

# Servicios
fraud-api        # API REST en :8000
fraud-dashboard  # Dashboard en :8501

# Monitoreo (Docker)
docker-compose -f docker-compose.monitoring.yml up -d
```

---

## 📬 Soporte

**Ing. Daniel Varela Pérez**
📧 bedaniele0@gmail.com
📱 +52 55 4189 3428

---

**© 2025 - Sistema de Detección de Fraude | Metodología DVP-PRO**

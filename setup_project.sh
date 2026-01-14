#!/bin/bash
################################################################################
# Setup Script - Fraud Detection System
# Autor: Ing. Daniel Varela Perez
# Email: bedaniele0@gmail.com
# Tel: +52 55 4189 3428
################################################################################

echo "🚀 Configurando Proyecto de Detección de Fraude..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 1. Verificar Python
echo "📍 Paso 1: Verificando Python..."
python3 --version

# 2. Usar entorno virtual existente o crear uno nuevo
if [ -d "venv_fraud" ]; then
    echo "✅ Entorno virtual 'venv_fraud' encontrado"
    echo "📍 Paso 2: Activando entorno virtual existente..."
    source venv_fraud/bin/activate
else
    echo "📍 Paso 2: Creando nuevo entorno virtual..."
    python3 -m venv venv_fraud
    source venv_fraud/bin/activate
fi

# 3. Actualizar pip
echo "📍 Paso 3: Actualizando pip..."
pip install --upgrade pip setuptools wheel

# 4. Instalar dependencias
echo "📍 Paso 4: Instalando dependencias desde requirements.txt..."
pip install -r requirements.txt

# 5. Instalar el paquete en modo editable (esto habilita los comandos CLI)
echo "📍 Paso 5: Instalando paquete fraud-detection-system en modo editable..."
pip install -e .

# 6. Verificar instalación de comandos CLI
echo ""
echo "✅ VERIFICACIÓN DE INSTALACIÓN:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Comandos CLI disponibles:"
which fraud-train
which fraud-predict
which fraud-evaluate
which fraud-dashboard
which fraud-api

echo ""
echo "📊 Versiones instaladas:"
python --version
pip list | grep -E "pandas|scikit-learn|fastapi|streamlit"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ CONFIGURACIÓN COMPLETA"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📝 PRÓXIMOS PASOS:"
echo ""
echo "1️⃣  Activar el entorno (si no está activo):"
echo "    source venv_fraud/bin/activate"
echo ""
echo "2️⃣  Ejecutar tests para validar:"
echo "    pytest -v"
echo ""
echo "3️⃣  Entrenar modelo:"
echo "    fraud-train --train-path data/processed/train_clean.parquet/part.0.parquet \\"
echo "                --val-path data/processed/validation_clean.parquet"
echo ""
echo "4️⃣  Evaluar modelo:"
echo "    fraud-evaluate --test-path data/processed/test_clean.parquet"
echo ""
echo "5️⃣  Lanzar API:"
echo "    fraud-api"
echo ""
echo "6️⃣  Lanzar Dashboard:"
echo "    fraud-dashboard"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "👨‍💻 Ing. Daniel Varela Perez | bedaniele0@gmail.com"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

#!/bin/bash
################################################################################
# Install Package Script - Fraud Detection System
# Autor: Ing. Daniel Varela Perez
# Email: bedaniele0@gmail.com
# Tel: +52 55 4189 3428
################################################################################

echo "╔════════════════════════════════════════════════════════════════════════╗"
echo "║     INSTALACIÓN DEL PAQUETE - FRAUD DETECTION SYSTEM                  ║"
echo "╚════════════════════════════════════════════════════════════════════════╝"
echo ""

# Usar la ruta completa al pip del entorno virtual
VENV_PIP="/Users/danielevarella/Desktop/fraud_detection/venv_fraud/bin/pip"
VENV_PYTHON="/Users/danielevarella/Desktop/fraud_detection/venv_fraud/bin/python"

echo "📍 Paso 1: Verificando pip del entorno virtual..."
if [ -f "$VENV_PIP" ]; then
    echo "✅ pip encontrado en: $VENV_PIP"
    $VENV_PIP --version
else
    echo "❌ ERROR: pip no encontrado en venv_fraud/bin/"
    exit 1
fi

echo ""
echo "📍 Paso 2: Actualizando pip, setuptools y wheel..."
$VENV_PIP install --upgrade pip setuptools wheel

echo ""
echo "📍 Paso 3: Instalando paquete fraud-detection-system en modo editable..."
$VENV_PIP install -e .

echo ""
echo "╔════════════════════════════════════════════════════════════════════════╗"
echo "║                    VERIFICACIÓN DE INSTALACIÓN                        ║"
echo "╚════════════════════════════════════════════════════════════════════════╝"
echo ""

echo "📦 Paquete instalado:"
$VENV_PIP show fraud-detection-system

echo ""
echo "🔧 Comandos CLI disponibles:"
ls -lh venv_fraud/bin/fraud-* 2>/dev/null || echo "⚠️  Comandos CLI no encontrados todavía"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ INSTALACIÓN COMPLETA"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📝 PRÓXIMOS PASOS:"
echo ""
echo "1️⃣  Activar entorno (en tu terminal):"
echo "    source venv_fraud/bin/activate"
echo ""
echo "2️⃣  Verificar comandos disponibles:"
echo "    which fraud-train"
echo "    which fraud-api"
echo ""
echo "3️⃣  Entrenar modelo:"
echo "    fraud-train --train-path data/processed/train_clean.parquet/part.0.parquet \\"
echo "                --val-path data/processed/validation_clean.parquet"
echo ""
echo "4️⃣  Ejecutar tests:"
echo "    pytest -v"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "👨‍💻 Ing. Daniel Varela Perez | bedaniele0@gmail.com"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

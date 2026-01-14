#!/bin/bash
################################################################################
# Fix Environment Script - Fraud Detection System
# Autor: Ing. Daniel Varela Perez
# Email: bedaniele0@gmail.com
# Tel: +52 55 4189 3428
#
# Este script soluciona el problema del entorno virtual corrupto
################################################################################

set -e  # Exit on error

echo "╔════════════════════════════════════════════════════════════════════════╗"
echo "║     REPARACIÓN DEL ENTORNO VIRTUAL - FRAUD DETECTION                  ║"
echo "╚════════════════════════════════════════════════════════════════════════╝"
echo ""

echo "🔍 DIAGNÓSTICO:"
echo "   El entorno virtual venv_fraud/ está corrupto (shebangs incorrectos)"
echo "   Vamos a crear un entorno nuevo y limpio llamado 'venv/'"
echo ""

# Cambiar al directorio del proyecto
cd /Users/danielevarella/Desktop/fraud_detection

# 1. Crear nuevo entorno virtual limpio
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📍 Paso 1: Creando nuevo entorno virtual 'venv/'..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Usar python3 del sistema
python3 -m venv venv

echo "✅ Entorno virtual creado exitosamente"
echo ""

# 2. Actualizar pip
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📍 Paso 2: Actualizando pip..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

venv/bin/pip install --upgrade pip setuptools wheel

echo ""

# 3. Instalar dependencias
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📍 Paso 3: Instalando dependencias desde requirements.txt..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

venv/bin/pip install -r requirements.txt

echo ""

# 4. Instalar paquete en modo editable
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📍 Paso 4: Instalando paquete fraud-detection-system en modo editable..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

venv/bin/pip install -e .

echo ""

# 5. Verificación
echo "╔════════════════════════════════════════════════════════════════════════╗"
echo "║                        VERIFICACIÓN FINAL                              ║"
echo "╚════════════════════════════════════════════════════════════════════════╝"
echo ""

echo "✅ Python version:"
venv/bin/python --version

echo ""
echo "✅ Paquete instalado:"
venv/bin/pip show fraud-detection-system | head -10

echo ""
echo "✅ Comandos CLI disponibles:"
ls -1 venv/bin/fraud-* 2>/dev/null | while read cmd; do
    echo "   - $(basename $cmd)"
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ REPARACIÓN COMPLETA"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📝 IMPORTANTE - USAR NUEVO ENTORNO:"
echo ""
echo "Desde ahora, usa este comando para activar el entorno:"
echo ""
echo "    source venv/bin/activate"
echo ""
echo "Ya NO uses venv_fraud/ (está corrupto)"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📝 PRÓXIMOS PASOS:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1️⃣  Cerrar tu terminal actual"
echo ""
echo "2️⃣  Abrir nueva terminal y ejecutar:"
echo "    cd ~/Desktop/fraud_detection"
echo "    source venv/bin/activate"
echo ""
echo "3️⃣  Verificar comandos:"
echo "    which fraud-train"
echo "    fraud-train --help"
echo ""
echo "4️⃣  Ejecutar tests:"
echo "    pytest -v"
echo ""
echo "5️⃣  Entrenar modelo:"
echo "    fraud-train --train-path data/processed/train_clean.parquet/part.0.parquet \\"
echo "                --val-path data/processed/validation_clean.parquet"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "👨‍💻 Ing. Daniel Varela Perez | bedaniele0@gmail.com"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

#!/bin/bash
################################################################################
# Validation Script - Fraud Detection System
# Autor: Ing. Daniel Varela Perez
# Email: bedaniele0@gmail.com
# Tel: +52 55 4189 3428
#
# Ejecuta todas las validaciones del proyecto para portfolio
################################################################################

set -e  # Exit on error

echo "╔════════════════════════════════════════════════════════════════════════╗"
echo "║     VALIDACIÓN COMPLETA - SISTEMA DE DETECCIÓN DE FRAUDE              ║"
echo "║     Autor: Ing. Daniel Varela Perez                                   ║"
echo "╚════════════════════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counters
PASSED=0
FAILED=0

# Test function
test_step() {
    local description=$1
    local command=$2

    echo -n "🔍 Testing: $description... "

    if eval "$command" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ PASS${NC}"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}❌ FAIL${NC}"
        ((FAILED++))
        return 1
    fi
}

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📍 FASE 1: Verificación de Entorno"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Verificar que estamos en el directorio correcto
if [ ! -f "setup.py" ]; then
    echo -e "${RED}❌ ERROR: Ejecutar desde el directorio fraud_detection/${NC}"
    exit 1
fi

# Verificar Python
test_step "Python 3.10+" "python3 --version | grep -E 'Python 3\.(1[0-3]|[2-9][0-9])'"

# Verificar entorno virtual
if [ -d "venv_fraud" ]; then
    echo -e "🔍 Testing: Entorno virtual existe... ${GREEN}✅ PASS${NC}"
    ((PASSED++))

    # Intentar activar
    if [ -f "venv_fraud/bin/activate" ]; then
        source venv_fraud/bin/activate
        echo -e "🔍 Testing: Entorno activado... ${GREEN}✅ PASS${NC}"
        ((PASSED++))
    else
        echo -e "🔍 Testing: Entorno activado... ${RED}❌ FAIL${NC}"
        ((FAILED++))
    fi
else
    echo -e "🔍 Testing: Entorno virtual existe... ${YELLOW}⚠️  WARN - Ejecutar ./setup_project.sh${NC}"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📍 FASE 2: Verificación de Instalación del Paquete"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Verificar que el paquete está instalado
test_step "Paquete fraud-detection-system instalado" "pip show fraud-detection-system"

# Verificar comandos CLI
test_step "Comando fraud-train disponible" "which fraud-train"
test_step "Comando fraud-predict disponible" "which fraud-predict"
test_step "Comando fraud-evaluate disponible" "which fraud-evaluate"
test_step "Comando fraud-dashboard disponible" "which fraud-dashboard"
test_step "Comando fraud-api disponible" "which fraud-api"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📍 FASE 3: Verificación de Estructura del Proyecto"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Directorios clave
test_step "Directorio src/ existe" "[ -d src ]"
test_step "Directorio api/ existe" "[ -d api ]"
test_step "Directorio dashboard/ existe" "[ -d dashboard ]"
test_step "Directorio tests/ existe" "[ -d tests ]"
test_step "Directorio data/processed/ existe" "[ -d data/processed ]"
test_step "Directorio models/ existe" "[ -d models ]"
test_step "Directorio docs/ existe" "[ -d docs ]"

# Archivos clave
test_step "README.md existe" "[ -f README.md ]"
test_step "requirements.txt existe" "[ -f requirements.txt ]"
test_step "setup.py existe" "[ -f setup.py ]"
test_step "Dockerfile existe" "[ -f Dockerfile ]"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📍 FASE 4: Verificación de Datos Procesados"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

test_step "Train data disponible" "[ -f data/processed/train_clean.parquet/part.0.parquet ]"
test_step "Validation data disponible" "[ -d data/processed/validation_clean.parquet ]"
test_step "Test data disponible" "[ -d data/processed/test_clean.parquet ]"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📍 FASE 5: Verificación de Artefactos del Modelo"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Verificar si el modelo existe
if [ -f "models/fraud_model.pkl" ]; then
    echo -e "🔍 Testing: Modelo entrenado existe... ${GREEN}✅ PASS${NC}"
    ((PASSED++))

    test_step "Metadata del modelo existe" "[ -f models/model_metadata.json ]"
    test_step "Threshold guardado" "[ -f models/optimal_threshold.txt ]"
else
    echo -e "🔍 Testing: Modelo entrenado existe... ${YELLOW}⚠️  WARN - Ejecutar fraud-train${NC}"
    echo -e "           ${YELLOW}Puedes entrenar con:${NC}"
    echo -e "           ${YELLOW}fraud-train --train-path data/processed/train_clean.parquet/part.0.parquet \\${NC}"
    echo -e "           ${YELLOW}            --val-path data/processed/validation_clean.parquet${NC}"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📍 FASE 6: Ejecución de Tests"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Ejecutar pytest
echo "🧪 Ejecutando suite de tests..."
if pytest -v --tb=short 2>&1 | tee /tmp/pytest_output.txt; then
    # Contar tests passed
    TESTS_PASSED=$(grep -c "PASSED" /tmp/pytest_output.txt || echo "0")
    echo -e "${GREEN}✅ Tests ejecutados: $TESTS_PASSED passed${NC}"
    ((PASSED++))
else
    echo -e "${RED}❌ Algunos tests fallaron - revisar output arriba${NC}"
    ((FAILED++))
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📍 FASE 7: Verificación de Dependencias Clave"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

test_step "pandas instalado" "python -c 'import pandas'"
test_step "scikit-learn instalado" "python -c 'import sklearn'"
test_step "fastapi instalado" "python -c 'import fastapi'"
test_step "streamlit instalado" "python -c 'import streamlit'"
test_step "pytest instalado" "python -c 'import pytest'"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📍 FASE 8: Verificación de Documentación DVP-PRO"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

test_step "F0: Problem Statement" "[ -f docs/F0_problem_statement.md ]"
test_step "F1: Setup" "[ -f docs/F1_setup.md ]"
test_step "F2: Architecture" "[ -f docs/F2_architecture.md ]"
test_step "F7: Deployment" "[ -f docs/F7_deployment.md ]"
test_step "F8: Monitoring" "[ -f docs/F8_monitoring.md ]"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📍 FASE 9: Verificación de Calidad de Código"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Black (si está instalado)
if command -v black &> /dev/null; then
    test_step "Código formateado con Black" "black --check src/ api/ dashboard/ 2>&1 | grep -q 'would\|reformatted' && exit 1 || exit 0"
else
    echo -e "🔍 Testing: Black instalado... ${YELLOW}⚠️  SKIP${NC}"
fi

echo ""
echo "╔════════════════════════════════════════════════════════════════════════╗"
echo "║                        RESUMEN DE VALIDACIÓN                          ║"
echo "╚════════════════════════════════════════════════════════════════════════╝"
echo ""
echo -e "  ${GREEN}✅ PASSED: $PASSED${NC}"
echo -e "  ${RED}❌ FAILED: $FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  ✅ PROYECTO VALIDADO - LISTO PARA PORTFOLIO / ENTREVISTAS            ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "📋 SIGUIENTE PASOS RECOMENDADOS:"
    echo ""
    echo "1️⃣  Subir a GitHub (si aún no está):"
    echo "    git add ."
    echo "    git commit -m 'Sistema de Detección de Fraude - v1.0'"
    echo "    git push origin main"
    echo ""
    echo "2️⃣  Añadir screenshots al README:"
    echo "    - Dashboard Streamlit"
    echo "    - API Swagger docs"
    echo "    - Resultados de tests"
    echo ""
    echo "3️⃣  Preparar demos para entrevistas:"
    echo "    Ver: VALIDACION_PORTFOLIO.md (sección Demos)"
    echo ""
    exit 0
else
    echo -e "${RED}╔════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║  ⚠️  ALGUNAS VALIDACIONES FALLARON - REVISAR ARRIBA                   ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "🔧 ACCIONES CORRECTIVAS:"
    echo ""
    echo "Si falta el entorno virtual:"
    echo "  ./setup_project.sh"
    echo ""
    echo "Si faltan comandos CLI:"
    echo "  source venv_fraud/bin/activate"
    echo "  pip install -e ."
    echo ""
    echo "Si faltan datos procesados:"
    echo "  Revisar notebooks/01_eda.ipynb y ejecutar procesamiento"
    echo ""
    echo "Si falta el modelo:"
    echo "  fraud-train --train-path data/processed/train_clean.parquet/part.0.parquet \\"
    echo "              --val-path data/processed/validation_clean.parquet"
    echo ""
    exit 1
fi

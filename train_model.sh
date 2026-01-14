#!/bin/bash
################################################################################
# Train Model Script - Fraud Detection System
# Autor: Ing. Daniel Varela Perez
# Email: bedaniele0@gmail.com
# Tel: +52 55 4189 3428
################################################################################

echo "🚀 Entrenando modelo de detección de fraude..."
echo ""

python src/models/train_fraud.py \
    --train-path data/processed/train_clean.parquet/part.0.parquet \
    --val-path data/processed/validation_clean.parquet

echo ""
echo "✅ Script de entrenamiento completado"

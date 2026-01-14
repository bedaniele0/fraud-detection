"""
evaluate.py - Evaluación del modelo entrenado
=============================================
Calcula métricas en el conjunto de prueba y guarda resultados.

Autor: Ing. Daniel Varela Perez
Email: bedaniele0@gmail.com
Tel: +52 55 4189 3428
Metodología: DVP-PRO
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Dict

import joblib
import numpy as np
import pandas as pd
from sklearn.metrics import accuracy_score, f1_score, precision_score, recall_score, roc_auc_score

DEFAULT_THRESHOLD_PATH = Path("models/threshold_config.json")
DEFAULT_METRICS_PATH = Path("reports/metrics/model_metrics.json")


def load_threshold(path: Path) -> float:
    if not path.exists():
        return 0.5
    with open(path, "r", encoding="utf-8") as f:
        return float(json.load(f).get("optimal_threshold", 0.5))


def evaluate(df: pd.DataFrame, model, threshold: float) -> Dict[str, float]:
    X = df.drop(columns=["Class"])
    y = df["Class"].astype(int)

    if hasattr(model, "feature_names_in_"):
        X = X[model.feature_names_in_]

    proba = model.predict_proba(X)[:, 1]
    preds = (proba >= threshold).astype(int)

    return {
        "precision": precision_score(y, preds, zero_division=0),
        "recall": recall_score(y, preds, zero_division=0),
        "f1_score": f1_score(y, preds, zero_division=0),
        "accuracy": accuracy_score(y, preds),
        "roc_auc": roc_auc_score(y, proba),
        "support": int(y.sum()),
    }


def main() -> None:
    parser = argparse.ArgumentParser(description="Evalúa el modelo en el conjunto de prueba.")
    parser.add_argument(
        "--test-path",
        default="data/processed/test_clean.parquet",
        help="Ruta al parquet de test (parquet o carpeta).",
    )
    parser.add_argument(
        "--model-path",
        default="models/improved_recall_threshold_model.pkl",
        help="Ruta al modelo entrenado.",
    )
    args = parser.parse_args()

    model = joblib.load(args.model_path)
    threshold = load_threshold(DEFAULT_THRESHOLD_PATH)
    df = pd.read_parquet(args.test_path)

    metrics = evaluate(df, model, threshold)

    DEFAULT_METRICS_PATH.parent.mkdir(parents=True, exist_ok=True)
    with open(DEFAULT_METRICS_PATH, "w", encoding="utf-8") as f:
        json.dump(metrics, f, indent=2)

    print("✅ Evaluación completada")
    print(f"   Métricas test: {metrics}")
    print(f"   Threshold usado: {threshold:.3f}")


if __name__ == "__main__":
    main()

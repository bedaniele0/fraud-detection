"""
============================================================================
train_fraud.py - Entrenamiento reproducible del modelo de fraude
============================================================================
CLI DVP-PRO para entrenar, validar y versionar el modelo RandomForest.

Autor: Ing. Daniel Varela Perez
Email: bedaniele0@gmail.com
Tel: +52 55 4189 3428
Metodología: DVP-PRO
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Dict, Tuple

import joblib
import numpy as np
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import (
    accuracy_score,
    f1_score,
    precision_score,
    recall_score,
    roc_auc_score,
)
from sklearn.model_selection import train_test_split

DEFAULT_MODEL_PATH = Path("models/improved_recall_threshold_model.pkl")
DEFAULT_THRESHOLD_PATH = Path("models/threshold_config.json")
DEFAULT_METRICS_PATH = Path("reports/metrics/model_metrics.json")
DEFAULT_METADATA_PATH = Path("data/processed/pipeline_metadata_clean.json")


def load_metadata(path: Path) -> Dict:
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)


def load_dataset(train_path: Path, val_path: Path) -> Tuple[pd.DataFrame, pd.DataFrame]:
    train_df = pd.read_parquet(train_path)
    val_df = pd.read_parquet(val_path)
    return train_df, val_df


def get_feature_target(df: pd.DataFrame, feature_cols) -> Tuple[pd.DataFrame, pd.Series]:
    X = df[feature_cols].copy()
    y = df["Class"].astype(int)
    return X, y


def fit_model(X_train: pd.DataFrame, y_train: pd.Series, n_estimators: int = 200) -> RandomForestClassifier:
    model = RandomForestClassifier(
        n_estimators=n_estimators,
        random_state=42,
        n_jobs=-1,
        class_weight="balanced",
    )
    model.fit(X_train, y_train)
    return model


def find_best_threshold(y_true: np.ndarray, y_proba: np.ndarray) -> float:
    thresholds = np.linspace(0.1, 0.9, 17)
    best_f1 = -1.0
    best_th = 0.5
    for th in thresholds:
        preds = (y_proba >= th).astype(int)
        f1 = f1_score(y_true, preds)
        if f1 > best_f1:
            best_f1 = f1
            best_th = float(th)
    return best_th


def evaluate_model(
    model: RandomForestClassifier, X: pd.DataFrame, y: pd.Series, threshold: float
) -> Dict[str, float]:
    proba = model.predict_proba(X)[:, 1]
    preds = (proba >= threshold).astype(int)
    return {
        "precision": precision_score(y, preds, zero_division=0),
        "recall": recall_score(y, preds, zero_division=0),
        "f1_score": f1_score(y, preds, zero_division=0),
        "accuracy": accuracy_score(y, preds),
        "roc_auc": roc_auc_score(y, proba),
    }


def save_artifacts(model, threshold: float, metrics: Dict[str, float]) -> None:
    DEFAULT_MODEL_PATH.parent.mkdir(parents=True, exist_ok=True)
    DEFAULT_METRICS_PATH.parent.mkdir(parents=True, exist_ok=True)

    joblib.dump(model, DEFAULT_MODEL_PATH)

    with open(DEFAULT_THRESHOLD_PATH, "w", encoding="utf-8") as f:
        json.dump({"optimal_threshold": threshold}, f, indent=2)

    with open(DEFAULT_METRICS_PATH, "w", encoding="utf-8") as f:
        json.dump(metrics, f, indent=2)


def main() -> None:
    parser = argparse.ArgumentParser(description="Train fraud detection model (DVP-PRO).")
    parser.add_argument(
        "--train-path",
        default="data/processed/train_clean.parquet/part.0.parquet",
        help="Ruta al parquet de entrenamiento (parquet o carpeta).",
    )
    parser.add_argument(
        "--val-path",
        default="data/processed/validation_clean.parquet",
        help="Ruta al parquet de validación (parquet o carpeta).",
    )
    parser.add_argument(
        "--metadata-path",
        default=str(DEFAULT_METADATA_PATH),
        help="Ruta al metadata JSON con feature_columns.",
    )
    parser.add_argument(
        "--n-estimators",
        type=int,
        default=200,
        help="Número de árboles para RandomForest.",
    )
    args = parser.parse_args()

    metadata = load_metadata(Path(args.metadata_path))
    feature_cols = metadata["feature_info"]["feature_columns"]

    train_df, val_df = load_dataset(Path(args.train_path), Path(args.val_path))
    X_train, y_train = get_feature_target(train_df, feature_cols)
    X_val, y_val = get_feature_target(val_df, feature_cols)

    # Si el parquet de validación es un folder, tomar muestra rápida
    if len(X_val) == 0:
        # fallback a split interno
        X_train, X_val, y_train, y_val = train_test_split(
            X_train, y_train, test_size=0.2, random_state=42, stratify=y_train
        )

    model = fit_model(X_train, y_train, n_estimators=args.n_estimators)
    val_proba = model.predict_proba(X_val)[:, 1]
    best_threshold = find_best_threshold(y_val.values, val_proba)
    metrics = evaluate_model(model, X_val, y_val, threshold=best_threshold)

    save_artifacts(model, threshold=best_threshold, metrics=metrics)

    print("✅ Modelo entrenado y artefactos guardados")
    print(f"   • Modelo: {DEFAULT_MODEL_PATH}")
    print(f"   • Threshold óptimo: {best_threshold:.3f}")
    print(f"   • Métricas val: {metrics}")


if __name__ == "__main__":
    main()

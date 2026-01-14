"""
predict.py - Inference CLI para el modelo de fraude
===================================================
Carga el modelo entrenado y genera predicciones para un CSV/Parquet.

Autor: Ing. Daniel Varela Perez
Email: bedaniele0@gmail.com
Tel: +52 55 4189 3428
Metodología: DVP-PRO
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Optional

import joblib
import pandas as pd

DEFAULT_MODEL_PATH = Path("models/improved_recall_threshold_model.pkl")
DEFAULT_THRESHOLD_PATH = Path("models/threshold_config.json")


def load_threshold(path: Path) -> float:
    if not path.exists():
        return 0.5
    with open(path, "r", encoding="utf-8") as f:
        return float(json.load(f).get("optimal_threshold", 0.5))


def load_data(path: Path) -> pd.DataFrame:
    if path.suffix.lower() == ".csv":
        return pd.read_csv(path)
    return pd.read_parquet(path)


def main() -> None:
    parser = argparse.ArgumentParser(description="Ejecuta inferencia batch con el modelo de fraude.")
    parser.add_argument(
        "--input-path",
        required=True,
        help="Ruta a CSV o Parquet con las transacciones a puntuar.",
    )
    parser.add_argument(
        "--output-path",
        default="reports/predictions/predicciones.csv",
        help="Ruta de salida CSV con predicciones.",
    )
    args = parser.parse_args()

    model = joblib.load(DEFAULT_MODEL_PATH)
    threshold = load_threshold(DEFAULT_THRESHOLD_PATH)

    df = load_data(Path(args.input_path))
    if "Class" in df.columns:
        df = df.drop(columns=["Class"])

    # Alinear columnas
    if hasattr(model, "feature_names_in_"):
        missing = [c for c in model.feature_names_in_ if c not in df.columns]
        if missing:
            raise ValueError(f"Faltan columnas requeridas: {missing}")
        df = df[model.feature_names_in_]

    proba = model.predict_proba(df)[:, 1]
    preds = (proba >= threshold).astype(int)

    out = df.copy()
    out["fraud_probability"] = proba
    out["is_fraud"] = preds

    output_path = Path(args.output_path)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    out.to_csv(output_path, index=False)

    print(f"✅ Predicciones generadas en {output_path}")
    print(f"   Threshold usado: {threshold:.3f}")


if __name__ == "__main__":
    main()

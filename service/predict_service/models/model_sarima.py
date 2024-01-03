import pandas as pd
import util
from statsmodels.tsa.statespace.sarimax import SARIMAX
from flask import request

def prepare_model(df: pd.DataFrame):
  df = df.sort_values(by="fact_date")
  df.index = pd.to_datetime(df["fact_date"])
  
  min_date, max_date = df.index.min(), df.index.max()
  idx = pd.date_range(min_date, max_date)
  df = df.reindex(idx)

  df.index = pd.DatetimeIndex(df.index).to_period('D')
  df = df.drop(columns="fact_date")

  min_val = df["fact_value"].min()
  max_val = df["fact_value"].max()
  mean_val = df["fact_value"].mean()

  df["fact_value"] = (df["fact_value"] - mean_val) / (max_val - min_val)

  (X, y) = df.drop(columns="fact_value"), df["fact_value"]

  ARMAmodel = SARIMAX(y, order = (6, 2, 2))

  return {
      "model": ARMAmodel.fit(),
      "orig_min": min_val,
      "orig_max": max_val,
      "orig_mean": mean_val 
  }

def predict(df: pd.DataFrame, predict_begin, predict_end) -> str:
  regressor = prepare_model(df)

  model = regressor["model"]

  res = model.predict(start=predict_begin, end=predict_end)
  res = res * (regressor["orig_max"] - regressor["orig_min"]) + regressor["orig_mean"]
  res = res.reset_index()
  res.rename(columns={"index": "fact_date", "predicted_mean": "fact_value"}, inplace=True)
  res["fact_date"] = res["fact_date"].dt.strftime('%d.%m.%Y')

  return res.to_json(orient="records", default_handler=str)
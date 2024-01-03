from prophet import Prophet
import pandas as pd
import const

def predict(df: pd.DataFrame, predict_type) -> str:
  df.rename(columns={'fact_date': 'ds', 'fact_value': 'y'}, inplace=True)
  df['ds'] = pd.to_datetime(df['ds'])

  df.sort_values(by='ds', inplace=True)

  date_max = df['ds'].max()
  periods = 366

  if const.PREDICT_TYPE_WEEK == predict_type:
    periods = 7
  elif const.PREDICT_TYPE_MONTH == predict_type:
    periods = 31
  elif const.PREDICT_TYPE_QUARTER == predict_type:
    periods = 93
  else:
    periods = 366

  date_max = date_max - pd.to_timedelta('1 days')

  m = Prophet(interval_width=0.95)
  m.add_country_holidays(country_name='UZ')
  m.fit(df[df['ds'] <= date_max])

  future = m.make_future_dataframe(periods=periods,)

  forecast = m.predict(future)
  forecast = forecast[forecast['ds'] > date_max][['ds', 'yhat']]

  forecast.rename(columns={"ds": "fact_date", "yhat": "fact_value"}, inplace=True)

  return forecast.to_json(orient="records", default_handler=str, date_format='epoch')


  

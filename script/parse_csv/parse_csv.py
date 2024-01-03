import pandas as pd

file_path = './tracks.csv'

df = pd.read_csv(file_path, header=1)

df = df[df['VALID_ROW'] == True]

df.to_csv('tracks_filtered.csv', index=False)
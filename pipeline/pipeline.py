import sys
import pandas as pd

print("arguments", sys.argv)

day = int(sys.argv[1])
print(f"Running pipeline for day {day}")

df = pd.DataFrame({"Item": [1, 2], "Price": [3, 4]})
print(df.head())

df.to_parquet(f"output_day_{sys.argv[1]}.parquet")

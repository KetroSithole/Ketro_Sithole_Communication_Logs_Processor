import pandas as pd
import numpy as np
from dateutil import parser

# Load CSV
df = pd.read_csv("messy_logs.csv")

# --- Normalisation ---
# Lowercase 'Channel' and 'Status'
df['Channel'] = df['Channel'].str.lower()
df['Status'] = df['Status'].str.lower()

# Normalize Timestamp to ISO format
def normalize_timestamp(ts):
    try:
        return pd.to_datetime(parser.parse(str(ts)), errors='raise').strftime('%Y-%m-%d %H:%M:%S')
    except Exception:
        return np.nan

df['Timestamp'] = df['Timestamp'].apply(normalize_timestamp)

# --- Validation ---
# Drop rows with missing or invalid CustomerID
df = df[df['CustomerID'].notnull()]

# Drop rows with malformed timestamps
df = df[df['Timestamp'].notnull()]

# --- Handling Missing Durations ---
def clean_duration(val):
    try:
        return int(float(val))
    except:
        return 0

df['Duration'] = df['Duration'].apply(clean_duration)

# Final cleaned DataFrame
print(df)
# Save cleaned DataFrame to new CSV
df.to_csv("cleaned_logs.csv", index=False)

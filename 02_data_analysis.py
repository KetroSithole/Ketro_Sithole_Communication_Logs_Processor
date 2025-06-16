import pandas as pd
import json

# Load cleaned data
df = pd.read_csv("cleaned_logs.csv")

# Total valid rows
total_valid_rows = len(df)

# Count per channel
count_per_channel = df['Channel'].value_counts().to_dict()

# Average duration per channel
avg_duration_per_channel = df.groupby('Channel')['Duration'].mean().round(2).to_dict()

# Outbound success metrics per channel
outbound = df[df['Direction'].str.lower() == 'outbound']
success_status = ['delivered', 'sent', 'answered']

def compute_success(group):
    total = len(group)
    success = group['Status'].isin(success_status).sum()
    unsuccessful = total - success
    rate = round((success / total) * 100, 0) if total > 0 else 0
    return pd.Series({
        'Total_Outbound': total,
        'Successful_Outbound': int(success),
        'Unsuccessful_Outbound': int(unsuccessful),
        'Success_Rate_Percent': int(rate)
    })

# Use include_groups=False to avoid the deprecation warning
outbound_success_df = outbound.groupby('Channel').apply(
    compute_success, include_groups=False
).reset_index()

# Convert to dictionary
outbound_success = outbound_success_df.set_index('Channel').to_dict(orient='index')

# Combine all analysis
analysis = {
    "Total_Valid_Rows": total_valid_rows,
    "Count_Per_Channel": count_per_channel,
    "Avg_Duration_Per_Channel": avg_duration_per_channel,
    "Outbound_Channel_Success": outbound_success
}

# Save to JSON
with open("summary_report.json", "w") as f:
    json.dump(analysis, f, indent=4)

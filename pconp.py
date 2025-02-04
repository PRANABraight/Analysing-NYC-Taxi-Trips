import pandas as pd
import numpy as np


try:
    # Load your data
    df = pd.read_csv("converted.csv")

    # Convert pickup datetime to datetime objects (handle potential errors)
    try:
        df['tpep_pickup_datetime'] = pd.to_datetime(df['tpep_pickup_datetime'])
    except KeyError:
        print("Error: 'tpep_pickup_datetime' column not found. Check your data.")
        exit()
    except ValueError:
        print("Error: Could not parse 'tpep_pickup_datetime'. Check the format.")
        exit()

    # Extract date and hour
    df['pickup_date'] = df['tpep_pickup_datetime'].dt.date
    df['pickup_hour'] = df['tpep_pickup_datetime'].dt.hour

    sampled_df = pd.DataFrame()

    # Get the start and end dates of your data
    start_date = df['pickup_date'].min()
    end_date = df['pickup_date'].max()

    # Generate all dates within the range
    all_dates = pd.date_range(start=start_date, end=end_date).date

    # Iterate through all dates and hours
    for date in all_dates:
        for hour in range(24):
            hour_df = df[(df['pickup_date'] == date) & (df['pickup_hour'] == hour)]
            hour_trips = len(hour_df)

            if hour_trips > 0:
                # Sample at least one trip
                sample_size = min(1, hour_trips) #Sample minimum 1 and max all
                sampled_hour_df = hour_df.sample(n=sample_size, replace=False, random_state=42)
                sampled_df = pd.concat([sampled_df, sampled_hour_df])

    # Reset index
    sampled_df = sampled_df.reset_index(drop=True)

    print(f"Number of rows in original data: {len(df)}")
    print(f"Number of rows in sampled data: {len(sampled_df)}")
    print("First few rows of the sampled data:")
    print(sampled_df.head())

    # Save the sampled data
    sampled_df.to_csv("test.csv", index=False)
    print("Sampled data saved to test.csv")

except FileNotFoundError:
    print("Error: 'your_taxi_data.csv' not found. Check the file path.")
except Exception as e:
    print(f"An unexpected error occurred: {e}")
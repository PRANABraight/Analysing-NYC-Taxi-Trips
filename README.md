# Analyzing NYC Taxi Trips

## Project Overview
This project analyzes New York City taxi trip data to uncover patterns in urban mobility, focusing on trip patterns, fares, and passenger behavior. The analysis provides insights into temporal patterns, geographical distributions, and economic aspects of taxi services in NYC.

## Features
- Data preprocessing and conversion (Parquet to CSV)
- Comprehensive statistical analysis
- Interactive visualizations
- Time-series analysis of trip patterns
- Geographical distribution analysis
- Fare and payment analysis


## Prerequisites
- Python 3.7+
- R 4.0+
- Required Python packages:
  - pandas
  - pyarrow
  - numpy
- Required R packages:
  - ggplot2
  - dplyr
  - lubridate

## Setup
1. Clone the repository
2. Install Python dependencies:
   ```bash
   pip install pandas pyarrow numpy
   ```
3. Install R packages:
   ```R
   install.packages(c("ggplot2", "dplyr", "lubridate"))
   ```

## Data Processing Pipeline
1. **Convert Parquet to CSV**
   ```bash
   python pconvertcsv.py
   ```

2. **Process and Sample Data**
   ```bash
   python pconp.py
   ```

3. **Run Statistical Analysis**
   ```R
   source("rTest.R")
   source("rTest2222.R")
   ```

## Analysis Components
- **Trip Distance Analysis**
  - Distribution patterns
  - Average distances by time period
  
- **Fare Analysis**
  - Pricing patterns
  - Time-based variations
  - Payment method distribution

- **Temporal Analysis**
  - Hourly patterns
  - Daily trends
  - Peak hour identification

- **Geographical Analysis**
  - Pickup hotspots
  - Drop-off distributions
  - Zone-based analysis

## Input Data
The analysis uses NYC yellow taxi trip data in Parquet format:
- Primary input file: `yellow_tripdata_2024-09.parquet`
- Data fields include:
  - Pickup/dropoff times
  - Trip distances
  - Fare amounts
  - Payment types
  - Passenger counts

## Output Files
- `converted.csv`: Converted the parquet file to csv for easy handling of datas
- `hourly_taxi_stats.csv`: Aggregated hourly statistics
- `sampled_taxi_data.csv`: Sampled subset for quick analysis
- `test2.csv`: Added week-days for more in-depth analysis  

## Contributing
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License
This project is licensed under the MIT License - see the LICENSE file for details.

PS: File imports may not match in the programs. File has been structured after all the analysis and work was done.

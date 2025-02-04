library(dplyr)
library(lubridate)
library(ggplot2)


 # Load your data
  df <- read.csv("test2.csv")
  
  # Convert pickup datetime
  df$tpep_pickup_datetime <- ymd_hms(df$tpep_pickup_datetime)
  
 
  
  # Basic Summary
  print("Basic Summary:")
  print(summary(df))
  
  # More Detailed Descriptive Statistics
  
  
  # Numerical Columns
  numerical_cols <- c("trip_distance", "fare_amount", "total_amount", "passenger_count") # Add more as needed
  for (col in numerical_cols) {
    if (col %in% names(df)) {
      print(paste("n", col, "Statistics:"))
      print(paste("Mean", col, ":", mean(df[[col]], na.rm = TRUE)))
      print(paste("Median", col, ":", median(df[[col]], na.rm = TRUE)))
      print(paste("Standard Deviation of", col, ":", sd(df[[col]], na.rm = TRUE)))
      print(paste("Range of", col, ":", paste(range(df[[col]], na.rm=TRUE), collapse = " - ")))
      print(paste("Interquartile Range (IQR) of", col, ":", IQR(df[[col]], na.rm = TRUE)))
      print("Quantiles")
      print(quantile(df[[col]], probs = c(0.05,0.25, 0.5, 0.75,0.95), na.rm=TRUE))
    }
  }
  
  # Categorical Columns
  categorical_cols <- c("VendorID", "payment_type") # Add more as needed
  for (col in categorical_cols) {
    if (col %in% names(df)) {
      print(paste( col, "Frequencies:"))
      print(table(df[[col]]))
      print("Proportions")
      print(prop.table(table(df[[col]])))
    }
  }
  
  # Combined Statistics (Example: Average Fare Amount by Hour of Day)
  if ("fare_amount" %in% names(df) & "pickup_hour" %in% names(df)){
    print("Average Fare Amount by Hour of Day:")
    print(aggregate(fare_amount ~ pickup_hour, data = df, FUN = mean, na.rm=TRUE))
  }
  
  
  #Checking for missing values
  print("Missing Values per column")
  print(colSums(is.na(df)))
  
  #Data Type of each column
  print("Data Type of each column")
  print(sapply(df, class))
  
  # Number of rows and columns
  print(paste("Number of rows:", nrow(df)))
  print(paste("Number of columns:", ncol(df)))
  
  
#########
  
  df <- df %>%
    mutate(
      pickup_date = as.Date(tpep_pickup_datetime, format = "%d-%m-%Y")
    )
    
  View(df)
  
  # --- Data Visualization ---
  print("Data Visualizations:")
  
  # 1. Histogram of Trip Distance
  hist(df$trip_distance, main = "Histogram of Trip Distance", xlab = "Trip Distance (miles)", na.rm = TRUE, col = rainbow(30))
  #The histogram of trip distances is heavily right-skewed, indicating that most trips are short (less than 5 miles), with a long tail of less frequent, longer trips extending beyond 15 miles.
  
  # 2. Boxplot of Fare Amount by Hour of Day
  boxplot(fare_amount ~ factor(pickup_hour), data = df, main = "Fare Amount by Hour", xlab = "Hour", ylab = "Fare Amount", na.rm = TRUE, col = rainbow(24))
  #Fare amounts exhibit relatively consistent medians and interquartile ranges across most hours, suggesting similar typical fare values throughout the day, but there's increased variability and more frequent outliers during certain periods, particularly around midday (hours 12-16) and some early morning hours.
  
  # 3. Scatterplot of Trip Distance vs. Fare Amount with color by payment type
  plot(df$trip_distance, df$fare_amount, main = "Distance vs. Fare", xlab = "Distance", ylab = "Fare", col = factor(df$payment_type), na.rm = TRUE)
  
  # 4. Bar Chart of Vendor ID
  barplot(table(df$VendorID), main = "Vendor Frequencies", xlab = "Vendor", ylab = "Frequency", col = rainbow(nlevels(factor(df$VendorID))))
  # fare generally increases with distance. Additionally, the presence of outliers, especially at shorter distances, suggests other factors beyond distance influence fare pricing.
  
  # 5. Payment Type by Day of Week
  ggplot(df, aes(x = factor(day_of_week), fill = factor(payment_type))) +
    geom_bar(position = "stack") +
    labs(title = "Payment Type by Day of Week", x = "Day of Week", y = "Number of Trips", fill = "Payment Type") +
    theme_bw() +
    scale_fill_brewer(palette = "Set3")
  #Credit card payments are the dominant payment method across all days of the week, though cash payments show a slight increase on weekends (Friday and Saturday), while "no charge" and "dispute" transactions remain consistently low throughout the week.
  
  # 6. Boxplot of Trip Distance by Day of the Week
  boxplot(trip_distance ~ day_of_week, data = df, main = "Trip Distance by Day of Week", xlab = "Day of Week", ylab = "Trip Distance", na.rm = TRUE, col = rainbow(7))
  #Trip distances exhibit similar medians across all days of the week, but weekends (Friday, Saturday, and Sunday) show increased variability and a higher frequency of longer trips (outliers) compared to weekdays, suggesting a wider range of trip lengths on weekends.
  
  # 7. Pair plot for numerical variables
  numerical_cols <- c("trip_distance", "fare_amount", "total_amount", "passenger_count")
  numerical_data <- df[, numerical_cols[numerical_cols %in% names(df)]]
  if (ncol(numerical_data) >= 2) {
    pairs(numerical_data, main = "Pairplot of Numerical Variables", col = "lightblue")
  }
  #1. Trip Distance and Fare Amount: A strong positive correlation is evident. As trip distance increases, fare amount generally increases as well.
  
  #2. Total Amount and Fare Amount: A very strong positive correlation exists. This suggests that total_amount is highly influenced by fare_amount.
  
  #3. Passenger Count and Other Variables: Passenger count shows weaker relationships with other variables. It is indicative that passenger count is independent of other variables.
  
  # 8. Scatterplot of Trip Distance vs. Fare Amount, colored by Vendor
  ggplot(df, aes(x = trip_distance, y = fare_amount, color = as.factor(VendorID))) +
    geom_point(alpha = 0.5) +
    labs(title = "Trip Distance vs. Fare Amount (Colored by Vendor)", x = "Trip Distance", y = "Fare Amount", color = "Vendor ID") +
    theme_bw() +
    scale_color_brewer(palette = "Set1")
  
  # 9. Violin plot for Trip Distance by Day of the Week
  ggplot(df, aes(x = day_of_week, y = trip_distance, fill = day_of_week)) +
    geom_violin(alpha = 0.7) +
    labs(title = "Trip Distance by Day of Week", x = "Day of Week", y = "Trip Distance", fill = "Day of Week") +
    theme_bw() +
    scale_fill_brewer(palette = "Set2")
  #The shape and spread of the distributions vary slightly across the week.
  ##Weekends (Fri, Sat): The distributions are wider, suggesting more variability in trip distances on weekends. There might be a larger proportion of longer trips on these days.
  ##Weekdays (Mon-Thu): The distributions are more concentrated around the median, indicating less variability in trip distances during weekdays. Trips are likely to be shorter and more consistent in length.
  
  # 10. Boxplot of Tip Amount by Day of the Week
  ggplot(df, aes(x = day_of_week, y = tip_amount)) +
    geom_boxplot(fill = "lightgreen", color = "black") +
    labs(title = "Tip Amount by Day of Week", x = "Day of Week", y = "Tip Amount") +
    theme_bw()
  #Tip amounts show consistent medians and interquartile ranges across all days of the week, however, the presence of numerous outliers, especially on weekends, suggests that significantly higher tips occur sporadically throughout the week, with a slightly higher likelihood on weekends.
  
  # 11. Boxplot of Total Amount (including taxes) by Day of the Week
  ggplot(df, aes(x = day_of_week, y = total_amount)) +
    geom_boxplot(fill = "lightyellow", color = "black") +
    labs(title = "Total Amount (including taxes) by Day of Week", x = "Day of Week", y = "Total Amount") +
    theme_bw()
  #Total transaction amounts maintain a consistent median and interquartile range across all days of the week, however, outliers, representing unusually high or low transaction amounts, are present on all days, suggesting consistent sporadic occurrences of atypical transactions.
  
  # 12. Bar Plot: Average Total Amount by Hour
  hourly_avg <- aggregate(total_amount ~ pickup_hour, data = df, mean)
  ggplot(hourly_avg, aes(x = factor(pickup_hour), y = total_amount)) +
    geom_bar(stat = "identity", fill = "steelblue") +
    labs(title = "Average Total Amount by Hour",
         x = "Pickup Hour",
         y = "Average Total Amount") +
    theme_minimal()
  #Average total transaction amounts fluctuate throughout the day, with notable peaks around midday (hour 13) and late afternoon/early evening (hours 17-19), and troughs in the early morning hours (roughly 3-5) and mid-morning (around 9-10), indicating variations in demand and/or trip characteristics across different times of day.
  
  # 13. Pie Chart: Contribution of Each Day of the Week to Total Revenue
  daily_revenue <- aggregate(total_amount ~ day_of_week, data = df, sum)
  pie(daily_revenue$total_amount, 
      labels = daily_revenue$day_of_week, 
      col = rainbow(length(daily_revenue$day_of_week)), 
      main = "Weekly Contribution to Total Revenue")
  #The pie chart shows the weekly contribution to total revenue, revealing that revenue is distributed relatively evenly across the days of the week, with perhaps slightly higher contributions from Friday and Saturday, and slightly lower contributions from Sunday and Wednesday.
  
  # 14. Pie Chart: Contribution of Each Hour to Total Revenue
  hourly_revenue <- aggregate(total_amount ~ pickup_hour, data = df, sum)
  pie(hourly_revenue$total_amount, 
      labels = paste0(hourly_revenue$pickup_hour), 
      col = rainbow(length(hourly_revenue$pickup_hour)), 
      main = "Hourly Contribution to Total Revenue")
  #Revenue generation varies throughout the day, with peak contributions observed in the afternoon/early evening hours (roughly 13:00 to 19:00, or 1 PM to 7 PM), and lower contributions during the night and early morning hours.
  
  # 15. Bubble Chart: Trip Distance vs Fare Amount by Day
  ggplot(df, aes(x = trip_distance, y = fare_amount, size = total_amount, color = day_of_week)) +
    geom_point(alpha = 0.6) +
    labs(title = "Trip Distance vs Fare Amount by Day",
         x = "Trip Distance",
         y = "Fare Amount",
         size = "Total Amount",
         color = "Day of Week") +
    theme_minimal()
  #Positive Correlation: The overall positive relationship between trip distance and fare amount, as seen in previous plots, is maintained across all days of the week. Longer trips generally cost more.
  #Day-of-Week Variation: While the general trend holds, there's no strong visual evidence suggesting that specific days of the week consistently have higher or lower fares for a given distance. 
  #Total Amount Influence: The varying bubble sizes, representing total amount, suggest that higher total amounts are associated with longer trips (larger bubbles tend to appear towards the right of the plot). This aligns with the expectation that longer trips result in higher fares and thus higher total amounts. There are some exceptions, which are worth further investigation.
  #Outliers: There are some outliers present, particularly with unusually low fares for given distances or unusual total amounts.
  
  # 16. Pie Chart: Proportion of Payment Types
  pie(table(df$payment_type), 
      labels = c("Credit Card", "Cash", "No charge","Dispute"), 
      col = rainbow(length(table(df$payment_type))), 
      main = "Proportion of Payment Types")
  #Credit card is the overwhelmingly dominant method, representing a large majority of transactions. Cash is the next most common, but its proportion is significantly smaller. Payment types no charge and dispute represent only very small fractions of the total transactions.
  
  # 17. Bubble Chart: Passenger Count vs Total Amount by Hour and Week
  ggplot(df, aes(x = pickup_hour, y = passenger_count, size = total_amount, color = day_of_week)) +
    geom_point(alpha = 0.7) +
    labs(
      title = "Passenger Count vs Total Amount by Hour and Week",
      x = "Pickup Hour",
      y = "Passenger Count",
      size = "Total Amount",
      color = "Day of the Week"
    ) +
    scale_color_brewer(palette = "Set3") + 
    theme_minimal()
  #Passenger Count and Total Amount: There's no clear linear relationship between passenger count and total amount. While larger bubbles (higher total amounts) appear across different passenger counts, the bubble size doesn't consistently increase with passenger count. This suggests other factors (like distance) have a greater influence on the total amount.
  #Pickup Hour and Total Amount: Higher total amounts (larger bubbles) appear to be somewhat more common during certain hours, particularly in the afternoon/evening (roughly 12-20), but this is not a strict trend.
  #Day of the Week: The different colors representing days of the week holds no strong day-of-week effect on the relationship between passenger count and total amount within each hour.
  
  # 18. Bubble Chart: Congestion Surcharge by Day and Hour
  ggplot(df, aes(x = pickup_hour, y = day_of_week, size = congestion_surcharge, color = total_amount)) +
    geom_point(alpha = 0.7) +
    labs(
      title = "Congestion Surcharge by Day and Hour",
      x = "Pickup Hour",
      y = "Day of Week",
      size = "Congestion Surcharge",
      color = "Total Amount"
    ) +
    scale_color_gradient(low = "green", high = "red") +
    theme_minimal()
  #Congestion Surcharge Pattern: Congestion surcharges (represented by bubble size) are generally small or non-existent (most bubbles are small). Larger surcharges (larger bubbles) appear sporadically, with some concentration during typical commuting hours (7-9 AM and 4-6 PM) on weekdays (Monday-Friday), particularly on Tuesday and Thursday. This aligns with the expected pattern of congestion pricing being applied during peak traffic times.
  #Total Amount and Surcharge: There's no clear, direct correlation between total amount (bubble color) and congestion surcharge (bubble size). Both large and small total amounts can occur with or without a congestion surcharge, indicating that the surcharge is applied independently of the total fare amount, based primarily on time and day.
  #Weekend Surcharges: Surcharges are less frequent and less pronounced on weekends (Saturday and Sunday), consistent with reduced traffic congestion during those times.
  
  
  
  #####
  #Interpretation after Data Visualisation:
  
  #Most trips are relatively short, as evidenced by the right-skewed trip distance distribution. Trip distances show greater variability on weekends, with more long trips occurring.
  #Fare amounts are strongly positively correlated with trip distance, but other factors also influence pricing, as evidenced by outliers. While fare amounts are generally consistent throughout the day, variability increases around midday and early morning.
  #Credit cards are the dominant payment method, with a slight increase in cash usage on weekends. "No charge" and "dispute" transactions are infrequent.
  #Peak demand and revenue occur during the afternoon/early evening hours (1 PM to 7 PM). While total revenue is distributed relatively evenly across the week, average total amounts are slightly higher mid-week. Congestion surcharges are primarily applied during weekday commuting hours.
  #Passenger count does not appear to be a major driver of total amount.
  #There are minor differences in fare amounts between vendors, especially for longer distances.
# Load necessary libraries
library(ggplot2)
library(dplyr)

# Load the dataset
data <- read.csv("form_responses.csv")


# Rename the columns
colnames(data) <- c("Time","Name","RollNumber","CGPA","Avg Attendance", "Highschool %", "Study Hours/ Week","Exercise Hours/ Week","Sleep Hours/ Day")
# Confirm the updated column names
colnames(data)

# Drop the first two columns
data <- data[, -c(1, 2)]

# Add a new column for Batch based on the first two digits of the RollNumber
data$Batch <- substr(data$RollNumber, 1, 2)
data$Batch <- as.numeric(data$Batch)

#Drop RollNumber
data <- data[, -1]

# Add a new column for MeanAttendance based on the average of the intervals in Avg Attendance
data$MeanAttendance <- sapply(data$`Avg Attendance`, function(interval) {
  # Check if the interval is NA or empty
  if (is.na(interval) || interval == "") {
    return(NA)  # Assign NA for missing or empty values
  }
  
  # Remove the '%' character and split the interval by '-'
  interval_cleaned <- gsub("%", "", interval)
  bounds <- as.numeric(unlist(strsplit(interval_cleaned, "-")))
  
  # If bounds are numeric and valid, calculate the mean
  if (length(bounds) == 2) {
    return(mean(bounds))
  } else if (length(bounds) == 1) {
    return(bounds)  # Handle single numeric values
  } else {
    return(NA)  # Assign NA for unexpected formats
  }
})

# Add a column for debarrment status
data$Debarred <- ifelse(data$MeanAttendance < 80, "Yes", "No")

# Replace NA values in the Debarred column with "Yes"
data$Debarred[is.na(data$Debarred)] <- "Yes"

# Drop Debarred Students
data <- data[data$Debarred == "No", ]

# Confirm the changes
str(data)
head(data)
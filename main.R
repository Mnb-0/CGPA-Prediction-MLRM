# Load necessary libraries
library(ggplot2)
library(dplyr)

# Load the dataset
data <- read.csv("form_responses.csv")

# Rename the columns
colnames(data) <- c(
    "RollNumber", "CGPA", "Avg Attendance",
    "Highschool %", "Study Hours/Week", "Exercise Hours/Week", "Sleep Hours/Day"
)

# Add a new column for Batch based on the first two digits of RollNumber
data$Batch <- substr(data$RollNumber, 1, 2) %>% as.numeric()

# Drop the RollNumber column
data <- data[, -1]

# Calculate MeanAttendance based on intervals in Avg Attendance
data$MeanAttendance <- sapply(data$`Avg Attendance`, function(interval) {
    # Check for missing or empty intervals
    if (is.na(interval) || interval == "") {
        return(NA)
    }

    # Clean the interval by removing '%' and splitting by '-'
    interval_cleaned <- gsub("%", "", interval)
    bounds <- as.numeric(unlist(strsplit(interval_cleaned, "-")))

    # Calculate the mean of the interval bounds
    if (length(bounds) == 2) {
        return(mean(bounds))
    } else if (length(bounds) == 1) {
        return(bounds) # Handle single numeric values
    } else {
        return(NA) # Assign NA for unexpected formats
    }
})

# Drop the Avg Attendance column
data <- data[, -2]

# Add a column for debarrment status
data$Debarred <- ifelse(data$MeanAttendance < 80, "Yes", "No")

# Set NA values in the Debarred column to "Yes"
data$Debarred[is.na(data$Debarred)] <- "Yes"

# Assign MeanAttendance = 75 for rows where Debarred = "Yes"
data$MeanAttendance[data$Debarred == "Yes"] <- 75

# Save the processed dataset to a CSV file
write.csv(data, "processed_data.csv", row.names = FALSE)

# Confirm the file is saved
print("Processed data has been written to 'processed_data.csv'")


#Summary of Stats
summary(data)

# Confirm the changes
str(data) # Check the structure of the dataset
head(data) # Preview the first few rows of the dataset

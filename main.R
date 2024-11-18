# Load necessary libraries
library(ggplot2)
library(dplyr)

# Load the dataset
data <- read.csv("form_responses.csv")


# Rename the columns
colnames(data) <- c("Time","Name","RollNumber","CGPA","Avg Attendance", "Highschool %", "Study Hours/ Week","Exercise Hours/ Week","Sleep Hours/ Day")
# Confirm the updated column names
colnames(data)

# Confirm the changes
str(data)
head(data)
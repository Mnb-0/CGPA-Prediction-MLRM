# Load necessary libraries
library(ggplot2)
library(dplyr)

# Load the dataset from the uploaded file
data <- read.csv("processed_data.csv")

# Summary of Statistics
print(summary(data))

# Confirm the changes in structure and first rows
str(data) # Check the structure of the dataset
head(data) # Preview the first few rows of the dataset

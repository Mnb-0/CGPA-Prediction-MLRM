# Load necessary libraries
library(ggplot2)
library(dplyr)

# Load the dataset
data <- read.csv("form_responses.csv")

# Confirm the changes
str(data)
head(data)
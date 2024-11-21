# Load necessary libraries
library(ggplot2)
library(dplyr)
library(reshape2) # For melt function

# Load the dataset from the uploaded file
data <- read.csv("processed_data.csv")

# Summary of Statistics
print(summary(data))

# Drop the Debarred column
data <- data %>% select(-Debarred)

# Select only numeric columns
numeric_data <- data %>% select_if(is.numeric)

# Reshape data into long format for ggplot
melted_data <- melt(numeric_data)

# Open a PDF device to save the plot
pdf("boxplots_numeric_variables.pdf", width = 10, height = 7)

# Create boxplots
ggplot(melted_data, aes(x = variable, y = value, fill = variable)) +
    geom_boxplot() +
    labs(title = "Boxplots for All Numeric Variables", x = "Variable", y = "Value") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Close the PDF device
dev.off()

# Confirm the PDF was created
print("Boxplots saved to 'boxplots_numeric_variables.pdf'")

# Identify outliers
outliers <- numeric_data %>%
    summarise(across(
        everything(),
        ~ {
            Q1 <- quantile(., 0.25, na.rm = TRUE)
            Q3 <- quantile(., 0.75, na.rm = TRUE)
            IQR <- Q3 - Q1
            sum(. < (Q1 - 1.5 * IQR) | . > (Q3 + 1.5 * IQR)) # Count outliers
        },
        .names = "Outliers_in_{.col}"
    ))

print(outliers)

# Remove outliers
cleaned_data <- numeric_data %>%
    filter(across(
        everything(),
        ~ {
            Q1 <- quantile(., 0.25, na.rm = TRUE)
            Q3 <- quantile(., 0.75, na.rm = TRUE)
            IQR <- Q3 - Q1
            . >= (Q1 - 1.5 * IQR) & . <= (Q3 + 1.5 * IQR)
        }
    ))

# Save cleaned data to a new CSV file
write.csv(cleaned_data, "outliers_removed.csv", row.names = FALSE)

# Confirm the cleaned data was saved
print("Cleaned data saved to 'outliers_removed.csv'")

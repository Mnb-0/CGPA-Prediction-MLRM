# Load necessary libraries
library(ggplot2)
library(dplyr)
library(tidyr)

# Load the dataset
data <- read.csv("dataset.csv")

# Summary of statistics
print(summary(data))

# Select only numeric columns for analysis
numeric_data <- data %>% select(where(is.numeric))

# Reshape data into long format for ggplot
melted_data <- numeric_data %>%
    pivot_longer(cols = everything(), names_to = "variable", values_to = "value")

# Save boxplots as a PDF
pdf("boxplots_numeric_variables.pdf", width = 10, height = 7)

ggplot(melted_data, aes(x = variable, y = value, fill = variable)) +
    geom_boxplot() +
    labs(title = "Boxplots for All Numeric Variables", x = "Variable", y = "Value") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

dev.off()
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
print("Cleaned data saved to 'outliers_removed.csv'")

# Scatter plot for all numeric variables
pdf("scatterplot_numeric_variables.pdf", width = 10, height = 7)

ggplot(melted_data, aes(x = variable, y = value, color = variable)) +
    geom_point() +
    labs(title = "Scatter Plot for All Numeric Variables", x = "Variable", y = "Value") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

dev.off()
print("Scatter plot saved to 'scatterplot_numeric_variables.pdf'")

# Load the cleaned dataset
cleaned_data <- read.csv("outliers_removed.csv")

# Ensure the dependent variable and independent variables are correctly identified
dependent_variable <- "cgpa"
independent_variables <- setdiff(names(cleaned_data), dependent_variable)

# Create the formula for the regression
formula <- as.formula(paste(dependent_variable, "~", paste(independent_variables, collapse = " + ")))

# Fit the multiple linear regression model
model <- lm(formula, data = cleaned_data)

# Summarize the model
model_summary <- summary(model)

# Print the summary to the console
print(model_summary)

# Save the summary to a text file
capture.output(model_summary, file = "mlrm_regression_summary.txt")
print("Regression summary saved to 'mlrm_regression_summary.txt'")

# Check regression assumptions with diagnostic plots
# Open a PDF device to save diagnostic plots
pdf("mlrm_regression_diagnostics.pdf", width = 10, height = 7)

# Plot diagnostic plots
par(mfrow = c(2, 2)) # Arrange plots in a 2x2 grid
plot(model)

# Close the PDF device
dev.off()
print("Regression diagnostic plots saved to 'mlrm_regression_diagnostics.pdf'")

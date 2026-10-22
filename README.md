# CGPA Prediction: Multiple Linear Regression (R)

Predicts a university student's **CGPA** from study habits and academic history, using a multiple linear regression model built in R. The data comes from a survey of FAST-NUCES students (72 responses, all from the 2023 intake).

## Data

The data was collected through a Google Form. Names and roll numbers were dropped during cleaning, so the committed data is anonymized.

| Variable | Description |
|---|---|
| `cgpa` | Current CGPA (target) |
| `highschool` | High-school percentage |
| `studytime` | Study hours per week |
| `sleeptime` | Sleep hours per day |
| `batch` | Intake year, derived from the roll number |
| `meanattendance` | Midpoint of the reported attendance band (e.g. `80-90%` → 85) |

## Pipeline

1. **Cleaning** ([`Unprocessed/clean.R`](Unprocessed/clean.R)): renames the columns, derives `batch` and `meanattendance`, handles missing values, and drops identifying columns.
2. **EDA and outliers** ([`main.R`](main.R)): computes summary statistics, draws boxplots, and removes outliers with the 1.5×IQR rule.
3. **Model**: fits `cgpa ~ highschool + studytime + sleeptime + batch + meanattendance` with `lm()`.
4. **Diagnostics**: draws residuals-vs-fitted, Q-Q, scale-location and leverage plots.

## Results

From [`mlrm_regression_summary.txt`](mlrm_regression_summary.txt), on 72 observations after outlier removal:

| Predictor | Estimate | p-value |
|---|---|---|
| `meanattendance` | 0.0676 | < 2e-16 |
| `studytime` | 0.0349 | 0.0016 |
| `highschool` | 0.0011 | 0.27 |
| `sleeptime` | 0.0021 | 0.27 |

- **Adjusted R² = 0.998**
- **Attendance** is the dominant predictor: each extra percentage point of attendance adds about 0.07 to CGPA. **Study time** is also significant.
- **High-school percentage and sleep** are not significant.
- **`batch`** came out as `NA`. Every respondent is from the 2023 batch, so the variable is constant and perfectly collinear with the intercept.

**Caveat:** an R² this close to 1 on a small, self-reported survey is a warning sign, not a success. It most likely reflects the small sample, a single batch, and attendance being reported in coarse bands. Treat the coefficients as descriptive of this sample, not as a general model.

Plots: [`scatterplot_numeric_variables.pdf`](scatterplot_numeric_variables.pdf) · [`mlrm_regression_diagnostics.pdf`](mlrm_regression_diagnostics.pdf)

## Running

```r
install.packages(c("ggplot2", "dplyr", "tidyr"))
source("main.R")   # reads dataset.csv and writes the summary, cleaned CSV and plot PDFs
```

Open `Stats_Project.Rproj` in RStudio to get the right working directory.

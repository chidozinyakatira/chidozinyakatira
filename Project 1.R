# Load necessary packages
install.packages(c("dplyr", "ggplot2"))

library(ggplot2)
library(dplyr)


# Load the dataset (adjust path if needed)
data <- read.csv("wesavemed_dataset.csv")

# View structure
str(data)
ggplot(data, aes(x = charges)) +
  geom_density(fill = "skyblue", alpha = 0.6) +
  labs(title = "Density of Insurance Premiums", x = "Insurance Premium", y = "Density")
ggplot(data, aes(x = sex, y = charges, fill = sex)) +
  geom_boxplot() +
  labs(title = "Insurance Premiums by Gender", x = "Gender", y = "Insurance Premium") +
  theme_minimal()

ggplot(data, aes(x = region, y = charges, fill = region)) +
  geom_boxplot() +
  labs(title = "Insurance Premiums by Region", x = "Region", y = "Insurance Premium") +
  theme_minimal()

data <- data %>%
  mutate(bmi_category = case_when(
    bmi < 18.5 ~ "Underweight",
    bmi >= 18.5 & bmi < 25 ~ "Healthy",
    bmi >= 25 & bmi < 30 ~ "Overweight",
    bmi >= 30 ~ "Obese"
  ))

# Plot
ggplot(data, aes(x = bmi_category, y = charges, fill = bmi_category)) +
  geom_boxplot() +
  labs(title = "Insurance Premiums by BMI Category", x = "BMI Category", y = "Insurance Premium") +
  theme_minimal()

ggplot(data, aes(x = age, y = charges)) +
  geom_point(alpha = 0.5, color = "darkblue") +
  geom_smooth(method = "lm", se = TRUE, color = "red") +
  labs(title = "Insurance Premium vs Age", x = "Age", y = "Insurance Premium") +
  theme_minimal()

# ANOVA
anova_region <- aov(charges ~ region, data = data)
summary(anova_region)

# Tukey's HSD
tukey_region <- TukeyHSD(anova_region)
tukey_region

anova_gender <- aov(charges ~ sex, data = data)
summary(anova_gender)

tukey_gender <- TukeyHSD(anova_gender)
tukey_gender



anova_smoking <- aov(charges ~ smoker, data = data)
summary(anova_smoking)

tukey_smoking <- TukeyHSD(anova_smoking)
tukey_smoking

# Select relevant variables
cor_data <- data %>%
  select(age, bmi, children, charges)

# Correlation matrix
cor_matrix <- cor(cor_data)
cor_matrix

# Age vs Insurance
cor.test(data$age, data$charges)

# BMI vs Insurance
cor.test(data$bmi, data$charges)

# Children vs Insurance
cor.test(data$children, data$charges)



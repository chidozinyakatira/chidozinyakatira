data <- read.csv("datasets part 2/datasets 2/Q1 and Q2 dataset/online_retail_II.csv")
head(data)
names(data)

cleaned_data <- data[!is.na(data$Country) &
                       data$Country != "" &
                       !is.na(data$Quantity) &
                       data$Quantity > 0,]

cat('Original rows:', nrow(data), "\n")
cat('Cleaned rows:', nrow(cleaned_data), '\n')
cat('removed:', nrow(data) - nrow(cleaned_data), "rows\n")

write.csv(cleaned_data, "online_retail_cleaned.csv", row.names = FALSE)
cat("Cleaned file save successfully!\n")
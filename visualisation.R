cat("\n========================================\n")
cat("Creating Visualization\n")
cat("========================================\n\n")

# Check if results file exists
if (!file.exists("hadoop_sales_by_country.txt")) {
  cat("✗ Error: hadoop_sales_by_country.txt not found!\n")
  cat("  Please run MapReduce job first and download results.\n\n")
  stop()
}

# Read the MapReduce results
cat("Step 1: Reading MapReduce results...\n")
sales_data <- read.table("hadoop_sales_by_country.txt",
                         sep = "\t",
                         col.names = c("Country", "TotalSales"),
                         stringsAsFactors = FALSE)

cat("   Total countries found:", nrow(sales_data), "\n\n")

# Get top 5 countries
top5 <- head(sales_data, 5)

cat("Step 2: Top 5 Countries:\n")
for (i in 1:5) {
  cat(sprintf("   %d. %-20s £%s\n",
              i,
              top5$Country[i],
              format(round(top5$TotalSales[i], 2), big.mark = ",")))
}
cat("\n")

# Create the visualization
cat("Step 3: Creating bar chart...\n")

png("Top5_Countries_Sales_Chart.png",
    width = 1000,
    height = 700,
    res = 120)

# Set up nice margins
par(mar = c(6, 5, 4, 2))

# Create color palette
colors <- c("#E74C3C", "#3498DB", "#2ECC71", "#F39C12", "#9B59B6")

# Create bar plot
bars <- barplot(top5$TotalSales,
                names.arg = top5$Country,
                main = "Top 5 Countries by Total Revenue\nOnline Retail Analysis (2009-2011)",
                xlab = "",
                ylab = "Total Sales (£)",
                col = colors,
                border = NA,
                las = 2,
                ylim = c(0, max(top5$TotalSales) * 1.15),
                cex.names = 1.1,
                cex.axis = 1.0,
                cex.lab = 1.2,
                cex.main = 1.3)

# Add value labels on bars
text(x = bars,
     y = top5$TotalSales,
     labels = paste0("£", format(round(top5$TotalSales), big.mark = ",")),
     pos = 3,
     cex = 0.95,
     font = 2,
     col = "black")

# Add grid lines for easier reading
grid(nx = NA, ny = NULL, col = "gray80", lty = "dotted")

# Add x-axis label
mtext("Country", side = 1, line = 4.5, cex = 1.2)

# Add box around plot
box()

dev.off()

cat("   Chart saved as: Top5_Countries_Sales_Chart.png\n\n")

cat("========================================\n")
cat("✓ Visualization completed successfully!\n")
cat("========================================\n\n")



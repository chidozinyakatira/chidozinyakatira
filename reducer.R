options(warn = -1)

input_conn <- file("stdin", "r")
country_totals <- c()

while (TRUE) {
  line <- readLines(input_conn, n = 1, warn = FALSE)
  
  if (length(line) == 0) {
    break
  }
  
  if (nchar(trimws(line)) == 0) {
    next
  }
  
  tryCatch({
    parts <- strsplit(line, "\t")[[1]]
    
    if (length(parts) >= 2) {
      country <- trimws(parts[1])
      sales <- as.numeric(trimws(parts[2]))
      
      if (!is.na(sales) && nchar(country) > 0) {
        if (country %in% names(country_totals)) {
          country_totals[country] <- country_totals[country] + sales
        } else {
          country_totals[country] <- sales
        }
      }
    }
  }, error = function(e) {})
}

close(input_conn)

sorted_totals <- sort(country_totals, decreasing = TRUE)

for (country_name in names(sorted_totals)) {
  sales_amount <- format(sorted_totals[country_name], 
                         nsmall = 2, 
                         scientific = FALSE,
                         trim = TRUE)
  cat(country_name, "\t", sales_amount, "\n", sep = "")
}


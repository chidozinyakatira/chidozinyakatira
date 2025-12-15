options(warn = -1)

input_conn <- file("stdin", "r")

while (TRUE) {
  line <- readLines(input_conn, n = 1, warn = FALSE)
  
  if (length(line) == 0) {
    break
  }
  
  if (grepl("Invoice", line, ignore.case = TRUE)) {
    next
  }
  
  if (nchar(trimws(line)) == 0) {
    next
  }
  
  tryCatch({
    line <- gsub('"', '', line)
    fields <- strsplit(line, ",")[[1]]
    
    if (length(fields) >= 8) {
      quantity <- as.numeric(trimws(fields[4]))
      price <- as.numeric(trimws(fields[6]))
      country <- trimws(fields[8])
      
      if (!is.na(quantity) && !is.na(price) && 
          quantity > 0 && price > 0 && 
          nchar(country) > 0) {
        
        sales <- quantity * price
        cat(country, "\t", sales, "\n", sep = "")
      }
    }
  }, error = function(e) {})
}

close(input_conn)
library(dplyr)
library(ggplot2)

library(corrplot)

library(factoextra)

library(cluster)
library(GGally)
library(tibble)

data <- read.csv("Mall_Customers.csv")
head(data)
summary(data)
sum(is.na(data))

hist(data$Age, main="Histogram of Age", xlab="Age", col="Lightblue", border="black")
hist(data$Annual.Income..k.., main="Histogram of Annual Income", xlab="Annual Income" ,col="Lightblue", border="black")
hist(data$Spending.Score..1.100., main="Histogram of Spending Score", xlab="spending score" ,col="Lightblue", border="black")

boxplot(data$Spending.Score..1.100. ~ data$Genre, main="Boxplot of Spendingscore by Gender",
        xlab="Spending Score",
        ylab="Gender",
        col = c("lightblue", "pink"))

numeric_data <- data[sapply(data, is.numeric)]

cor_matrix <- cor(numeric_data, use="complete.obs")
print(cor_matrix)

corrplot(cor_matrix, method="color", type="upper", tl.col="black", tl.srt=45)


clustering_vars <- data %>%
  select(Age, Annual.Income..k.., Spending.Score..1.100.)

scaled_data <- scale(clustering_vars)
summary(scaled_data)

sum(is.na(clustering_vars))

elbow_plot <- fviz_nbclust(scaled_data, kmeans, method ="wss", k.max=10)
print(elbow_plot)

silhouette_plot <- fviz_nbclust(scaled_data, kmeans, method="silhouette", k.max=10)
print(silhouette_plot)

gap_plot <- fviz_nbclust(scaled_data, kmeans, method ="gap_stat", k.max=10, nboot=50)
print(gap_plot)

set.seed(123)
final_kmeans <- kmeans(scaled_data, centers=6, nstart=25)
print(final_kmeans)

cluster_assignments <- final_kmeans$cluster
table(cluster_assignments)

cluster_centers <- final_kmeans$centers
print("Cluster centers (Scaled Data):")
print(cluster_centers)

final_kmeans$withinss

final_kmeans$tot.withinss

data$Cluster <- factor(final_kmeans$cluster)
head(data)
table(data$Cluster)

cluster_summary <- data %>%
  group_by(Cluster) %>%
  summarise(
    Count = n(),
    Avg_Age = round(mean(Age), 1),
    Avg_Income = round(mean(Annual.Income..k..),1),
    Avg_Spending = round(mean(Spending.Score..1.100.),1),
    .groups = 'drop'
  )

print(cluster_summary)

silhouette_scores <- silhouette(final_kmeans$cluster, dist(scaled_data))

avg_silhouette <- mean(silhouette_scores[,3])
cat("Average Silhouette Width:", round(avg_silhouette,3))

fviz_silhouette(silhouette_scores)

ggplot(data, aes(x=Annual.Income..k.., y=Spending.Score..1.100.,color=Cluster))+
  geom_point(size=3, alpha=0.7)+
  labs(title="Customer Segments: Income vs Spending Score",
       x="Annual Income",
       y= "Spending Score",
       color ="Cluster")+
  theme_minimal()+
  theme(plot.title = element_text(hjust=0.5, size=14))
cluster_profiles <- data %>%
  group_by(Cluster) %>%
  summarise(
    Age = mean(Age),
    Income= mean(Annual.Income..k..),
    Spending = mean(Spending.Score..1.100.),
    .groups ='drop'
  ) %>%
  column_to_rownames("Cluster")

cluster_profiles_scaled <- scale(cluster_profiles)

install.packages("pheatmap")
library(pheatmap)
pheatmap(cluster_profiles_scaled,
         main="Cluster Characteristics Heatmap",
         color = colorRampPalette(c("blue", "white", "red"))(100),
         display_numbers = TRUE,
         number_format ="%.2f")

fviz_cluster(final_kmeans,data=scaled_data,
             palette ="Set2",
             geom="point",
             ellipse.type = "convex",
             ggtheme = theme_bw(),
             main = "kmeans CLustering Results")

cluster_names <- c(
  "1" = "Middle Aged ",
   "2" = "High Income Savers",
   "3" = "Premium Young Professionals",
   "4" = "Young Middle Class",
   "5" = "Budget SPenders",
   "6" = " Low income Savers"
)
data$cluster_names <- cluster_names[as.character(data$Cluster)]
tableau_data <- data %>%
  mutate(
    CustomerID = row_number(),
    Annual_Income = Annual.Income..k..,
    Spending_Score = Spending.Score..1.100.
  ) %>%
  select(
    CustomerID,
    Age,
    Annual_Income,
    Spending_Score,
    Genre,
    Cluster,
    cluster_names
  )
head(tableau_data)
head(data)

write.csv(tableau_data, "mall_clustering.csv", row.names = FALSE)

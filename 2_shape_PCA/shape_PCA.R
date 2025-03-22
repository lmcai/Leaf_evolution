# Load necessary libraries
library(ggplot2)
library(factoextra)  # For PCA and clustering visualization
library(cluster)      # For silhouette analysis
library(dplyr)

# Load dataset (replace 'your_data.csv' with actual file path)
data <- read.csv("leaf_dimension_sum_v2.csv")

data <- data[, c("ID", "Solidity_corrected", "Circularity","Ellipticalness_Index","Aspect_ratio_width.length","Species")]

data_numeric = data[,-1]


#############################
#PCA

leaf.pca <- prcomp(data_numeric[, -5],  center = TRUE, scale = TRUE)

# Summary of PCA results (variance explained by each component)
summary(leaf.pca)

# plot
fviz_pca_biplot(leaf.pca, label = "var", ggtheme = theme_minimal())
fviz_pca_biplot(leaf.pca, label = "var", habillage=data_numeric$Species,addEllipses=TRUE, ellipse.level=0.95, ggtheme = theme_minimal())


####################################
#K-meas clustering

# Extract PCA scores for clustering
pca_scores <- leaf.pca$x[, 1:2]  # Use first two principal components

# Determine optimal number of clusters using the Elbow Method
fviz_nbclust(pca_scores, kmeans, method = "wss")
#Best number =3 
# Determine optimal number of clusters using Silhouette Method
fviz_nbclust(pca_scores, kmeans, method = "silhouette")
#Best number =3 

# Set optimal number of clusters (choose k based on plots)
k_optimal <- 3  # Adjust this value based on the Elbow/Silhouette plot

# Perform k-means clustering
set.seed(123)  # Ensure reproducibility
kmeans_result <- kmeans(pca_scores, centers = k_optimal, nstart = 25)

# Add cluster assignments to original data
data$Cluster <- as.factor(kmeans_result$cluster)

# Visualize clusters
fviz_cluster(kmeans_result, data = pca_scores, geom = "point", ellipse.type = "convex", 
             palette = "jco", ggtheme = theme_minimal())

# Print cluster centers
print(kmeans_result$centers)

# Print number of data points per cluster
table(kmeans_result$cluster)

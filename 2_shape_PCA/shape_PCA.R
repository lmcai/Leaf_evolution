# Load necessary libraries
library(ggplot2)
library(factoextra)  # For PCA and clustering visualization
library(cluster)      # For silhouette analysis
library(dplyr)

# Load dataset (replace 'your_data.csv' with actual file path)
data <- read.csv("leaf_dimension_sum_v2.csv")

data_numeric <- data[, c("ID", "Species", "Solidity_corrected", "Circularity","Ellipticalness_Index","Aspect_ratio_width.length","length_bbx_mm","teeth_number")]

data_numeric = data_numeric[,-1]


#############################
#PCA

# log transform teeth number 
data_numeric$teeth_number[which(data_numeric$teeth_number==0)]=1
data_numeric$teeth_number=log(data_numeric$teeth_number)

leaf.pca <- prcomp(data_numeric[, -1],  center = TRUE, scale = TRUE)

# Summary of PCA results (variance explained by each component)
summary(leaf.pca)
#Importance of components:
#                          PC1    PC2    PC3     PC4     PC5    PC6
#Standard deviation     1.5242 1.3232 1.0038 0.76443 0.49348 0.3010
#Proportion of Variance 0.3872 0.2918 0.1679 0.09739 0.04059 0.0151
#Cumulative Proportion  0.3872 0.6790 0.8469 0.94432 0.98490 1.0000

# plot
fviz_pca_biplot(leaf.pca, label = "var", ggtheme = theme_minimal())

# local partial species
data_numeric$Species='x'
data_numeric$Species[2229:2400]=data$Species[2229:2400]
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

# Load necessary libraries
library(cluster)      # For daisy (Gower's distance)
library(factoextra)   # For clustering visualization and silhouette
library(ape)          # For PCoA (Principal Coordinates Analysis)

# --- Load your data ---
# Example: Load a CSV file with mixed trait types
# Assume rows = species/individuals, columns = traits (9 traits)
trait_data <- read.csv("your_trait_data.csv", row.names = 1)

# --- Calculate Gower's distance ---
gower_dist <- daisy(trait_data, metric = "gower")

# --- Principal Coordinates Analysis (PCoA) ---
pcoa_res <- pcoa(as.matrix(gower_dist))

# View eigenvalues (optional)
print(pcoa_res$values)

# Plot first 2 PCoA axes
plot(pcoa_res$vectors[,1:2], main = "PCoA - First 2 Axes", xlab = "PCoA 1", ylab = "PCoA 2", pch = 19)

# --- Determine optimal number of clusters ---
# We'll use Partitioning Around Medoids (PAM) clustering on Gower distances

# Silhouette method to determine best number of clusters (2 to 10)
sil_widths <- numeric(9)
for (k in 2:10) {
  pam_fit <- pam(gower_dist, diss = TRUE, k = k)
  sil_widths[k - 1] <- pam_fit$silinfo$avg.width
}

# Plot silhouette widths
plot(2:10, sil_widths, type = "b", pch = 19,
     xlab = "Number of clusters", ylab = "Average silhouette width",
     main = "Optimal number of clusters")

# Choose optimal k (with highest silhouette)
best_k <- which.max(sil_widths) + 1
cat("Best number of clusters based on silhouette:", best_k, "\n")

# Final clustering
final_pam <- pam(gower_dist, diss = TRUE, k = best_k)

# Add cluster assignment to PCoA plot
fviz_cluster(list(data = pcoa_res$vectors[,1:2], cluster = final_pam$clustering),
             geom = "point", ellipse.type = "convex", 
             main = paste("PAM Clustering (k =", best_k, ") on PCoA"))

# Optional: Save cluster assignments
trait_data$Cluster <- final_pam$clustering
write.csv(trait_data, "trait_data_with_clusters.csv")

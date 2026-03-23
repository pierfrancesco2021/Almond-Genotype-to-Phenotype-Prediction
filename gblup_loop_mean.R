
setwd("~/Library/CloudStorage/OneDrive-UniversitàdegliStudidiBari/PhD Anaconda/almond")
library(rrBLUP)
library(Metrics)

# Initialize lists to store results for each set of 10 folds
pearson_correlations <- numeric(15)
coefficients_of_determination <- numeric(15)
rmses <- numeric(15)

# Loop through each set of 10 folds
for (j in 1:15) {
  all_test_pheno <- numeric()
  all_predictions <- numeric()
  
  # Loop through each fold in the current set of 10 folds
  for (i in 1:10) {
    fold_index <- (j - 1) * 10 + i
    
    # Construct file names
    train_geno_file <- paste0('data/X_train_fold', fold_index, '.csv')
    test_geno_file <- paste0('data/X_test_fold', fold_index, '.csv')
    train_pheno_file <- paste0('data/y_train_fold', fold_index, '.csv')
    test_pheno_file <- paste0('data/y_test_fold', fold_index, '.csv')
    
    # Read data
    X_train <- read.csv(train_geno_file, row.names = 'index')
    X_test <- read.csv(test_geno_file, row.names = 'index')
    y_train <- read.csv(train_pheno_file)['RESA']
    y_test <- read.csv(test_pheno_file)['RESA']
    
    # Convert data to appropriate format
    train_geno <- as.matrix(sapply(X_train, as.numeric))
    train_pheno <- as.numeric(unlist(y_train))
    test_geno <- as.matrix(sapply(X_test, as.numeric))
    test_pheno <- as.numeric(unlist(y_test))
    
    # Compute the genomic relationship matrix G
    G <- A.mat(train_geno)
    
    # Fit G-BLUP model using the genomic relationship matrix G
    gblup_model <- mixed.solve(y = train_pheno, K = G, method = "REML")
    
    # Predict phenotypes for test set
    test_geno_mean <- colMeans(train_geno)
    G_test_train <- tcrossprod(scale(test_geno, center = test_geno_mean, scale = FALSE), 
                               scale(train_geno, center = test_geno_mean, scale = FALSE)) / ncol(train_geno)
    gblup_predictions <- G_test_train %*% gblup_model$u + rep(gblup_model$beta, nrow(test_geno))
    
    # Accumulate true and predicted values
    all_test_pheno <- c(all_test_pheno, test_pheno)
    all_predictions <- c(all_predictions, gblup_predictions)
  }
  
  # Calculate evaluation metrics for the current set of 10 folds
  pearson_correlations[j] <- cor(all_test_pheno, all_predictions)
  
  #calculate RMSE
  rmses[j] <- rmse(all_test_pheno, all_predictions)
  
  # Calculate R^2
  SS_res <- sum((all_test_pheno - all_predictions)^2)
  SS_tot <- sum((all_test_pheno - mean(all_test_pheno))^2)
  coefficients_of_determination[j] <- 1 - (SS_res / SS_tot)
  
}

# Calculate mean and standard deviation for each metric
mean_pearson <- mean(pearson_correlations)
sd_pearson <- sd(pearson_correlations)

mean_r_squared <- mean(coefficients_of_determination)
sd_r_squared <- sd(coefficients_of_determination)

mean_rmse <- mean(rmses)
sd_rmse <- sd(rmses)

# Print results
cat("Pearson Correlation Coefficient: Mean =", mean_pearson, ", SD =", sd_pearson, "\n")
cat("Coefficient of Determination (R²): Mean =", mean_r_squared, ", SD =", sd_r_squared, "\n")
cat("RMSE: Mean =", mean_rmse, ", SD =", sd_rmse, "\n")

#write.csv(coefficients_of_determination, file = "r2_gblup.csv")
#write.csv(pearson_correlations, file = "corr_gblup.csv")
#write.csv(rmses, file = "rmse_gblup.csv")
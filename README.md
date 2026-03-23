# Almond-Genotype-to-Phenotype-Prediction
[![DOI](https://zenodo.org/badge/1029577614.svg)](https://doi.org/10.5281/zenodo.16778479)

![Graphical Abstract](flowchart_high_res_2.png)

## 📄 Paper Information

**Title:** Explainable artificial intelligence for genotype-to-phenotype prediction in plant breeding: a case study with a dataset from an almond germplasm collection 
**Authors:** Pierfrancesco Novielli, Donato Romano, Stefano Pavan, Pasquale Losciale, Anna Maria Stellacci, Domenico Diacono, Roberto Bellotti, Sabina Tangaro  
**Journal:** *Frontiers in Plant Science*, Volume 15 - 2024  
**DOI:** [10.3389/fpls.2024.1434229]([https://doi.org/10.3389/fpls.2024.1434229])  
**Published:** 09 September 9, 2024

<p align="center">
<img src="cover_frontiers.png" alt="Frontiers in Plant Science" width="600"/>
</p>

---

## 🧠 Project Overview

This project implements a Machine Learning (ML) and Explainable AI (XAI) pipeline to predict almond phenotypic traits from genomic data (SNPs). Unlike standard "black-box" models, this framework uses SHAP (SHapley Additive exPlanations) to identify the specific genetic markers (SNPs) that drive the predictions, facilitating more informed plant breeding decisions.

Key Features:
- Genomic Preprocessing: Handling of VCF files and variant filtering using scikit-allel.

- Feature Selection: Dimensionality reduction via Mutual Information (MI) to identify the most relevant SNPs.

- Predictive Modeling: Optimized Random Forest (RF) regression with hyperparameter tuning.


---

## ⚙️ Environment Setup

The analysis was conducted using Python 3.11.

--- 

### Methodology Summary
The workflow implemented in the provided code follows these stages:
- Variant Filtering: SNPs with low variance or high missingness are pruned.
- MI-based Ranking: SNPs are ranked by their Mutual Information score relative to the target trait.
- Model Optimization: RandomizedSearchCV is used to find the best configuration for the Random Forest Regressor.
- Performance Metrics: The model is evaluated using $R^2$, Mean Absolute Error (MAE), and Root Mean Squared Error (RMSE) via Repeated K-Fold Cross-Validation.
- Interpretation: SHAP values are calculated to visualize the impact of specific SNPs on the predicted phenotype.

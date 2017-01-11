# BreastCancerPrediction
Different ML algorithms applied to Breast Cancer dataset to predict whether a tumor is benign or malignant

# Dataset Information:
The dataset consists of the following fields.

## Attribute Information:

1. Sample code number: id number 
2. Clump Thickness: 1 - 10 
3. Uniformity of Cell Size: 1 - 10 
4. Uniformity of Cell Shape: 1 - 10 
5. Marginal Adhesion: 1 - 10 
6. Single Epithelial Cell Size: 1 - 10 
7. Bare Nuclei: 1 - 10 
8. Bland Chromatin: 1 - 10 
9. Normal Nucleoli: 1 - 10 
10. Mitoses: 1 - 10 
11. Class: (2 for benign, 4 for malignant)

There are 699 instances and each containing information on 9 features of the tumor. The last field is the Class field specifying which class the tumor belongs to.

# Approach
The approaches implemented are -

1. a. Instance Selection<br>
   b. Classificatisn using fuzzy rough nearest neighbour classifier

2. a. K-means + C4.5 decision tree classifier

3. a. Feature Selection using Decision Trees<br>
   b. Reduction of features using PCA<br>
   c. NN Classifier 

#Downloading file
#download.file("https://archive.ics.uci.edu/ml/machine-learning-databases/breast-cancer-wisconsin/breast-cancer-wisconsin.data", destfile = "E:/R/test.csv", method="auto")

#Open test.csv and copy paste headers before loading

#Loading data
ata = read.csv("E:/R/Breast Cancer/test.csv")
str(data)

#Separataing out malignant and benign
benign = subset(data, data$Class==2)
str(benign)

malignant = subset(data, data$Class==4)
str(malignant)

malignant$BareNuclei = as.integer(malignant$BareNuclei)
benign$BareNuclei = as.integer(benign$BareNuclei)
str(malignant)
str(benign)

#Cluster malignant into k=2 classes
k = 2
set.seed(20)
KMC = kmeans(malignant[ ,2:10], centers = k, iter.max = 1000)
KMC$cluster


#Assign Clusters
#Using 1 and 2 for malignant and 0 for Benign
malignant$Class = KMC$cluster
benign$Class = 0
str(malignant)
str(benign)

dataProcessed = rbind(malignant, benign)
str(dataProcesseed)

dataProcessed$Id = as.factor(dataProcessed$Id)
dataProcessed$Class = as.factor(dataProcessed$Class)
str(dataProcessed)

library(C50)

dataProcessed <- dataProcessed[sample(nrow(dataProcessed)), ]
X <- dataProcessed[,2:10]
y <- dataProcessed[,11]

model = C50::C5.0(X, y)
summary(model)

Call:
C5.0.default(x = X, y = y)


C5.0 [Release 2.07 GPL Edition]         Mon Jul 25 00:18:47 2016
-------------------------------

Class specified by attribute `outcome'

Read 699 cases (10 attributes) from undefined.data

Decision tree:

UniformityCellSize <= 3:
:...NormalNucleoli <= 2:
:   :...BlandChromatin <= 3: 0 (423/4)
:   :   BlandChromatin > 3:
:   :   :...EpithelialCellSize <= 2: 0 (8)
:   :       EpithelialCellSize > 2: 1 (8/1)
:   NormalNucleoli > 2:
:   :...ClumpThickness > 6: 1 (14/1)
:       ClumpThickness <= 6:
:       :...UniformityCellShape <= 2: 0 (12)
:           UniformityCellShape > 2: 1 (16/4)
UniformityCellSize > 3:
:...NormalNucleoli > 6:
    :...UniformityCellSize > 6: 2 (74/1)
    :   UniformityCellSize <= 6:
    :   :...BareNuclei <= 1: 0 (2)
    :       BareNuclei > 1: 2 (30/6)
    NormalNucleoli <= 6:
    :...UniformityCellSize <= 6:
        :...EpithelialCellSize <= 6:
        :   :...BlandChromatin > 2: 1 (51/4)
        :   :   BlandChromatin <= 2:
        :   :   :...ClumpThickness <= 6: 0 (3)
        :   :       ClumpThickness > 6: 1 (3)
        :   EpithelialCellSize > 6:
        :   :...UniformityCellSize <= 4: 0 (3)
        :       UniformityCellSize > 4:
        :       :...MarginalAdhesion <= 7: 1 (2)
        :           MarginalAdhesion > 7: 2 (3)
        UniformityCellSize > 6:
        :...NormalNucleoli > 2: 2 (27/2)
            NormalNucleoli <= 2:
            :...EpithelialCellSize > 9: 2 (5)
                EpithelialCellSize <= 9:
                :...BareNuclei <= 2: 2 (2)
                    BareNuclei > 2: 1 (13/2)


Evaluation on training data (699 cases):

            Decision Tree   
          ----------------  
          Size      Errors  

            19   25( 3.6%)   <<


           (a)   (b)   (c)    <-classified as
          ----  ----  ----
           447     8     3    (a): class 0
             4    95     6    (b): class 1
                   4   132    (c): class 2


        Attribute usage:

        100.00% UniformityCellSize
        100.00% NormalNucleoli
         70.96% BlandChromatin
         14.45% EpithelialCellSize
          6.87% ClumpThickness
          6.72% BareNuclei
          4.01% UniformityCellShape
          0.72% MarginalAdhesion


Time: 0.0 secs

#Accuracy
            (a)   (b)   (c)    <-classified as
          ----  ----  ----
           447     8     3    (a): class 0
             4    95     6    (b): class 1
                   4   132    (c): class 2

#Collecting malignant
         0       Not 0
0       447       8+3
Not 0    4        95+6+4+132

1 - (8+3+4)/699
97.85
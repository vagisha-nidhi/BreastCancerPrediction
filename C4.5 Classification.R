data = read.csv("E:/R/Breast Cancer/test.csv")
str(data)
data$Class = as.factor(data$Class)
data$Id = as.factor(data$Id)
str(data)
library(C50)

data <- data[sample(nrow(data)), ]
X <- data[,2:10]
y <- data[,11]

model = C50::C5.0(X, y)
summary(model)

Call:
C5.0.default(x = X, y = y)


C5.0 [Release 2.07 GPL Edition]         Mon Jul 25 00:09:52 2016
-------------------------------

Class specified by attribute `outcome'

Read 699 cases (10 attributes) from undefined.data

Decision tree:

UniformityCellSize <= 2:
:...BareNuclei in {?,1,2,3,4,5,9}: 2 (420.8/5)
:   BareNuclei in {10,6,7,8}: 4 (8.2/1.2)
UniformityCellSize > 2:
:...UniformityCellShape > 2: 4 (247/23)
    UniformityCellShape <= 2:
    :...ClumpThickness <= 5: 2 (19/1)
        ClumpThickness > 5: 4 (4)


Evaluation on training data (699 cases):

            Decision Tree   
          ----------------  
          Size      Errors  

             5   30( 4.3%)   <<


           (a)   (b)    <-classified as
          ----  ----
           434    24    (a): class 2 = Benign
             6   235    (b): class 4 = Malignant


        Attribute usage:

        100.00% UniformityCellSize
         59.80% BareNuclei
         38.63% UniformityCellShape
          3.29% ClumpThickness


Time: 0.0 secs

#Accuracy
1 - 30/699
95.7
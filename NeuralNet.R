dat = read.csv("breast_cancer.csv", header = TRUE)
head(dat)
table = dat[,c('ClumpThickness','UniformityCellSize','UniformityCellShape',"MarginalAdhesion",'EpithelialCellSize','BareNuclei','BlandChromatin','NormalNucleoli','Mitoses','Class')]
library('RoughSets')
decision.table <- SF.asDecisionTable(dataset = table, decision.attr = 10, indx.nominal = 10)

View(decision.table)
res.2 <- BC.discernibility.mat.RST(decision.table, range.object = NULL)
reduct <- FS.reducts.computation(res.2, method = "greedy.heuristic")
new.decTable <- SF.applyDecTable(decision.table, reduct, control = list(indx.reduct = 1))

rame<-as.data.frame(new.decTable)
library('caTools')
msk = sample.split(frame, SplitRatio=0.7, group=NULL)
train = frame[msk,]  
test = frame[!msk,]

#CMEANS IMPLEMENTATION
x<-rbind(decision.table$ClumpThickness, decision.table$UniformityCellSize, decision.table$UniformityCellShape)

x<-t(x)
result<-cmeans(x,2,50,verbose=TRUE,method="cmeans")
print(result)


plot(iris, col=result$cluster)


#APRIORI IMPLEMENTATION
rules <- apriori(mat, parameter = list(supp = 0.5, conf = 0.9, target = "rules"))
summary(rules)




# J48 implementation
library(RWeka)
# load data
data(iris)
# fit model
fit <- J48(Class~., data=decision.table)
# summarize the fit
summary(fit)
# make predictions
predictions <- predict(fit, decision.table[,1:10])
# summarize accuracy
table(predictions, iris$Class)


#PRE PROCESSING setEPS
decision.table$ClumpThickness[is.na(decision.table$ClumpThickness)] <- median(decision.table$ClumpThickness, na.rm = TRUE)
decision.table$UniformityCellSize[is.na(decision.table$UniformityCellSize)] <- median(decision.table$UniformityCellSize, na.rm = TRUE)
decision.table$UniformityCellShape[is.na(decision.table$UniformityCellShape)] <- median(decision.table$UniformityCellShape, na.rm = TRUE)
decision.table$BareNuclei[is.na(decision.table$BareNuclei)] <- median(decision.table$BareNuclei, na.rm = TRUE)
decision.table$BareNuclei = as.numeric(decision.table$BareNuclei)
decision.table$MarginalAdhesion[is.na(decision.table$MarginalAdhesion)] <- median(decision.table$MarginalAdhesion, na.rm = TRUE)
decision.table$BlandChromatin[is.na(decision.table$BlandChromatin)] <- median(decision.table$BlandChromatin, na.rm = TRUE)

newDecision.table = decision.table[1:699,1:4]
cbind(newDecision.table, decision.table[1:699,6:6])
newDecision.table =cbind(newDecision.table, decision.table[1:699,7:7])
names(newDecision.table)[5]<-"BareNuclei"
names(newDecision.table)[6]<-"BlandChromatin"
names(new.decTable)[7]<-"Class"
new.decTable$Class[is.na(new.decTable$Class)]


#PCA

str(newDecision.table)
prin_comp <- prcomp(newDecision.table, scale. = T)
names(prin_comp)
prin_comp$center
prin_comp$rotation
plot(prin_comp, type = "l")
plot(prin_comp)
summary(prin_comp)
biplot(prin_comp)

comp <- data.frame(prin_comp$x[,1:3])
plot(comp, pch=16, col=rgb(0,0,0,0.5))

#pair wise scatterplot
pairs(newDecision.table)

prin_comp = princomp(newDecision.table, scores = TRUE, cor = TRUE)
summary(prin_comp)
plot(prin_comp)
biplot(prin_comp)
prin_comp$loadings
cor(newDecision.table)
plot(prin_comp, type = "l", main = "Scree Plot")

#Neural Net
new.decTable= cbind(newDecision.table,decision.table[1:699,10])
index <- sample(1:nrow(new.decTable),round(0.75*nrow(new.decTable)))

train <- new.decTable[index,]
test <- new.decTable[-index,]
lm.fit <- glm(Class~., data=train)

installed.packages("neuralnet")
library(neuralnet)
newTable = as.numeric(new.decTable)
m <- model.matrix( 
  ~ Class + ClumpThickness+UniformityCellSize+UniformityCellShape+MarginalAdhesion+BareNuclei+BlandChromatin, 
  data = new.decTable
)
nn <- neuralnet(Class4~ClumpThickness+UniformityCellSize+UniformityCellShape+MarginalAdhesion+BareNuclei+BlandChromatin,data = m, hidden = 2, linear.output = FALSE)
nn
plot(nn)
nn$net.result[[1]]
new.decTable$Class = ifelse(new.decTable$Class==2,0,1)
test$Class = ifelse(test$Class==2,0,1)
nn1 = ifelse(nn$net.result[[1]]>0.5,1,0)
misClassificationError = mean(new.decTable$Class!=nn1)



#Pre processing for neural net
maxs <- apply(new.decTable, 2, max) 
mins <- apply(new.decTable, 2, min)
scaled <- as.data.frame(scale(new.decTable, center = mins, scale = maxs - mins))
train_ <- scaled[index,]
test_ <- scaled[-index,]
m <- model.matrix( 
  ~ Class + ClumpThickness+UniformityCellSize+UniformityCellShape+MarginalAdhesion+BareNuclei+BlandChromatin, 
  data = train_
)
nn <- neuralnet(Class~ClumpThickness+UniformityCellSize+UniformityCellShape+MarginalAdhesion+BareNuclei+BlandChromatin,data = m, hidden = 2, linear.output = FALSE)
plot(nn)
pr.nn <- compute(nn,test_[,1:6])
pr.nn
pr.nn$net.result
pr.nn1 = ifelse(pr.nn$net.result>0.5,1,0)
pr.nn1
misClassificationError = mean(test_$Class!=pr.nn1)
misClassificationError

#Neural Net after PCA
comp = cbind(comp,new.decTable$Class)
names(comp)[4]= "Class"
train.pca <- comp[index,]
test.pca <- comp[-index,]
m <- model.matrix( 
  ~ Class + PC1 + PC2 + PC3, 
  data = train.pca
)
set.seed(90)
nn <- neuralnet(Class~PC1+PC2+PC3, hidden = 8, linear.output = FALSE, data = m, algorithm = "backprop", learningrate = 0.05)
plot(nn)
?"neuralnet"
predict.nn = compute(nn,test.pca[,1:3])
predict.nn$net.result

predict.nn1 = ifelse(predict.nn$net.result>0.5,1,0)
predict.nn1
misClassificationError = mean(test.pca$Class!=predict.nn1)
misClassificationError
tab = table(test.pca$Class,predict.nn1)
tab
print(tab)
matrix <- confusionMatrix(predict.nn1,test.pca$Class, positive = NULL, 
                dnn = c("Prediction", "Reference"))
ctable <- as.table(matrix(c(112, 3, 3, 57), nrow = 2, byrow = TRUE))
plot(specificity(as.factor(predict.nn1),as.factor(test.pca$Class)))
library(AUC)
installed.packages(caret)
install.packages("http://cran.r-project.org/src/contrib/Archive/nloptr/nloptr_1.0.0.tar.gz",
                 repos=NULL, type="source")

fourfoldplot(matrix)

#loading dataset
db=read.csv("/media/shilpi/New Volume/python/breast_cancer2.csv")
summary(db)
head(db)

db$Class[db$Class==2]<-0
db$Class[db$Class==4]<-1

library(Rcpp)
library(RoughSets)
db$BareNuclei=as.numeric(db$BareNuclei)
db$BareNuclei[is.na(db$BareNuclei)] <- (median(db$BareNuclei, na.rm = TRUE))

sub <- sample(nrow(db), floor(nrow(db) * 0.75))
training <- db[sub,(3:12) ]
testing <- db[-sub, (3:12)]

summary(training)
summary(testing)


decision.table<-SF.asDecisionTable(training, decision.attr =training$Class, indx.nominal = NULL)
res.1 <- FS.feature.subset.computation(decision.table,
                                       method = "quickreduct.frst")

## generate new decision table according to the reduct
decision.table <- SF.applyDecTable(decision.table, res.1)
str(decision.table)
str(decision.table)
cancer.testing=testing[,(1:9)]
summary(cancer.testing)

cancer.testing<-SF.asDecisionTable(cancer.testing)
summary(decision.table)
summary(cancer.testing)

nrow(decision.table)




#fuzzy rough instance selection
res.1 <- IS.FRIS.FRST(decision.table = decision.table, control =
                        list(threshold.tau = 0.75, alpha = 0.8))

## generate new decision table
decision.table <- SF.applyDecTable(decision.table, res.1)
str(decision.table)
#summary(decision.table)


nrow(decision.table)


#fuzzy nn
control <- list(type.LU = "implicator.tnorm", k = 3,type.aggregation = c("t.tnorm", "lukasiewicz"),
                type.relation = c("tolerance", "eq.1"), t.implicator = "lukasiewicz")

res.1 <- C.FRNN.FRST(decision.table = decision.table, newdata = cancer.testing, control = control)



test.class<-testing[,10]
cancer.table<-table(res.1,test.class)
cancer.table
str(cancer.table)
accuracy<-sum(diag(cancer.table))/sum(cancer.table)
accuracy

#install.packages(c('lme4', 'pbkrtest', 'BradleyTerry2', 'car', 'caret'))

#library(mlbench)
#library(caret)
#control <- rfeControl(functions=rfFuncs, method="cv", number=10)
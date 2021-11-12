#ÃâÃ³ : http://ml-tutorials.kyrcha.info/dt.html

#Decision Tree classification on Breast Cancer dataset

#Download dataset
fileURL <- "http://archive.ics.uci.edu/ml/machine-learning-databases/breast-cancer-wisconsin/breast-cancer-wisconsin.data"
download.file(fileURL, destfile="breast-cancer-wisconsin.data", method="curl")
# read the data
data <- read.table("breast-cancer-wisconsin.data", na.strings = "?", sep=",")
str(data)


#remove id number(1st column) 
data<-data[,-1]

#put names in columns
names(data) <- c("ClumpThickness",
                 "UniformityCellSize",
                 "UniformityCellShape",
                 "MarginalAdhesion",
                 "SingleEpithelialCellSize",
                 "BareNuclei",
                 "BlandChromatin",
                 "NormalNucleoli",
                 "Mitoses",
                 "Class")

#make Class Column to categorical value
data$Class<-factor(data$Class, levels=c(2,4),labels="benign","margin")

#see data summary
print(summary(data))

#split dataset to training(70%) and validation(30%)
set.seed(1234)
ind<-sample(2, nrow(data),replace=TRUE,prob=c(0.7,0.3))
trainData<-data[ind==1,]
validationData<-data[ind==2,]

#load library rpart, rpart.plot, part
library(rpart)
library(rpart.plot)
library(party)

# use rpart to train algorithm for making decision tree
tree=rpart(Class~.,data=trainData,method="class")
entTree = rpart(Class ~ ., data=trainData, method="class", parms=list(split="information"))
print(entTree)

#visual representation
plot(tree)
text(tree)

#more advance visual representation
rpart.plot(tree,extra=104,nn=TRUE)

#see decision tree method's parameter
rpart.control()

"""
 - minsplit
 : the minimum number of observations that must exist in a node in order for a split to be attempted. 
 - minbucket
 : the minimum number of observations in any terminal (leaf) node. 
 - maxdepth
 : sets the maximum depth of any node of the final tree 
 - cp
 : parameter controlling if the complexity for a given split is allowed and is set empirically. 
   Bigger values equal more prunning.
"""

#control/optimize decision tree paramater
tree_with_params=rpart(Class~., data=trainData,method="class",minsplit=1,minbucket=1,cp=-1)
rpart.plot(tree_with_params,extra=104, nn=TRUE)

#use part library with ctree function
library(part)
ctree=ctree(Class~.,data=trainData)
print(ctree)

#visualize it
plot(ctree,type="simple")

#evaluation 
evaluation<-function(model,data,atype){
  cat("\nCinfusion Matrix:\n")
  prediction=predict(model,data,type=atype)
  xtab=table(prediction,data$Class)
  print(xtab)
  
  cat("\nEvaluation\n")
  accuracy=sum(prediction==data$Class)/length(data$Class)
  precision=xtab[1,1]/sum(xtab[,1])
  recall=xtab[1,1]/sum(xtab[1,])
  f=2*(precision*recall)/(precision+recall)
  
  cat(paste("Accuracy:\t",format(accuracy,digits=2),"\n",sep=" "))
  cat(paste("Precision:\t",format(precision,digits=2),"\n",sep=" "))
  cat(paste("Recall:\t",format(recall,digits=2),"\n",sep=" "))
  cat(paste("F-score:\t",format(f,digits=2),"\n",sep=" "))
}

evaluation(tree,validationData,"class")

evaluation(entTree,validationData,"class")

evaluation(tree_with_params,validationData,"class")

evaluation(ctree,validationData,"response")

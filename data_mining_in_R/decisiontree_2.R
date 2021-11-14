#Decision Tree classification on Breast Cancer dataset
#clear environment
rm(list = ls())

#load library for checking values
#install.packages("psych")
library(psych)
#install.packages("Hmisc")
library(Hmisc)
#install.packages("skimr")
library(skimr)

#load library for plotting & modeling
library(rpart)
library(rpart.plot)
library(party)
#install.packages("part")
library(part)


#Download dataset
fileURL <- "http://archive.ics.uci.edu/ml/machine-learning-databases/breast-cancer-wisconsin/breast-cancer-wisconsin.data"
download.file(fileURL, destfile="breast-cancer-wisconsin.data", method="curl")
#Load dataset
data <- read.csv("breast-cancer-wisconsin.data", na.strings = "?", sep=",")
str(data)

#remove id number(1st column) 
data<-data[,-1]

#put names in columns
names(data) <- c("ClumpThickness","UniformityCellSize","UniformityCellShape",
                 "MarginalAdhesion","SingleEpithelialCellSize",
                 "BareNuclei","BlandChromatin","NormalNucleoli",
                 "Mitoses","Class")

#check type of data
str(data)
#class 속성이 범주형 값이 아닌 2와 4로 되어 있음

#make Class Column to categorical value : 2-> "benign" 4->"malignant"
data$Class <- factor(data$Class, levels=c(2,4), labels=c("benign", "malignant"))

#check missing value
psych::describe(data)
Hmisc::describe(data)
skimr::skim(data)
#결과 : BareNuclei 속성의 16개 Nan값 존재함 

#BareNuclei 속성의 97%는 값이 존재해 평균값으로 Nan 대체
BareNuclei_avg <-data$BareNuclei %>% 
  mean(na.rm=TRUE)%>% print
data$BareNuclei[is.na(data$BareNuclei)]<-BareNuclei_avg 

#BareNuclei의 Nan 평균값으로 대체 되었는지 확인
anyNA(data$BareNuclei)

#see data summary
print(summary(data))



#split dataset to training(70%) and validation(30%)
set.seed(1234)
ind<-sample(2, nrow(data),replace=TRUE,prob=c(0.7,0.3))
trainData<-data[ind==1,]
testData<-data[ind==2,]

# rpart 의사결정 트리[1] 생성 
rTree = rpart(Class ~ ., data=trainData, method="class", parms=list(split="information"))
print(rTree)

#visual representation
windows()
rpart.plot(rTree,extra=104,nn=TRUE,branch=1)

#rpart 의사결정 트리[1] parameter 받아오기
rpart.control()

parameter_discrition="
<rpart 메소드 인자 설명>
 - minsplit
 : the minimum number of observations that must exist in a node in order for a split to be attempted. 
 - minbucket
 : the minimum number of observations in any terminal (leaf) node. 
 - maxdepth
 : sets the maximum depth of any node of the final tree 
 - cp
 : parameter controlling if the complexity for a given split is allowed and is set empirically. 
   Bigger values equal more prunning.
"



#직접 parameter 조정해 생성한 의사결정트리 [2]
tree_with_params=rpart(Class~., data=trainData,method="class",minsplit=1,minbucket=1,cp=-1)
print(tree_with_params)
windows()
rpart.plot(tree_with_params,extra=104, nn=TRUE,compress = TRUE)

#ctree 의사결정트리[3] 생성
ctree=ctree(Class~.,data=trainData)
print(ctree)

#visualize it
windows()
plot(ctree,type="simple")

#evaluation 
evaluation<-function(model,data,atype){
  cat("\nConfusion Matrix:\n")
  #trainData로 만든 의사결정트리를 기반으로 testData 예측
  prediction<-predict(model,data,type=atype)
  #confusion matrix 생성
  xtab<-table(prediction,data$Class)
  print(xtab)
  
  cat("\nEvaluation\n") #각종 분류 평가지표 구하기
  accuracy<-sum(prediction==data$Class)/length(data$Class)
  precision<-xtab[1,1]/sum(xtab[,1])
  recall<-xtab[1,1]/sum(xtab[1,])
  f=2*(precision*recall)/(precision+recall)
  
  #각종 분류 평가지표 출력
  cat(paste("Accuracy:\t",format(accuracy,digits=2),"\n",sep=" "))
  cat(paste("Precision:\t",format(precision,digits=2),"\n",sep=" "))
  cat(paste("Recall:\t",format(recall,digits=2),"\n",sep=" "))
  cat(paste("F-score:\t",format(f,digits=2),"\n",sep=" "))
}

evaluation(rTree,testData,"class") #의사결정모델 [1]에 대한 testData 예측 결과

evaluation(tree_with_params,testData,"class")  #의사결정모델 [2]에 대한 testData 예측 결과

evaluation(ctree,testData,"response")  #의사결정모델 [3]에 대한 testData 예측 결과
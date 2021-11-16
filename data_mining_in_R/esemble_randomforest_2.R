#Randomforest on breast cancer dataset
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
library(caret)

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


# Create train/validation/test sets (60:20:20)
set.seed(1234)
ind <- sample(2, nrow(data), replace=TRUE, prob=c(0.7, 0.3))
ind
train <- data[ind==1, ]
test <- data[ind==2, ]

rf <- randomForest(Class~.,data=train,proximity=TRUE) 
#랜덤포레스트 모형의 오류 감소 추세 그래프
windows()
plot(rf)
#각 변수들의 모형에의 기여도
windows()
varImpPlot(rf)



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
  #오분류율 계산
  error.rpart <- 1-(sum(diag(xtab))/sum(xtab))
  error.rpart 
  
  #각종 분류 평가지표 출력
  cat(paste("Accuracy:\t",format(accuracy,digits=2),"\n",sep=" "))
  cat(paste("Precision:\t",format(precision,digits=2),"\n",sep=" "))
  cat(paste("Recall:\t",format(recall,digits=2),"\n",sep=" "))
  cat(paste("F-score:\t",format(f,digits=2),"\n",sep=" "))
  cat(paste("오분류율:\t",format(error.rpart,digits=2),"\n",sep=" "))
}

evaluation(rf,test,"class")



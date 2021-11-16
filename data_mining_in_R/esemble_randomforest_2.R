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
#class �Ӽ��� ������ ���� �ƴ� 2�� 4�� �Ǿ� ����

#make Class Column to categorical value : 2-> "benign" 4->"malignant"
data$Class <- factor(data$Class, levels=c(2,4), labels=c("benign", "malignant"))

#check missing value
psych::describe(data)
Hmisc::describe(data)
skimr::skim(data)
#��� : BareNuclei �Ӽ��� 16�� Nan�� ������ 

#BareNuclei �Ӽ��� 97%�� ���� ������ ��հ����� Nan ��ü
BareNuclei_avg <-data$BareNuclei %>% 
  mean(na.rm=TRUE)%>% print
data$BareNuclei[is.na(data$BareNuclei)]<-BareNuclei_avg 

#BareNuclei�� Nan ��հ����� ��ü �Ǿ����� Ȯ��
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
#����������Ʈ ������ ���� ���� �߼� �׷���
windows()
plot(rf)
#�� �������� �������� �⿩��
windows()
varImpPlot(rf)



#evaluation 
evaluation<-function(model,data,atype){
  cat("\nConfusion Matrix:\n")
  #trainData�� ���� �ǻ����Ʈ���� ������� testData ����
  prediction<-predict(model,data,type=atype)
  #confusion matrix ����
  xtab<-table(prediction,data$Class)
  print(xtab)
  
  cat("\nEvaluation\n") #���� �з� ����ǥ ���ϱ�
  accuracy<-sum(prediction==data$Class)/length(data$Class)
  precision<-xtab[1,1]/sum(xtab[,1])
  recall<-xtab[1,1]/sum(xtab[1,])
  f=2*(precision*recall)/(precision+recall)
  #���з��� ���
  error.rpart <- 1-(sum(diag(xtab))/sum(xtab))
  error.rpart 
  
  #���� �з� ����ǥ ���
  cat(paste("Accuracy:\t",format(accuracy,digits=2),"\n",sep=" "))
  cat(paste("Precision:\t",format(precision,digits=2),"\n",sep=" "))
  cat(paste("Recall:\t",format(recall,digits=2),"\n",sep=" "))
  cat(paste("F-score:\t",format(f,digits=2),"\n",sep=" "))
  cat(paste("���з���:\t",format(error.rpart,digits=2),"\n",sep=" "))
}

evaluation(rf,test,"class")


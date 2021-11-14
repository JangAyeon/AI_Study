rm(list = ls())

library(randomForest)
library(rpart) 

data(stagec)	 
str(stagec)

stagec1<- subset(stagec, !is.na(g2))
stagec2<- subset(stagec1, !is.na(gleason))
stagec3<- subset(stagec2, !is.na(eet))
str(stagec3)

 
set.seed(1234)
ind <- sample(2, nrow(stagec3), replace=TRUE, prob=c(0.7, 0.3))

ind
trainData <- stagec3[ind==1, ]
testData <- stagec3[ind==2, ]

 


rf <- randomForest(ploidy ~ ., data=trainData, ntree=100, proximity=TRUE)	
# ��������(class)��  �󵿿���ü��(ploidy)
#��������(�Ӽ�)��  7����
# proximity=TRUE��  ��ü��  ����  ������  �����  ����:
# ������  ������忡 ���ԵǴ�  �󵵿�  ������

#Ʈ������ ���� ���ֺ� ���з���
#�������� ��ü ���з���
plot(rf)
 
#�׽�Ʈ �ڷῡ ���� ���� ����

rf.pred <- predict(rf, newdata=testData)
tb <- table(rf.pred, testData$ploidy)

#���з��� ���
error.rpart <- 1-(sum(diag(tb))/sum(tb))
error.rpart 

#��Ȯ���� ������� ǥ��
sum(rf.pred==testData$ploidy)/length(rf.pred)*100



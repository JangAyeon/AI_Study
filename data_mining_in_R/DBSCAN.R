rm(list = ls())

library(fpc)
data(iris)
iris2 <- iris[-5]

ds <- dbscan(iris2, eps=0.42, MinPts=5)

#compare clusters with original class labels
table(ds$cluster, iris$Species)

 
plotcluster(iris2, ds$cluster)


#simple DBSCAN Example : https://rpubs.com/datalowe/dbscan-simple-example
#DBSCAN using spatial data : https://rfriend.tistory.com/587

# dataset : 다양한 형태의 군집과 잡음으로 구성된 factoextra 내 multishape 사용
#install(devtools)
#install(factoextra)
#install(fpc)
devtools::install_github("kassambara/factoextra")


#load & plot data
library(factoextra)
data("multishapes",package="factoextra")
str(multishapes)
windows()
plot(multishapes$x, multishapes$y)

#Kmeans cluster (k=5)
df<-multishapes[,1:2]
set.seed(1004)
km.res<-kmeans(df,center=5,nstart=25)

#plot Kmeans cluster result
windows()
fviz_cluster(km.res,df,frame=FALSE,geom="point")

##K-means 결과 
## 1. 상단 중앙이 빈 원형 군집 2개 구분 실패
## 2. 좌측 하단 선형 군집 2개 구분 실패
## 3. 우측 하단 모여있는 것에 noise 섞여서 군집화 됨
## clustering 실패!!

#DBSCAN cluster (k=5)
library("fpc")
set.seed(1004)
db<-fpc::dbscan(df, eps=0.15,MinPts = 5)

#plot DBSCAN cluster result
windows()
fviz_cluster(db,df,stand=FALSE, frame=FALSE, geom="point")

##DBSCAN 결과
## 1. 상단 중앙이 빈 원형 군집 2개 구분 성공
## 2. 좌측 하단 선형 군집 2개 구분 성공
## 3. 우측 하단 noise 제외하고 모여있는 것만 구분 성공
## cluster 성공!!

#DBSCAN model 정보
print(db)
# cluster가 0으로 분류된 것은 noise/outlier 의미

# data 중 무작위로 50개 뽑아 어느 군집으로 할당 되었는지 관찰
db$cluster[sample(1:1089,50)]

# cluster 별 요약 통계량 (x평균, y평균)
library(dplyr)
df%>%
  group_by(db$cluster)%>%
  summarize(x_mean=mean(x,rm=TRUE),
           y_mean=mean(y,rm=TRUE))

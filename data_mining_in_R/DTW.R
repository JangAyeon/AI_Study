rm(list = ls())
library(dtw)


#2개 데이터 시퀀스 생성
set.seed(1)
a <- sort(sample(1:99,3))
# 첫번째 시퀀스 3개 정수 구성
set.seed(3)
b<- sort(sample(1:99,5))
# 두번째 시퀀스 5개 정수 구성



#시퀀스 a, b 동시에 단수 plot
windows()
plot(b, type="l") #검정색 line
lines(a, col="red")

#Dynamic Time wraping distance 계산
DTW<-dtw(a,b,keep=T,step.pattern = symmetric1)
# step.pattern = symmetric1 설정하여
#DTW[i, j] := cost + minimum(DTW[i-1, j  ],
#               DTW[i  , j-1],
#                 DTW[i-1, j-1])의 알고리즘 적용

#DTW 계산 완료된 costMatrix 출력
DTW$costMatrix

#2차원 wrapping path
windows()
dtwPlotTwoWay(DTW)

#3차원 wrapping path
windows()
dtwPlotThreeWay(DTW)

#DTW 모델 설명
summary(DTW)
#the cumulative cost matrix
DTW$costMatrix
#the stepPattern object used for the computation
DTW$stepPattern
#the list of steps taken from the beginning to the end of the alignmen
DTW$stepsTaken




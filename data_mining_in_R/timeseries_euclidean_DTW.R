rm(list = ls())

ts_data <- matrix(rnorm(16*10), ncol=16)  
# 16 * 10 shape의 정규분포를 따르는 데이터 생성
# matrix(rnorm(16*10)) : 160*1 shape의 데이터 생성됨
# 이렇게 데이터 생성하면 실수형 데이터가 생성됨

# cf> 0~n까지 정수로 데이터 랜덤하게 생성하면 정규화 과정 필요 없음
ts_data

m_ts <- apply(ts_data, 2, mean)
#ts_data의 열에 대해 평균 계산
sd_ts <- apply(ts_data, 2, sd)
#ts_data의 열에 대해 표준편차 계산

ts_data_new <- ts_data

# Data Standardization 
# rescales data to have a mean of 0 and a standard deviation of 1 
for (i in 1:16)
  ts_data_new[,i] <-(ts_data[,i] - m_ts[i]) / sd_ts[i]

#rescale한 data 출력
str(ts_data_new)
head(ts_data_new)

#rescale한 data의 평균 값과 표준편차 출력
apply(ts_data_new, 2, mean)
#평균이 완전히 0이 아니라 0에 근사한 값
apply(ts_data_new, 2, sd)
#표준편차 1

par(mfrow=c(4,4), mai=c(0.3, 0.6, 0.1,0.1))
# 4행 4열, 인치 단위로 margin이 아래, 왼쪽, 위, 오른쪽으로 들어감
#put multiple graphs in a single plot by setting some graphical parameters with the help of par() function
#par() function helps us in setting or inquiring about these parameters. 
# mfrow : specify the number of subplot
#A numerical vector of the form c(bottom, left, top, right) 
#which gives the margin size specified in inches.

#행렬 인덱싱
#m[i,j] : i번째 행, j번째 열 구성요소
#m[i,] : i번째 행 전체 구성요소 - row
#m[,j] : j번째 열 전체 구성요소 - column

for (i in 1:16) {
  plot(ts_data_new[,i], type="l") #검정색 line
  lines(ts_data_new[,1], col="red")
}

#거리 구하기
dist(rbind(ts_data_new[,1], ts_data_new[,2]), method = "euclidean")
# rbind 내 첫번째 인자 : query seqeunce, 두번째 인자 : 비교 시퀀스 
# method : 거리 측정 방법으로 euclidean distance 선택


euc_distances <- vector(length=15)
# 길이가 15인 빈 vector 선언

for (i in 2:16)
  #query sequence 제외 나머지하고 다 유클리디안 거리 구함
  euc_distances[i-1] <- dist(rbind(ts_data_new[,1], ts_data_new[,i]), method="euclidean")
  # i=2 -> index 1 : 1과 2의 유클리디안 거리 값
  # i=3 -> index 2 : 1과 3의 유클리디안 거리 값
euc_distances
# 유클리디안 거리 작을 수록 유사도 커짐
# 해당 벡터에서 최소값을 가지는 것이 가장 유사한 것임

par(mfrow=c(4,4), mai=c(0.3, 0.6, 0.1,0.1))
plot(ts_data_new[,1], type="l") #query sequence 플롯

for(i in order(euc_distances)) {
  #order()을 이용해 오름차순으로 정렬
  plot(ts_data_new[,i+1], type="l")
  lines(ts_data_new[,1], col="red")
}

install.packages("dtw")
library(dtw)

dtw_alignment <- dtw(ts_data_new[,1], ts_data_new[,2], keep=T)
dtw_alignment$distance


dtwPlotTwoWay(dtw_alignment)

dtwPlotThreeWay(dtw_alignment)


dtw_distances <- vector(length=15)

for (i in 2:16){
  dtw_alignment <- dtw(ts_data_new[,1], ts_data_new[,i], keep=T)
  dtw_distances[i-1] <- dtw_alignment$distance
}

dtw_distances

euc_distances

par(mfrow=c(4,4), mai=c(0.3, 0.6, 0.1,0.1))
plot(ts_data_new[,1], type="l")
for(i in order(dtw_distances)) {
  plot(ts_data_new[,i+1], type="l")
  lines(ts_data_new[,1], col="red")
}
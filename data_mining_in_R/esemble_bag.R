rm(list = ls())

library(adabag)
data(iris)

iris.bagging <- bagging(Species~., data=iris, mfinal=10)
# mfinal= 반복수 = 트리의  수=bootstrap 수 (디폴트=100)
#environment에서 iris.bagging 값에서 tree확인해보기 - 리스트로 10개 생성되어 있음

iris.bagging$importance	# 변수의  상대적인  중요도

#변수의  중요도는  각  트리에서  변수에  의해  주어지는  
#지니지수의  gain(또는 불확실성의  감소량)을  고려한  척도


#R 패키지 {adabag}의 bagging() 함수는 배깅을 이용하여 분류를 수행
#plot() 함수를 통해 분류 결과를 트리 형태로 출력
#여기서는 train과 test로 같은 data 사용 중임
plot(iris.bagging$trees[[10]]) #10번째 트리
text(iris.bagging$trees[[10]])

#predict() 함수를 통해 새로운 자료에 대한 분류(예측)를 수행
#모형 구축에 사용된 자료를 재사용하여 분류를 수행
 
pred <- predict(iris.bagging, newdata=iris)
table(pred$class, iris[,5])
 



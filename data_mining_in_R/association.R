#메모리 상의 모든 내용 삭제
rm(list = ls()) 

#패키지 설치
install.packages("arules") 
install.packages("arulesViz")

#패키지 메모리상으로 로딩
library(arules) 
library(arulesViz)

load("C:/Users/ayeon/OneDrive/바탕 화면/장아연/3학년2학기/바이오데이터마이닝/4주차실습_연관규칙/titanic.raw.rdata")
summary(titanic.raw) #데이터 내용 살피기

titanic <- titanic.raw #이름 줄이기

class(titanic) #data type은 data.frame 형태임
dim(titanic) #data의 차원 : 객체가 2201개, 속성은 4개

options(digits=4)  #유효숫자 4자리

#모든 규칙 생성
#(titanic data 변수에 apriori 함수 적용을 해서 rules.all 변수에 담기 -> 빈번 항목 집합 & 연관 규칙 만들어짐)
rules.all <- apriori(titanic)

#규칙 확인
#coverage : X가 발생할 확률(해당 값 갯수/전체 갯수), count : X->Y 발생 확률
inspect(rules.all)


#Finding rules with rhs indicating survival only and lower support
#규칙의 우변(rhs)이 생존여부(survided)와 관계된 규칙
#설정값 변경: 최소부분집합크기(minlen) =2, 최소지지도(supp) =0.005, 최소신뢰도(conf)=0.8
# rules with rhs containing "Survived" only (오른쪽에는 오직 생존 여부에 관련된 규칙만 나오도록)

rules <- apriori(titanic, parameter = list(minlen=2, supp=0.005, conf=0.8),
                appearance = list(rhs=c("Survived=No", "Survived=Yes"), default="lhs"),
                control = list(verbose=F))

#규칙 확인
inspect(rules)

#향상도(lift) 기준으로 (내림차순) 정렬 
rules.sorted <- sort(rules, by="lift")

#규칙 확인
inspect(rules.sorted)

#규칙1은 2등석의 모든 어린이가 생존했다는 것을 의미
#규칙2는 규칙1에 비해 더 이상의 추가 정보 제공 안함 (규칙 두개 모두 confidence 1)
#{A,B}->{D},{A,B,C}->{D}가 동일한 지지도/신뢰도 가짐
#이러한 규칙은 일종의 불필요한 중복이므로, 중복규칙을 찾아 제거해야한다.
#When a rule (#2) is a super rule of another rule (#1)
#and the former has the same or a lower lift, 
#the former rule (#2) is considered to be redundant.


# Finding redundant rules
#중복되는 규칙 찾기
inspect(rules.sorted[is.redundant(rules.sorted)])


#Pruning redundant rules
#중복되는 규칙 제거 
rules.pruned <- rules.sorted[!is.redundant(rules.sorted)]

#규칙 확인
inspect(rules.pruned)


#Interpreting rules
inspect(rules.pruned[1]) 

#이 규칙은 class2nd의 모든 아이가 살아남았다고 명시하지만
#다른 클래스와의 생존율을 비교하기 위한 정보는 전혀 제공하지 않는다.
#따라서, parameters  수정
#rule의 Y에는 survived=Yes만 들어가게, X에는 Class와 Age에 해당하는 항목만 들어가게!
rules2 <- apriori(titanic, control = list(verbose=F),
                 parameter = list(minlen=3, supp=0.002, conf=0.2),
                 appearance = list(default="none", 
                                   rhs=c("Survived=Yes"),
                                   lhs=c("Class=1st", "Class=2nd", "Class=3rd",
                                         "Age=Child", "Age=Adult")))

rules.sorted2 <- sort(rules2, by="confidence")
inspect(rules.sorted2)

#===================================================================
# visualization
#연관규칙 시각화

#Scatter plot
plot(rules.all)#모든 규칙


#Balloon plot
plot(rules.pruned, method="grouped") #pruning한 규칙


#Graph-based visualizations
plot(rules.pruned, method="graph") #내부적인 난수 사용해 그릴 때마다 item의 위치 달라짐
plot(rules.pruned, method="graph", control=list(type="items"))


#Parallel coordinates plot (평행좌표그림)
plot(rules.pruned, method="paracoord", control=list(reorder=TRUE))


#matrix-based visualization
plot(rules.pruned, method="matrix", measure="lift") 
plot(rules.pruned, method="matrix", engine="interactive", measure="lift")
#engine이 interactive로 plot의 클릭한 부분의 rule과 lift 값이 출력됨
plot(rules.pruned, method="matrix", engine="3d", measure="lift")  

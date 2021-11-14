#�޸� ���� ��� ���� ����
rm(list = ls()) 

#��Ű�� ��ġ
install.packages("arules") 
install.packages("arulesViz")

#��Ű�� �޸𸮻����� �ε�
library(arules) 
library(arulesViz)

load("C:/Users/ayeon/OneDrive/���� ȭ��/��ƿ�/3�г�2�б�/���̿������͸��̴�/4�����ǽ�_������Ģ/titanic.raw.rdata")
summary(titanic.raw) #������ ���� ���Ǳ�

titanic <- titanic.raw #�̸� ���̱�

class(titanic) #data type�� data.frame ������
dim(titanic) #data�� ���� : ��ü�� 2201��, �Ӽ��� 4��

options(digits=4)  #��ȿ���� 4�ڸ�

#��� ��Ģ ����
#(titanic data ������ apriori �Լ� ������ �ؼ� rules.all ������ ��� -> ��� �׸� ���� & ���� ��Ģ �������)
rules.all <- apriori(titanic)

#��Ģ Ȯ��
#coverage : X�� �߻��� Ȯ��(�ش� �� ����/��ü ����), count : X->Y �߻� Ȯ��
inspect(rules.all)


#Finding rules with rhs indicating survival only and lower support
#��Ģ�� �캯(rhs)�� ��������(survided)�� ����� ��Ģ
#������ ����: �ּҺκ�����ũ��(minlen) =2, �ּ�������(supp) =0.005, �ּҽŷڵ�(conf)=0.8
# rules with rhs containing "Survived" only (�����ʿ��� ���� ���� ���ο� ���õ� ��Ģ�� ��������)

rules <- apriori(titanic, parameter = list(minlen=2, supp=0.005, conf=0.8),
                appearance = list(rhs=c("Survived=No", "Survived=Yes"), default="lhs"),
                control = list(verbose=F))

#��Ģ Ȯ��
inspect(rules)

#���(lift) �������� (��������) ���� 
rules.sorted <- sort(rules, by="lift")

#��Ģ Ȯ��
inspect(rules.sorted)

#��Ģ1�� 2��� ��� ��̰� �����ߴٴ� ���� �ǹ�
#��Ģ2�� ��Ģ1�� ���� �� �̻��� �߰� ���� ���� ���� (��Ģ �ΰ� ��� confidence 1)
#{A,B}->{D},{A,B,C}->{D}�� ������ ������/�ŷڵ� ����
#�̷��� ��Ģ�� ������ ���ʿ��� �ߺ��̹Ƿ�, �ߺ���Ģ�� ã�� �����ؾ��Ѵ�.
#When a rule (#2) is a super rule of another rule (#1)
#and the former has the same or a lower lift, 
#the former rule (#2) is considered to be redundant.


# Finding redundant rules
#�ߺ��Ǵ� ��Ģ ã��
inspect(rules.sorted[is.redundant(rules.sorted)])


#Pruning redundant rules
#�ߺ��Ǵ� ��Ģ ���� 
rules.pruned <- rules.sorted[!is.redundant(rules.sorted)]

#��Ģ Ȯ��
inspect(rules.pruned)


#Interpreting rules
inspect(rules.pruned[1]) 

#�� ��Ģ�� class2nd�� ��� ���̰� ��Ƴ��Ҵٰ� ����������
#�ٸ� Ŭ�������� �������� ���ϱ� ���� ������ ���� �������� �ʴ´�.
#����, parameters  ����
#rule�� Y���� survived=Yes�� ����, X���� Class�� Age�� �ش��ϴ� �׸� ����!
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
#������Ģ �ð�ȭ

#Scatter plot
plot(rules.all)#��� ��Ģ


#Balloon plot
plot(rules.pruned, method="grouped") #pruning�� ��Ģ


#Graph-based visualizations
plot(rules.pruned, method="graph") #�������� ���� ����� �׸� ������ item�� ��ġ �޶���
plot(rules.pruned, method="graph", control=list(type="items"))


#Parallel coordinates plot (������ǥ�׸�)
plot(rules.pruned, method="paracoord", control=list(reorder=TRUE))


#matrix-based visualization
plot(rules.pruned, method="matrix", measure="lift") 
plot(rules.pruned, method="matrix", engine="interactive", measure="lift")
#engine�� interactive�� plot�� Ŭ���� �κ��� rule�� lift ���� ��µ�
plot(rules.pruned, method="matrix", engine="3d", measure="lift")  
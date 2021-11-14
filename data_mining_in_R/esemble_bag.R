rm(list = ls())

library(adabag)
data(iris)

iris.bagging <- bagging(Species~., data=iris, mfinal=10)
# mfinal= �ݺ��� = Ʈ����  ��=bootstrap �� (����Ʈ=100)
#environment���� iris.bagging ������ treeȮ���غ��� - ����Ʈ�� 10�� �����Ǿ� ����

iris.bagging$importance	# ������  �������  �߿䵵

#������  �߿䵵��  ��  Ʈ������  ������  ����  �־�����  
#����������  gain(�Ǵ� ��Ȯ�Ǽ���  ���ҷ�)��  ������  ô��


#R ��Ű�� {adabag}�� bagging() �Լ��� ����� �̿��Ͽ� �з��� ����
#plot() �Լ��� ���� �з� ����� Ʈ�� ���·� ���
#���⼭�� train�� test�� ���� data ��� ����
plot(iris.bagging$trees[[10]]) #10��° Ʈ��
text(iris.bagging$trees[[10]])

#predict() �Լ��� ���� ���ο� �ڷῡ ���� �з�(����)�� ����
#���� ���࿡ ���� �ڷḦ �����Ͽ� �з��� ����
 
pred <- predict(iris.bagging, newdata=iris)
table(pred$class, iris[,5])
 


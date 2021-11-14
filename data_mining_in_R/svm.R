rm(list = ls())

#load package
library("e1071")

#load data
data(iris)

svm.model <- svm(Species ~ . , data = iris,
                   type = "C-classification", kernel = "radial", cost = 10, gamma = 0.1)
#������ class -> type="C-classification"
#����/�Ʒ� Ŀ�η� ����þ� RBF ��� -> kernel="radial"

summary(svm.model)
#svm.model -> support model 32�� 
#150���� instance �� 32���� �Ϻθ� ����� margin ������ ���� ��ħ)

#����� �ð�ȭ
plot(svm.model, iris, Petal.Width ~ Petal.Length, slice = list(Sepal.Width = 3, Sepal.Length = 4))

#slice �ɼ�:
#������ ���� ���������� ȿ���� �ð�ȭ�� �� 
#� �ٸ� ���������� �����ϰ� ��������(��, ���� ������) ���� (2���� ������ ��� ǥ�� �Ұ��ɴ�)
#Sepal.Width �� Sepal.Length�� ������ ������ �����ϰ� �����ϸ鼭 
#���� ���� Petal.Length �� Petal.Width�� ���信 ��ġ�� ������ �ð�ȭ

plot(svm.model, iris, Sepal.Width ~ Sepal.Length,  slice = list(Petal.Width = 2.5, Petal.Length = 3))
#�׸�����  x: ����Ʈ����, o:������  ����  ��Ÿ��

#Classificatioin with test set
pred <- predict(svm.model, iris, decision.values = TRUE)

#�з���� plotting
pred
plot(pred)


#�з��� �����͸� ���� ���� ��
acc <- table(pred, iris$Species)
 

#���� ����� ���� �������� ��Ȯ�� Ȯ��
sum(pred==iris$Species)/length(pred)*100

#������ ��Ȯ�� Ȯ�� 
classAgreement(acc)  #diag - Percentage of data points in the main diagonal of the table


  
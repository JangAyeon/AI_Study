findwords <- function(tf) {
  txt<-scan(tf,"")       #������ �а�, ������ ������ �����Ͽ� ���͸� ����
  wl<-list()               #�Լ����� ��ȯ�� ����Ʈ ����
  for(i in 1:length(txt)){
    wrd<-tolower(txt[i])   #txt�� ����� �ܾ �ҹ���ȭ
    wl[[wrd]]<-c(wl[[wrd]], i)  #����Ʈ �ε��� ����Ͽ� wl�� �ܾ�� ��ġ�� ����
    print(wrd)
    print(wl[[wrd]])
  }
  return(wl)
  
}

 
freqwl<-function(wrdlist){ # �ܾ� ����Ʈ�� ���Ե� �ܾ��� ������ ���Ϳ� ����
  freqs<-sapply(wrdlist, length)  # length �Լ��� ����Ʈ�� �����Ͽ�, �� �ܾ��� �󵵼��� Ȯ��
  freqs
  return(wrdlist[order(freqs)])  #order(): ������ ���ĵ� ���� ���� �ε����� 
                                 #�󵵼��� ������������ ���� �� ��ȯ
}


fw<-findwords("C:/Users/ayeon/OneDrive/���� ȭ��/��ƿ�/3�г�2�б�/���̿������͸��̴�/�Ƹ��Ƴ��׶���.txt")  
#fw���� �ܾ�� ��ġ�� �����
freq<-freqwl(fw)  # freq �� �󵵼� ������ ���ĵ� ����Ʈ
freq
sfreq<-sapply(freq, length)  #freq���� �� �ܾ��� �󵵼�(����) ǥ��

nwords<-length(sfreq)  # unique �ܾ��� ����
barplot(sfreq[round(0.95*nwords):nwords]) #������ ��Ÿ�� �ܾ��� �󵵼��� ���� 5%�� plotting
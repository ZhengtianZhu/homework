clear;
clc;
%M/M/1�Ŷ�ϵͳ����
SimTotal=input('�˿�����='); %����˿�������

%1 ���ú���ǰ��ָ��
Lambda=0.4;     %������Lambda��
Mu=0.9;         %������Mu��

%�����Թ˿���Ϊ�߽�
t_Arrive=zeros(1,SimTotal); 
t_Leave=zeros(1,SimTotal);
ArriveNum=zeros(1,SimTotal);
LeaveNum=zeros(1,SimTotal);

%�������ݣ����ù˿���
Interval_Arrive=-log(rand(1,SimTotal))/Lambda;%����ʱ����
Interval_Serve=-log(rand(1,SimTotal))/Mu;%����ʱ��

%2 ���ݷ���ͼȥģ�����
t_Arrive(1)=Interval_Arrive(1);%�˿� ����ʱ��
ArriveNum(1)=1;
for i=2:SimTotal
    t_Arrive(i)=t_Arrive(i-1)+Interval_Arrive(i);%��ͣ����ֵȥ����
    ArriveNum(i)=i;
end

%ͬ�����Ƶ�˼·
t_Leave(1)=t_Arrive(1)+Interval_Serve(1);%�˿� �뿪ʱ��
LeaveNum(1)=1;
for i=2:SimTotal
    if t_Leave(i-1)<t_Arrive(i)
        t_Leave(i)=t_Arrive(i)+Interval_Serve(i);
    else
        t_Leave(i)=t_Leave(i-1)+Interval_Serve(i);
    end
    LeaveNum(i)=i;
end

t_Wait=t_Leave-t_Arrive; %���˿� ��ϵͳ�еĵȴ�ʱ�䣻��������
t_Wait_avg=mean(t_Wait);
t_Queue=t_Wait-Interval_Serve;%���˿���ϵͳ�е��Ŷ�ʱ��
t_Queue_avg=mean(t_Queue);

Timepoint=[t_Arrive,t_Leave];%ϵͳ�й˿�����ʱ��ı仯
Timepoint=sort(Timepoint);

ArriveFlag=zeros(size(Timepoint));%����ʱ���־
CusNum=zeros(size(Timepoint));
temp=2;
CusNum(1)=1;
for i=2:length(Timepoint)
    if (temp<=length(t_Arrive))&&(Timepoint(i)==t_Arrive(temp))
        CusNum(i)=CusNum(i-1)+1;
        temp=temp+1;
        ArriveFlag(i)=1;
    else
        CusNum(i)=CusNum(i-1)-1;
    end
end

%ϵͳ��ƽ���˿�������
Time_interval=zeros(size(Timepoint));
Time_interval(1)=t_Arrive(1);
for i=2:length(Timepoint)
    Time_interval(i)=Timepoint(i)-Timepoint(i-1);
end
CusNum_fromStart=[0 CusNum];
CusNum_avg=sum(CusNum_fromStart.*[Time_interval 0] )/Timepoint(end);

QueLength=zeros(size(CusNum));
for i=1:length(CusNum)
    if CusNum(i)>=2
        QueLength(i)=CusNum(i)-1;
    else
        QueLength(i)=0;
    end
end
QueLength_avg=sum([0 QueLength].*[Time_interval 0] )/Timepoint(end);%ϵͳƽ���ȴ��ӳ�

%����ͼ
figure(1);
set(1,'position',[0,0,1000,700]);
subplot(2,2,1);

stairs([0 ArriveNum],[0 t_Arrive],'b');
title('���˿͵���ʱ�����ȥʱ��');
xlabel('�˿���');
hold on;
stairs([0 LeaveNum],[0 t_Leave],'r');
legend('����ʱ��','��ȥʱ��');
hold off;

subplot(2,2,2);
stairs(Timepoint,CusNum,'b')
title('ϵͳ�ȴ��ӳ��ֲ�');
xlabel('ʱ��');
ylabel('�ӳ�');

subplot(2,2,3);

stairs([0 ArriveNum],[0 t_Queue],'b');
title('���˿���ϵͳ�е��Ŷ�ʱ��͵ȴ�ʱ��');
hold on;
stairs([0 LeaveNum],[0 t_Wait],'r');
hold off;
legend('�Ŷ�ʱ��','�ȴ�ʱ��');
xlabel('�˿���');

% ����ֵ������ֵ�Ƚ�
% disp([num2str(1/(Mu-Lambda))]);
% disp([num2str(Lambda/(Mu*(Mu-Lambda)))]);
% disp([num2str(Lambda/(Mu-Lambda))]);
% disp([num2str(Lambda*Lambda/(Mu*(Mu-Lambda)))]);
% 
% disp([num2str(t_Wait_avg)])
% disp([num2str(t_Queue_avg)])
% disp([num2str(CusNum_avg)]);
% disp([num2str(QueLength_avg)]);

% ����ֵ������ֵ�Ƚ�
disp(['����ƽ���ȴ�ʱ��t_Wait_avg=',num2str(1/(Mu-Lambda))]);
disp(['����ƽ���Ŷ�ʱ��t_Wait_avg=',num2str(Lambda/(Mu*(Mu-Lambda)))]);
disp(['����ϵͳ��ƽ���˿���=',num2str(Lambda/(Mu-Lambda))]);
disp(['����ϵͳ��ƽ���ȴ��ӳ�=',num2str(Lambda*Lambda/(Mu*(Mu-Lambda)))]);

disp(['����ƽ���ȴ�ʱ��t_Wait_avg=',num2str(t_Wait_avg)])
disp(['����ƽ���Ŷ�ʱ��t_Queue_avg=',num2str(t_Queue_avg)])
disp(['����ϵͳ��ƽ���˿���=',num2str(CusNum_avg)]);
disp(['����ϵͳ��ƽ���ȴ��ӳ�=',num2str(QueLength_avg)]);


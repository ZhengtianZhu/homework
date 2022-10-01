clear;
clc;
%M/M/1排队系统仿真
SimTotal=input('顾客总数='); %仿真顾客总数；

%1 设置好了前提指标
Lambda=0.4;     %到达率Lambda；
Mu=0.9;         %服务率Mu；

%都是以顾客数为边界
t_Arrive=zeros(1,SimTotal); 
t_Leave=zeros(1,SimTotal);
ArriveNum=zeros(1,SimTotal);
LeaveNum=zeros(1,SimTotal);

%根据数据，设置顾客流
Interval_Arrive=-log(rand(1,SimTotal))/Lambda;%到达时间间隔
Interval_Serve=-log(rand(1,SimTotal))/Mu;%服务时间

%2 根据仿真图去模拟计算
t_Arrive(1)=Interval_Arrive(1);%顾客 到达时间
ArriveNum(1)=1;
for i=2:SimTotal
    t_Arrive(i)=t_Arrive(i-1)+Interval_Arrive(i);%不停代入值去计算
    ArriveNum(i)=i;
end

%同上类似的思路
t_Leave(1)=t_Arrive(1)+Interval_Serve(1);%顾客 离开时间
LeaveNum(1)=1;
for i=2:SimTotal
    if t_Leave(i-1)<t_Arrive(i)
        t_Leave(i)=t_Arrive(i)+Interval_Serve(i);
    else
        t_Leave(i)=t_Leave(i-1)+Interval_Serve(i);
    end
    LeaveNum(i)=i;
end

t_Wait=t_Leave-t_Arrive; %各顾客 在系统中的等待时间；矩阵算术
t_Wait_avg=mean(t_Wait);
t_Queue=t_Wait-Interval_Serve;%各顾客在系统中的排队时间
t_Queue_avg=mean(t_Queue);

Timepoint=[t_Arrive,t_Leave];%系统中顾客数随时间的变化
Timepoint=sort(Timepoint);

ArriveFlag=zeros(size(Timepoint));%到达时间标志
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

%系统中平均顾客数计算
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
QueLength_avg=sum([0 QueLength].*[Time_interval 0] )/Timepoint(end);%系统平均等待队长

%仿真图
figure(1);
set(1,'position',[0,0,1000,700]);
subplot(2,2,1);

stairs([0 ArriveNum],[0 t_Arrive],'b');
title('各顾客到达时间和离去时间');
xlabel('顾客数');
hold on;
stairs([0 LeaveNum],[0 t_Leave],'r');
legend('到达时间','离去时间');
hold off;

subplot(2,2,2);
stairs(Timepoint,CusNum,'b')
title('系统等待队长分布');
xlabel('时间');
ylabel('队长');

subplot(2,2,3);

stairs([0 ArriveNum],[0 t_Queue],'b');
title('各顾客在系统中的排队时间和等待时间');
hold on;
stairs([0 LeaveNum],[0 t_Wait],'r');
hold off;
legend('排队时间','等待时间');
xlabel('顾客数');

% 仿真值与理论值比较
% disp([num2str(1/(Mu-Lambda))]);
% disp([num2str(Lambda/(Mu*(Mu-Lambda)))]);
% disp([num2str(Lambda/(Mu-Lambda))]);
% disp([num2str(Lambda*Lambda/(Mu*(Mu-Lambda)))]);
% 
% disp([num2str(t_Wait_avg)])
% disp([num2str(t_Queue_avg)])
% disp([num2str(CusNum_avg)]);
% disp([num2str(QueLength_avg)]);

% 仿真值与理论值比较
disp(['理论平均等待时间t_Wait_avg=',num2str(1/(Mu-Lambda))]);
disp(['理论平均排队时间t_Wait_avg=',num2str(Lambda/(Mu*(Mu-Lambda)))]);
disp(['理论系统中平均顾客数=',num2str(Lambda/(Mu-Lambda))]);
disp(['理论系统中平均等待队长=',num2str(Lambda*Lambda/(Mu*(Mu-Lambda)))]);

disp(['仿真平均等待时间t_Wait_avg=',num2str(t_Wait_avg)])
disp(['仿真平均排队时间t_Queue_avg=',num2str(t_Queue_avg)])
disp(['仿真系统中平均顾客数=',num2str(CusNum_avg)]);
disp(['仿真系统中平均等待队长=',num2str(QueLength_avg)]);


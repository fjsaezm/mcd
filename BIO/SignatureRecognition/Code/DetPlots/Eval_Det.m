function [EER,DCF_opt,ThresEER]=Eval_Footstep_Det11(true_scores,impostor_scores,color)
%------------------------------
%load speaker detection output scores
%load true_scores
%load impostor_scores

%------------------------------
%initialize the DCF parameters
Set_DCF (10, 1, 0.01);

%------------------------------
%compute Pmiss and Pfa from experimental detection output scores
[P_miss,P_fa] = Compute_DET (true_scores, impostor_scores);

[EER,posmin]=min(abs(P_miss-P_fa)+P_fa);
EER=min(abs(P_miss-P_fa)+P_fa)*100;
ScoresTab=sort([true_scores impostor_scores]);
ThresEER=ScoresTab(posmin);
%------------------------------
%plot results

% Set tic marks
Pmiss_min = 0.005;
Pmiss_max = 0.62;
Pfa_min = 0.005;
Pfa_max = 0.62;
Set_DET_limits(Pmiss_min,Pmiss_max,Pfa_min,Pfa_max);

%call figure, plot DET-curve
%figure;
Plot_DET (P_miss, P_fa,color);
%title ('Footstep Detection Performance');
hold on;

%find lowest cost point and plot
C_miss = 10;
C_fa = 1;
P_target = 0.01;
Set_DCF(C_miss,C_fa,P_target);
[DCF_opt Popt_miss Popt_fa] = Min_DCF(P_miss,P_fa);
Plot_DET (P_miss(posmin),P_fa(posmin),'ko');
%Plot_DET (P_miss(ThresEER),P_fa(ThresEER),'ko');
%Plot_DET (Popt_miss,Popt_fa,'ko');
hold on;



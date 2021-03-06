


f_s = 200;
selected_user = 7;
selected_session = 3;
selected_sign = 1;

BiosecurID=load(['./DB/u10', sprintf('%02d',selected_user) ,'s000', num2str(selected_session), '_sg000', num2str(selected_sign), '.mat']);

seconds = length(BiosecurID.x)/f_s
step = 1.0/f_s
t_axis = 0:step:seconds-step;

length(t_axis)
length(BiosecurID.x)

figure;
% x function of y
hold on;
title("x as function of y");
xlabel('y') 
ylabel('x') 
plot(BiosecurID.y, BiosecurID.x, 'Color','black');
hold off;

figure;
% x function of t
hold on;
title("x as function of time");
xlabel('time') 
ylabel('x') 
plot(t_axis, BiosecurID.x, 'Color','black');
hold off;

figure;
% y function of t
hold on;
title("y as function of time");
xlabel('time') 
ylabel('p') 
plot(t_axis, BiosecurID.y, 'Color','black');
hold off;

figure;
% p function of t
hold on;
title("p as function of time");
xlabel('time') 
ylabel('p') 
plot(t_axis, BiosecurID.p, 'Color','black');
hold off;
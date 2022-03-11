


f_s = 200;
selected_user = 7;
selected_session = 2;
selected_sign = 1;

BiosecurID=load(['./DB/u10', sprintf('%02d',selected_user) ,'s000', num2str(selected_session), '_sg000', num2str(selected_sign), '.mat']);

% x function of y
hold on;
title("x as function of y");
xlabel('y') 
ylabel('x') 
plot(BiosecurID.y, BiosecurID.x, 'Color','black');
hold off;


% x function of y
hold on;
title("x as function of y");
xlabel('y') 
ylabel('x') 
plot(BiosecurID.y, BiosecurID.x, 'Color','black');
hold off;
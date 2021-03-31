r = 10;
thetad = linspace(0,180,10);
x = r*cosd(thetad);y = r*sind(thetad);
figure;plot(x,y,'o');axis image;hold on;
output = RefineCurveData([x;y]);
plot(output(1,:),output(2,:),'*');axis image;
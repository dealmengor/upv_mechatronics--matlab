function out = Plot_Robot(PtosControl,path,x,y,theta,decim)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
figure1 = figure('Color',[1 1 1]);

plot(path(:,1), path(:,2));
hold on
plot(x, y);

%Representación de los puntos de control
plot(PtosControl(:,1),PtosControl(:,2),'ro');
plot(PtosControl(:,1),PtosControl(:,2),'g--');

title('Seguimiento de trayectoria ejemplo');
xlabel('X');
ylabel('Y');
Total_c = (length(x)-1);

for i=1:decim:Total_c
    quiver(x(i),y(i),100*cos(theta(i)),100*sin(theta(i)),'LineWidth',2,...
    'Color',[0.850980401039124 0.325490206480026 0.0980392172932625]);
    drawnow;
    espera(20*decim); %Espera en milisegundos, para simular tiempo real
end
out = 1;
end


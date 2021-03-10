PtosControl =[300 200;800 1000;300 600];  %las unidades son en milimetros

Ts = 0.02; % Tiempo de muestreos 20ms

Total_t = 4; %Segundos

%Generamos la curva
patht = SplineCubicaNatural3Puntos(PtosControl,Ts,Total_t);

% Dibujamos el resultado junto con los puntos de control
figure1 = figure('Color',[1 1 1]);
%Representación de La trayectoria
plot(patht(:,1), patht(:,2));
hold on
%Representación de los puntos de control
plot(PtosControl(:,1),PtosControl(:,2),'ro');
plot(PtosControl(:,1),PtosControl(:,2),'g--');
% Titulo y nombres en ejes
title('Seguimiento de trayectoria ejemplo');
xlabel('X');
ylabel('Y');
% Prueba de las funciones de generación de curvas
close all;
clc;
clear all;

%Parametros del controlador PV
Kx = 5;
Ky = 5;
e = 100;

PtosControl = [0 0; 500 1000;1000 0 ];  %las unidades son en milimetros
%PtosControl = [200 -200; 800 1000; 1500 500; 0 600 ];  %las unidades son en milimetros
%PtosControl = [0 0;0 800;600 400;0 400];  %las unidades son en milimetros

Ts = 0.02; % Tiempo de muestreos 20ms

% Para la trayectoria de 3 puntos, 5seg esta bien para Bezier3pts,
% Spline3pts 8 segundos
Total_t = 5; %Segundos
% La trayectoria de 4 puntos es mas larga y necesita mas tiempo.
%Total_t = 20; %Segundos
T_final = 1.2*Total_t;

%Crear la trayectoria a partir de los puntos utilizando las funciones de la
%practica 1
patht = CurvaBezier3Puntos(PtosControl,Ts,Total_t);
%patht = CurvaBezier4Puntos(PtosControl,Ts,Total_t);
%patht = SplineCubicaNatural3Puntos(PtosControl,Ts,Total_t);
%patht = SplineCubicaNatural4Puntos(PtosControl,Ts,Total_t);

% Calculamos la derivada de la trayectoria 
diff_patht = (patht(2:end,:) - patht(1:end-1,:))./Ts;
diff_patht = [diff_patht; diff_patht(end,:)];

% Generamos el tiempo para enviar al simulink la Trayectoria
t =( 0:Ts:(length(diff_patht)-1)*Ts )';
%plot(t,[patht diff_patht])
Trayectoria = [t, patht, diff_patht];
%%
%Condiciones iniciales
%theta_init = atan(0.5);
theta_init = pi/4;
% Para empezar deslocalizado del punto descentralizado (cuando la trayectoria a seguir empieza en 0,0)
x_init = -e*cos(theta_init);
y_init = -e*sin(theta_init);

sim('Control_Trayectoria');

%%
decimation = 20;
Plot_Robot(PtosControl,patht,x,y,theta,decimation);




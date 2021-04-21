clear all 
global giroA_v;
global giroC_v;
global tiempo_v; 

giroA_v = 0;
giroC_v = 0;
tiempo_v = 0;

ejecutarCodigoNXC testEncoders

% Gráfico de Motores
hold on
plot(tiempo_v(1:length(giroA_v)), giroA_v); % Motor A
plot(tiempo_v(length(giroA_v):end), giroC_v); % Motor C
title('Motores')
xlabel('Tiempo(s)')
ylabel('Grados de Giro')
hold off
grid on;
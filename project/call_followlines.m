%Limpiar Variables del Workspace
clear all

disp('Ejecución del modelo de ev3 en CoppeliaSim. Cambie a la ventana del simulador');
pause(2);

%Declaracion global de variables
global intensity_v;
global tiempo_v;

%Inicialización de variables
intensity_v = 0;
tiempo_v = 0;
disp('--------SEGUIMIENTO TRAYECTORIA--------');

ejecutarCodigoNXC followlines

%Representar la referencia y la estimación de la posición que hace el robot
hold on
plot(tiempo_v,intensity_v)
title('Comportamiento del Siguelíneas')
ylabel('Intensidad')
xlabel('Tiempo')
hold off
grid on;
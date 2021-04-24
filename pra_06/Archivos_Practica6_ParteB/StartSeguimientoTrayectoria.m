disp('Ejecución del modelo de ev3 en CoppeliaSim. Cambie a la ventana del simulador');
pause(2);

global datos;
datos = [];

disp('--------SEGUIMIENTO TRAYECTORIA--------');
ejecutarCodigoNXC SeguimientoTrayectoria

%Declaración de Variables
xref = datos(:,1);
yref = datos(:,2);
x = datos(:,3);
y = datos(:,4);
error_cua_medio = mean(datos(:,5)) %Mostrar el error cuadrático

%Representar la referencia y la estimación de la posición que hace el robot

hold on
plot(xref,yref); % Trayectoria de Referencia
plot(x,y); % Datos Medidos del Robot
title('Trayectorias')
xlabel('Abcisas')
ylabel('Ordenadas')
hold off
grid on;

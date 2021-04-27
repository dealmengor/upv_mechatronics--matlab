%Declaracion global de variables
global intensity_v;
global tiempo_v;
%Inicialización de variables
intensity_v = 0;
tiempo_v = 0;
tiempo = 0;
% Informamos que el sensor de color está en el puerto 1
SetSensorLight(IN_1);
% Definimos la velocidad de avance nominal
v = 15;

% Mostramos por pantalla
TextOut(0,LCD_LINE1,'Seguidor de lineas');
TextOut(0,LCD_LINE2,'Presione el boton central para');
TextOut(0,LCD_LINE3,'comenzar');
% Esperamos a pulsar el botón central
while(~ButtonPressed(BTNCENTER))end
% Borramos la pantalla del robot 
ClearScreen();

% Avanzamos con velocidad v en las dos ruedas (OUT_AC)
OnFwd(OUT_AC, v);
% para dar velocidad individualmente a cada rueda utilizar
% OnFwd(OUT_A, vl); rueda izquierda
% OnFwd(OUT_C, vr); rueda derecha


%Mientras no se presione el botón hacia abajo
while(~ButtonPressed(BTNEXIT)) 
    % Leemos el sensor  
    intensity = Sensor(IN_1);
    % Incrementamos el tiempo (período de muestreo 50ms)
	    tiempo = tiempo + 0.05; 
    intensity_v = [intensity_v intensity];
    tiempo_v = [tiempo_v tiempo];
    cadena = ['intensidad = ' num2str(intensity)];
    TextOut(0,LCD_LINE1,cadena);
end
% paramos los motores    
Off(OUT_AC); 
% paramos la comunicación con Coppeliasim
Stop(1);

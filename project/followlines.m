%Declaracion e inicialización de variables
global intensity_v;
global tiempo_v;

sentinel = 0;
gray = 45;
kp = 0;
b = 0.1213;
intensity_v = 0;
tiempo_v = 0;
tiempo = 0;

%Sensor
% Informamos que el sensor de color está en el puerto 1
SetSensorLight(IN_1);
Off(OUT_AC); % paramos los motores  

% Definimos la velocidad de avance nominal
v = 3;
    
%% Interfaz Lego-V3 || Esperar al botón central de robot para empezar 
TextOut(0,LCD_LINE1,'Proyecto Seguidor de Caminos'); % Mostramos por pantalla el tipo de test
TextOut(0,LCD_LINE3,'Presione el boton central');
TextOut(0,LCD_LINE4,'para que Wall-E comience');
TextOut(0,LCD_LINE5,'MECATRONICA 2020-2021');
TextOut(0,LCD_LINE7,'Devs: Alexander & Juan');
while(~ButtonPressed(BTNCENTER))end % Esperamos a pulsar el boton central
ClearScreen();

% Esperamos a que se active el sensor
pause(0.06);

% Avanzamos con velocidad v en las dos ruedas (OUT_AC)
OnFwd(OUT_AC, v);

%Mientras no se presione el botón hacia abajo
while(~ButtonPressed(BTNEXIT)) 
    % Leemos el sensor  
    intensity = double(Sensor(IN_1));
    % Incrementamos el tiempo (período de muestreo 50ms)
	tiempo = tiempo + 0.05; 
    % Registros de tiempo e intensidad
    intensity_v = [intensity_v intensity];
    tiempo_v = [tiempo_v tiempo];
    %Tablero de Parámetros
    str = ['Intensidad: ' num2str(intensity)];
    TextOut(0,LCD_LINE2,str);
    str2 = ['Velocidad: ' num2str(v)];
    TextOut(0,LCD_LINE3,str2);
    str3 = ['Ganancia(kp): ' num2str(kp)];
    TextOut(0,LCD_LINE4,str3);
    str4 = ['Tiempo de Recorrido: ' num2str(tiempo)];
    TextOut(0,LCD_LINE5,str4);
    
    %Control de Flujo de Programa
    switch sentinel
    %Encuentra la línea y sale del modo alcance
    case 0
        if intensity >= 39 && intensity <= gray      
            Off(OUT_AC); % paramos los motores  
            sentinel = 1;
        end
    %Aguarda Instrucciones
    case 1
        TextOut(0,LCD_LINE1,'Presione el boton central');
        while(~ButtonPressed(BTNCENTER))end % Esperamos a pulsar el boton central
        sentinel = 2;
        tiempo_sentinel_2 = tiempo;
        ClearScreen();
    %Inicia el modo de seguimiento
    case 2
        %Velocidad de Crucero
        if intensity >= 46 
            v = 50;
            kp = 10;
        end
        %Bajar velocidad en curvas
        if intensity >= 25 && intensity <= 39
            v = 20;
            kp = 15;
        end
        [out_av, out_cv] = controlerLine(gray, intensity, kp, b, v);
        % Se asignan velocidades de los motores
        OnFwd(OUT_A, out_av); %rueda izquierda
        OnFwd(OUT_C, out_cv); %rueda derecha
    end
end

%Se apagan motores       
Off(OUT_AC);

%Se detiene la comunicación con Coppeliasim
Stop(1);
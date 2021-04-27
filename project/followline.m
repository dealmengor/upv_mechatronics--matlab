%Declaracion global de variables
global intensity_v;
global tiempo_v;
%% Inicialización de variables
found = 0;
gray = 45;
kp = 5;
b = 0.1213;
intensity_v = 0;
tiempo_v = 0;
tiempo = 0;

%Sensor
% Informamos que el sensor de color está en el puerto 1
SetSensorLight(IN_1);

% Definimos la velocidad de avance nominal
v = 3;

%% Esperar al botón central de robot para empezar
TextOut(0,LCD_LINE1,'Seguimiento trayectoria'); % Mostramos por pantalla el tipo de test
TextOut(0,LCD_LINE2,'Armando-Enrique'); % Integrantes
TextOut(0,LCD_LINE3,'Presione el boton central');
TextOut(0,LCD_LINE4,'para comenzar');
TextOut(0,LCD_LINE7,'MECATRONICA 2020-2021');
while(~ButtonPressed(BTNCENTER))end % Esperamos a pulsar el boton central
ClearScreen();

% Avanzamos con velocidad v en las dos ruedas (OUT_AC)
OnFwd(OUT_AC, v);

%Mientras no se presione el botón hacia abajo
while(~ButtonPressed(BTNEXIT)) 
    
    % Leemos el sensor  
    intensity = double(Sensor(IN_1));
    % Incrementamos el tiempo (período de muestreo 50ms)
	tiempo = tiempo + 0.05; 
    intensity_v = [intensity_v intensity];
    tiempo_v = [tiempo_v tiempo];
    
    %Indicador de Parámetros
    cadena = ['Intensidad = ' num2str(intensity)];
    TextOut(0,LCD_LINE2,cadena);
    cadena2 = ['Velocidad = ' num2str(v)];
    TextOut(0,LCD_LINE3,cadena2);
    cadena3 = ['Ganancia(k) = ' num2str(kp)];
    TextOut(0,LCD_LINE4,cadena3);
    
    if tiempo > 0.06
        %Encuentra la línea y sale del modo alcance
        if found == 0 && intensity >= 39 && intensity <= gray 
            % paramos los motores       
            Off(OUT_AC);
            found = 1;
        end
        %Aguarda Instrucciones
        if found == 1
            TextOut(0,LCD_LINE1,'Presione el boton central');
            while(~ButtonPressed(BTNCENTER))end % Esperamos a pulsar el boton central
            found = 2;
            ClearScreen();
        end
        %Inicia el modo de seguimiento
        if found == 2
            [vl, vr] = controlerLine(gray, intensity, kp,b,v);
            OnFwd(OUT_A, vl); %rueda izquierda
            OnFwd(OUT_C, vr); %rueda derecha
        end
        %Velocidad Crucero
        if found == 2 && intensity >= 46 && intensity <= 65
            v = 25;
        end
        
        %Bajar velocidad en curvas
        if found == 2 && intensity >= 0 && intensity <= 39
            v = 8;
        end

    end

end

%Se apagan motores       
Off(OUT_AC);

%Se detiene la comunicación con Coppeliasim
Stop(1);
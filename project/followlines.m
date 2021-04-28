%Declaracion e inicialización de variables
global intensity_v;
global tiempo_v;

gray = 45;
kp = 0;
b = 0.1213;
intensity_v = 0;
tiempo_v = 0;
tiempo = 0;
program_flow_sentinel = 0;
speed_force_sentinel = 1;
automatic = true;

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
TextOut(0,LCD_LINE5,'el MODO ALCANCE');
TextOut(0,LCD_LINE6,'MECATRONICA 2020-2021');
TextOut(0,LCD_LINE8,'Devs: Alexander & Juan');
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

    %Alternador de Modos
    if (ButtonPressed(BTNCENTER))
        if speed_force_sentinel == 0
            speed_force_sentinel = 1;
        else
            speed_force_sentinel = 0;
        end
    end

    %Interfaz EV3
    if program_flow_sentinel == 1
        TextOut(0,LCD_LINE2,'Modo: Alcance');
    elseif automatic == true
        TextOut(0,LCD_LINE2,'Modo: Seguimiento Auto');
    else
        TextOut(0,LCD_LINE2,'Modo: Seguimiento Manual');
    end
    if speed_force_sentinel == 0
        TextOut(0,LCD_LINE3,'Control: Velocidad');
    else
        TextOut(0,LCD_LINE3,'Control: Ganancia');
    end
    %Tablero de Parámetros
    str = ['Intensidad: ' num2str(intensity)];
    TextOut(0,LCD_LINE4,str);
    str2 = ['Velocidad: ' num2str(v)];
    TextOut(0,LCD_LINE5,str2);
    str3 = ['Ganancia(kp): ' num2str(kp)];
    TextOut(0,LCD_LINE6,str3);
    str4 = ['Tiempo de Recorrido: ' num2str(tiempo)];
    TextOut(0,LCD_LINE7,str4);

    %Controlador de Velocidad y Ganancias 
    switch speed_force_sentinel
        %Se altera la velocidad
        case 0
        if (ButtonPressed(BTNLEFT)) %Disminuye velocidad
            v = v - 0.01;
            automatic = false;
        end
        if (ButtonPressed(BTNRIGHT)) %Aumenta velocidad
            v = v + 0.01;
            automatic = false;
        end
        %Se altera la ganancia
        case 1
        if (ButtonPressed(BTNLEFT)) %Disminuye ganancia
            kp = kp - 0.01;
            automatic = false;
        end
        if (ButtonPressed(BTNRIGHT)) %Aumenta ganancia
            kp = kp + 0.01;
            automatic = false;
        end
    end

    %Controlador principal de Flujo de Programa
    switch program_flow_sentinel
    %Encuentra la línea y sale del modo alcance
    case 0
        if intensity >= 39 && intensity <= gray      
            Off(OUT_AC); % paramos los motores  
            program_flow_sentinel = 1;
        end
    %Aguarda Instrucciones
    case 1
        TextOut(0,LCD_LINE2,'Presione el boton central');
        TextOut(0,LCD_LINE3,'para MODO SEGUIMIENTO');
        while(~ButtonPressed(BTNCENTER))end % Esperamos a pulsar el boton central
        program_flow_sentinel = 2;
        ClearScreen();
    %Inicia el modo de seguimiento
    case 2
        if automatic == true
            %Velocidad de Crucero
            if intensity >= 46 
                v = 50;
                kp = 5;
            end
            %Bajar velocidad en curvas
            if intensity >= 25 && intensity <= 39 
                v = 10;
                kp = 6;
            end
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
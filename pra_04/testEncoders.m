global giroA_v;
global giroC_v;
global tiempo_v;

%Inicialización de variables
giroA_v = 0;
giroC_v = 0;
tiempo_v = 0;
tiempo = 0;
Ts = 0.05; %50ms
velocidad = 10;

%Pantalla del Robot
TextOut(0,LCD_LINE1,'Test Encoders'); % Mostramos por pantalla el tipo de test
TextOut(0,LCD_LINE2,'Presione el boton central para');
TextOut(0,LCD_LINE3,'comenzar con el test');
while(~ButtonPressed(BTNCENTER))end % Esperamos a pulsar el boton intro
ClearScreen(); 

%Test Encoder A
TextOut(0,LCD_LINE1,'Encoder A');
ResetRotationCount(OUT_A); %Reseteamos el encoder A
giro = MotorRotationCount(OUT_A); % Medido en grados
OnFwd(OUT_A, velocidad); % Giramos el motor A

giroA_v = giro;
while (giro < 1000) % Se ejecuta mientras no haya llegado a 1000 grados
    t1 = double(CurrentTick());
    tiempo_v = [tiempo_v tiempo];
    giro = MotorRotationCount(OUT_A); 
    NumOut(0, LCD_LINE2, giro);
    giroA_v = [giroA_v giro];
    
    t2 = double(CurrentTick());
    %Esperar hasta siguiente periodo
    espera = (max(0, Ts * 1000 - (t2 - t1)));
    Wait(espera);
    tiempo = tiempo + Ts;
end

NumOut(0, LCD_LINE2, giro);
Off(OUT_A); %Parar motor A
Wait(1000);
ResetRotationCount(OUT_A); %Reseteamos encoder
giro = MotorRotationCount(OUT_A);
TextOut(0, LCD_LINE2, 'reseteado');
NumOut(0, LCD_LINE3, giro);
Wait(1000);
ClearScreen();

% Test Encoder C
TextOut(0, LCD_LINE1, 'Encoder B');
ResetRotationCount(OUT_C); %Reseteamos el encoder C
giro = MotorRotationCount(OUT_C); %Medido en grados
OnFwd(OUT_C, velocidad); % Giramos motor C

while (giro < 1000) 
    t1 = double(CurrentTick());
    tiempo_v = [tiempo_v tiempo];
    giro = MotorRotationCount(OUT_C);
    NumOut(0, LCD_LINE2, giro);
    giroC_v = [giroC_v giro];
    
    t2 = double(CurrentTick());
    %Esperar hasta siguiente periodo
    espera = (max(0, Ts * 1000 - (t2 - t1)));
    Wait(espera);
    tiempo = tiempo + Ts;
end

NumOut(0, LCD_LINE2, giro);
Off(OUT_C); %Parar motor C
Wait(1000);
ResetRotationCount(OUT_C); %Reset encoder C
giro = MotorRotationCount(OUT_C);
TextOut(0, LCD_LINE2, 'reseteado');
NumOut(0, LCD_LINE3, giro);
Wait(1000);
ClearScreen();
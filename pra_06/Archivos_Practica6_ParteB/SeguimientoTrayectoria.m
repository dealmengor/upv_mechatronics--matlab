%% Inicialización de variables
posruedaDerecha1 = 0; %Posición rueda derecha instante k-1
posruedaIzquierda1 = 0; %Posición rueda izquierda instante k-1
i = 0; %Iteración del bucle de control
x = 500.0; %Posición X inicial del robot (mm)
y = 0.0; %Posición Y inicial del robot (mm)
theta = 0; %Orientación inicial del robot (rad)
Tfinal = 30.0; %Duración de la prueba (s)
errorcua = 0.0; %Cálculo del error cuadrático

 

global datos; %Matriz donde se guardarán los datos

 

Ts = 0.05; %Periodo de muestreo (s)
radiorueda = 28; %Radio de la rueda (mm)
b = 60; %distancia medida a la mitad de la rueda y el centro del robot (mm)
e = 50; %distancia del centro del robot al punto descentralizado (mm)
kx = 2; %Ponderación seguimiento X
ky = 2; %Ponderación seguimiento Y
niteraciones=Tfinal/Ts; %Número de iteraciones del bucle de control

 

%% Esperar al botón central de robot para empezar
TextOut(0,LCD_LINE1,'Seguimiento trayectoria'); % Mostramos por pantalla el tipo de test
TextOut(0,LCD_LINE2,'Presione el boton central');
TextOut(0,LCD_LINE3,'para comenzar');
TextOut(0,LCD_LINE6,'MECATRONICA 2020-2021');
while(~ButtonPressed(BTNCENTER))end % Esperamos a pulsar el boton central
ClearScreen();

 

pause(1);

 

ResetRotationCount(OUT_A); % Reseteamos el encoder rueda izquierda
ResetRotationCount(OUT_C); % Reseteamos el encoder rueda derecha

 

 

 

%% Bucle de control

 

for i=0:niteraciones
    t1=double(CurrentTick());
   
    %% Selección de la trayectoria (descomentar la que corresponda)
    
    %---------------Trayectoria circular-------------------------------------
    % posicion y orientacion inicial: x=500.0, y=0.0, theta=pi/2;
    
    xref=500*cos(2*3.14159*0.04*0.05*i);
    yref=500*sin(2*3.14159*0.04*0.05*i);
    velxref=-500*2*3.14159*0.04*sin(2*3.14159*0.04*0.05*i);
    velyref=500*2*3.14159*0.04*cos(2*3.14159*0.04*0.05*i);
    
    %---------------Trayectoria infinito--------------------------------------
    % posicion y orientacion inicial: x=500.0, y=0.0, theta=pi/4;
    
%        xref=500*sin(2*3.14159*0.04*0.05*i)+500;
%        yref=250*sin(4*3.14159*0.04*0.05*i);
%        velxref=500*2*3.14159*0.04*cos(2*3.14159*0.04*0.05*i);
%        velyref=250*4*3.14159*0.04*cos(4*3.14159*0.04*0.05*i);

 

    %---------------Trayectoria cuadrada--------------------------------------
    % posicion y orientacion inicial: x=500.0, y=0.0, theta=0;
    
%     if (i < niteraciones/4)
%         xref=500+(1500-500)*i/(niteraciones/4);
%         yref=0;
%         velxref=(1500-500)/(niteraciones/4);
%         velyref=0;
%     elseif (i < niteraciones/2)
%         xref=1500;
%         yref=(1000-0)*(i-(niteraciones/4))/(niteraciones/4);
%         velxref=0;
%         velyref=(1000-0)/(niteraciones/4);
%     elseif (i < niteraciones*3/4)
%         xref=1500-(1500-500)*(i-2*(niteraciones/4))/(niteraciones/4);
%         yref=1000;
%         velxref=-(1500-500)/(niteraciones/4);
%         velyref=0;
%     else
%         xref=500;
%         yref=1000-(1000-0)*(i-3*(niteraciones/4))/(niteraciones/4);
%         velxref=0;
%         velyref=-(1000-0)/(niteraciones/4);
%     end 
   

 

    %% Seguimiento trayectoria punto descentralizado
    
    % obtenemos el valor de los encoders (grados) para ver cuanto se ha movido
    posruedaDerecha = double(MotorRotationCount(OUT_C));
    posruedaIzquierda = double(MotorRotationCount(OUT_A));
    
    % calculamos las velocidades angulares (rad/s) de las ruedas // CONVERTIR A RADIANES
    wdk= (posruedaDerecha - posruedaDerecha1)*(pi/180)*(1/Ts);
    wik= (posruedaIzquierda- posruedaIzquierda1)*(pi/180)*(1/Ts);%derivada Euler
    
    % calculamos las velocidades lineales (mm/s) de las ruedas: v = w*radio
    vdk= wdk * radiorueda;
    vik= wik * radiorueda;
    
   % calculamos la velocidad lineal del robot (mm/s)
    vk =(vdk+vik)/2; %promedio
    
    % calculamos la velocidad angular del robot (rad/s)
    wk = (vdk-vik)/(2*b);
    
    % estimamos la posicion X-Y (mm) y la orientacion del robot (rad)
    x=x + vk*Ts*cos(theta);
    y=y+vk*Ts*sin(theta);
    theta=theta+wk*Ts;
    
    % calculamos la velocidad del punto descentralizado a partir del control cinematico del robot (mm/s) %pag 18
    velxp= velxref + kx * (xref-(x+e*cos(theta)));
    velyp= velyref + ky * (yref-(y+e*sin(theta)));

 

    % calculamos las velocidades lineales de la ruedas que debera aplicar el robot a partir del modelo cinematico inverso del robot (mm/s) %pag17
    vi= (((e*cos(theta)+b*sin(theta))*velxp)+((e*sin(theta)-b*cos(theta))*velyp))*(1/e);
    vd= (((e*cos(theta)-b*sin(theta))*velxp)+((e*sin(theta)+b*cos(theta))*velyp))*(1/e);
    
    % calculamos las velocidades angulares de referencia para el control dinamico (rad/s)
    wref_d= vd/radiorueda;
    wref_i= vi/radiorueda;
   
    % mandamos las acciones de control a aplicar a cada rueda (en % actuación)
    OnFwd(OUT_C,((100*wref_d)/18.32)); % motor derecha
    OnFwd(OUT_A,((100*wref_i)/18.32)); % motor izquierda
    
    % almacenamos los valores de los encoder para la proxima iteracion
    posruedaDerecha1 = posruedaDerecha;
    posruedaIzquierda1 = posruedaIzquierda;
   
    % iteración
    i=i+1;
    
    % calculo indice integral error cuadratico
    ex= xref - x;
    ey= yref - y;
    errorcua= errorcua + (ex * ex+ ey * ey);

 

    %Guardar datos
    datos=[datos;xref yref x y errorcua];
    
    t2=double(CurrentTick());
    % Espera hasta el siguiente periodo
    espera=(max(0,Ts*1000-(t2-t1)));
    Wait(espera);
end

 

Stop(1);
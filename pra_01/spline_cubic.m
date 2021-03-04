% Spline Cúbica v2

function out = SplineCubicaNatural3Puntos(Puntos,incremento_real,tiempo_real)
% Función que calcula una trayectoria Curva Spline 3 puntos
% Puntos = [P0x P0y;P1x P1y;P2x P2y];
% Incremento Real = Tiempo de muestreo
% Tiempo Real = tiempo total de la trayectoria.

% Variables de Trabajo
out = [];
cantidad_puntos = length(Puntos);
num_tramos = cantidad_puntos-1;
inc = incremento_real / (tiempo_real / num_tramos);

% Cálculo de Derivadas
matriz_inversa = inv([2 1 0; 1 4 1; 0 1 2]); 
pts_x = Puntos(:,1);
pts_y = Puntos(:,2);

dx = matriz_inversa * [3 * (pts_x(2) - pts_x(1)); 3 * (pts_x(3) - pts_x(1)); 3 * (pts_x(3) - pts_x(2))];
dy = matriz_inversa * [3 * (pts_y(2) - pts_y(1)); 3 * (pts_y(3) - pts_y(1)); 3 * (pts_y(3) - pts_y(2))];

% Matriz SCN
a_x = pts_x(1);
b_x = dx(1,1);
c_x = 3 * (pts_x(2) - a_x ) - 2 * dx(1,1) - dx(2,1);
d_x = 2 * (a_x - pts_x(2)) + dx(1,1) + dx(2,1);

a_y = pts_y(1);
b_y = dy(1,1);
c_y = 3 * (pts_y(2) - a_y ) - 2 * dy(1,1) - dy(2,1);
d_y = 2 * (a_y - pts_y(2,1)) + dy(1,1) + dy(2,1);

matriz_scn = [a_x b_x c_x d_x; a_y b_y c_y d_y]

for t=0:inc:1
    matriz_tiempo = [1; t; t^2; t^3];
    r = matriz_scn * matriz_tiempo;
    out = cat(2,out,r);
end

end
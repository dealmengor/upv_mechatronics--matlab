function out = CurvaBezier3Puntos(Puntos, incremento_real, tiempo_real)
    % Función que calcula una trayectoria Curva Bezier 3 puntos
    % Puntos = [P0x P0y;P1x P1y;P2x P2y];
    % Incremento Real = Tiempo de muestreo
    % Tiempo Real = tiempo total de la trayectoria.
    matriz_tras = Puntos.';
    matriz_b = [1 -2 1; 0 2 -2; 0 0 1];
    out = [];

    for i = 0:incremento_real / tiempo_real:1
        matriz_tiempo = [1; i; i^2];
        bezier = matriz_tras * matriz_b * matriz_tiempo;
        out = cat(1, out, bezier.');
    end

end

%Punto A
function [m, b] = RectaPuntosExtremos(x, y)
    b = y(1);
    m = (y(end) - y(1)) / (x(end) - 1);
end

%Punto B
function [m, b] = RectaMinimosCuadrados(x, y)
    % Matriz de Regresión
    R = [ones(size(x)) x];
    bm = R / y;
    b = bm(1);
    m = bm(2);
end

%Punto C
function TestRecta
    %Vectores
    X = [0.0 0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0 5.5 6.0];
    Y = [12.0 9.5 7.0 5.2 4.0 3.1 2.7 2.0 1.5 1.0 0.5 0.2 0.1];

    %Puntos Extremos
    RectaPuntosExtremos(X, Y);
    y_extremos = m * X + b;
    plot(X, y_extremos)

    %Mínimos Cuadrados
    RectaMinimosCuadrados(X, Y);
    y_minimos = m * X + b;
    plot(X, y_minimos)
end

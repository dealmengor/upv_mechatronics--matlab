function [vl,vr] = controlerLine(gray, intensity, kp,b,v, sentinel)
    %Velocidad Angular proporcionada al error calculado
    e = gray - intensity;
    wk = kp*e;
    %Validación para seguimiento del giro
    if ~sentinel
        %Ajuste a las ruedas
        vl = v - b*wk; 
        vr = v + b*wk; 
    else
        vl = v + b*wk; 
        vr = v - b*wk;
    end
end

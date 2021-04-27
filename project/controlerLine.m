function [vl,vr] = controlerLine(gray, intensity, kp,b,v)

    %Velocidad Angular proporcionada al error calculado
    e = gray - intensity;
    wk = kp*e;
    
    %Ajuste a las ruedas
    vl = v - b*wk;
    vr = v + b*wk;
    
end

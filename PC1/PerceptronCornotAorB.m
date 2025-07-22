% Entrenar C or (not A or B)
clear all;
close all;
clc;

X = [0 0 0 0 1 1 1 1;
     0 0 1 1 0 0 1 1;
     0 1 0 1 0 1 0 1];
Y = [1 1 1 1 0 1 1 1];

% Verificar si la red es entrenable
fprintf('Verificar si la red es entrenable\n')
red = perceptron();
red = train(red, X, Y);
pesos = red.IW{1,1};
bias = red.b{1,1};

% Impresión de gráfico
plotpv(X, Y)
plotpc(pesos, bias)

fprintf('Se puede ver que la red es entrenable, por lo tanto se continua con el entrenamiento\n')

% Esquema y gráfico de red
fprintf('La red tiene un ER: 3x8-1x8\n')

% Gráfico de la red
view(red);

% Matrices representativas
% I = [I11 I12 I13 ... I18;
%      I21 I22 I23 ... I28
%      I31 I32 I33 ... I38]

% W = [W11; W21; W31] 
% B = [B1 B1 B1 ... B1]

% Uso detallado del algoritmo paso a paso
% Código UNI: 20240014H
alfa = 0.4; 
W = [-0.1; -0.1; 0.1]; 
B = 0.1; 
errores_matrix = []; 
epoch = 1; 
weigths = [];
bias = []; 

while true
    errores = zeros(1, size(X, 2));
    fprintf('Iniciando la época %d\n', epoch)
    for i = 1:size(X,2)
        % Selección del punto o entrada
        entrada = X(:, i);
        fprintf('La entrada seleccionada es: %d %d %d\n', entrada(1), entrada(2), entrada(3))
        
        % Calculo de la salida lineal
        linear = W' * entrada + B;
        fprintf('La salida lineal obtenida es %.3f\n', linear)

        % Se aplica la función de activación
        salida = hardlim(linear);
        fprintf('La salida con hardlim es %d\n', salida)
        fprintf('La salida esperada es: %d\n', Y(i))
        
        % Se calcula el error
        error = salida - Y(i);
        fprintf('Lo cual da un error de: %d\n', error)
        
        if error ~= 0
            errores(i) = 1; 
            % Actulización de pesos y bias
            W = W - alfa * error * entrada; 
            B = B - alfa * error;
            fprintf('Los pesos y bias se actualizan de la siguiente manera: \n')
            disp('Nuevos pesos')
            disp(W)
            disp('Nuevo bias')
            disp(B)
        else
            fprintf('Entonces no es necesario actualizar\n')
        end
    end
    % Recolectar número de errores en esta época
    errores_matrix = [errores_matrix, sum(errores)];

    % Almacenar los pesos y bias
    weigths = [weigths; W'];
    bias = [bias, B];
    
    % Mostrar la evolución de los planos cada 2 épocas
    if mod(epoch, 2) == 0
        figure
        plotpv(X, Y)
        hold on; 
        plotpc(weigths(size(weigths, 1), :), bias(size(weigths, 1)))
        title('Gráfico del PS en la época %d', epoch)
    end

    % Aumentar en uno el número de épocas
    epoch = epoch + 1; 

    % Criterio de parada
    if sum(errores) == 0
        break
    end
end

fprintf('Algoritmo terminado...\n')

% Número de épocas de entrenamiento
fprintf('El algoritmo se entrenó en %d épocas\n', epoch-1)

% Valores finales W y B
disp('Los pesos finales encontrados son:')
disp(W)
disp('El bias final es:')
disp(B)

% Puntos y plano de separación finales
figure
plotpv(X,Y)
hold on; 
plotpc(W', B)
title('Gráfica final de la red entrenada')

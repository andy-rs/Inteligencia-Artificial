%% Entrenar de forma manual A and (B or C) 
clear all;
close all; 
clc; 

X = [0 0 0 0 1 1 1 1;
     0 0 1 1 0 0 1 1;
     0 1 0 1 0 1 0 1]; 
Y = [0 0 0 0 0 1 1 1]; 

% Verificación de que la red es entrenable
fprintf('Verificando que la red es entrenable...\n')
red = perceptron();
red = configure(red, X, Y);

red.IW{1,1} = [0.1 -0.1 0.1]; 
red.b{1,1} = 0.1;
red.trainParam.lr = 0.4;

red = train(red, X, Y); 
pesos = red.IW{1,1};
bias = red.b{1,1};
plotpv(X, Y);
plotpc(pesos, bias)
fprintf('Se puede ver que la red es entrenable, por lo que se detallará el entrenamiento\n')

% Esquema de red
fprintf('La red tiene un esquema de red: 3x8-1x8\n')

% Gráfico de la red
view(red)

% Matrices representativas
fprintf('Las matrices representativas de la red son las siguientes:\n')
fprintf('Matriz de pesos\n')
fprintf('W = [W11; W21; W31]\n')
fprintf('Bias\n')
fprintf('B = [B1]\n')
fprintf('Entradas\n')
fprintf('I = [I11 I12 I13 ... I18;\n     I21 I22 I23 ... I28;\n     I31 I32 I33 ... I38]\n')

% Uso detallado del algoritmo paso a paso
% Código UNI: 20230014H
alfa = 0.4; 
W = [0.1; -0.1; 0.1]; 
B = 0.1; 
ecm = 0; 
ecm_matrix = []; 
epoch = 1; 
JE = size(X, 2); 
num_errores = []; 
weights = [];
bias = []; 

while true
    errores = zeros(1, JE);
    fprintf('Estamos en la época %d\n', epoch)
    for i = 1:JE
        % Selección del punto
        punto = X(:, i);
        fprintf('El punto seleccionado es: %d %d %d\n', punto)

        % Evaluación de la salida
        linear = W' * punto + B; 
        salida = hardlim(linear);
        fprintf('La salida lineal calculada es: %.4f\n', linear)
        fprintf('La salida con hardlim es: %d\n', salida)

        % Cálculo del error
        fprintf('La salida esperada es: %d\n', Y(i))
        error = salida - Y(i);
        fprintf('Esto da un error de: %d\n', error)

        % Error diferente de cero, actualizar
        if error ~= 0
            fprintf('Como este error es diferente de cero, se actualizan pesos y bias\n')
            errores(i) = 1; 
            W = W - alfa * error * punto; 
            B = B - alfa * error;
            fprintf('Nuevos pesos\n')
            disp(W)
            fprintf('Nuevos bias\n')
            disp(B)
        else
        % Error igual a cero, no actualizar
            fprintf('Entonces no se actualiza\n')
        end
    end
    % Guardar los pesos y bias de esta generación
    weights = [weights; W']; 
    bias = [bias, B]; 

    % Guardar el número de errores de esta época
    num_errores = [num_errores sum(errores)]; 

    % Verificación de que la red está entrenada
    if sum(errores) == 0
        fprintf('No se detectaron errores, la red está entrenada!\n')
        break
    end
    
    % Mostrar la evolución de los PS
    if mod(epoch, 3) == 0
        figure
        plotpv(X, Y)
        hold on; 
        plotpc(weights(epoch-1,:), bias(epoch-1))
        plotpc(weights(epoch,:), bias(epoch))
    end

    % Sumar una época
    epoch = epoch + 1; 
end

fprintf('Algoritmo de entrenamiento terminado...\n')

% Verificación de que la red está entrenada
s = hardlim(W' * X + B); 
fprintf('Verificación de que la red está entrenada\n')
fprintf('La salida esperada es:\n')
disp(Y)
fprintf('La salida obtenida es:\n')
disp(s)
fprintf('Con esto se ve que la red está entrenada!\n')

% Número de épocas de entrenamiento
fprintf('La red se entrenó en %d épocas, empezando en la época 1\n', epoch)
fprintf('Los pesos finales son\n')
disp(W)
fprintf('Los bias finales son\n')
disp(B)

% Gráfica del plano de separación final
figure
plotpv(X, Y)
hold on; 
plotpc(W', B)

% Gráfica de los errores según el número de épocas
figure
plot(1:epoch, num_errores)
title('Número de erores según la época')
xlabel('Época')
ylabel('Número de errores')


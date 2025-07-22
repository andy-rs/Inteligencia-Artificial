% Las vocales de las 10 primeras letras del abecedario
clear all;
close all;
clc;

A = [1 1 1 1 1 1 0 1 0 0 1 0 1 0 0 1 0 1 0 0 1 0 1 0 0 1 0 1 0 0 1 1 1 1 1];

% 1111111
% 1000001
% 1111111
% 1000001
% 1000001

B = [1 1 1 1 1 1 0 1 0 1 1 0 1 0 1 1 0 1 0 1 1 0 1 0 1 1 0 1 0 1 1 1 1 1 1]; 
% 1111111
% 1000001
% 1111111
% 1000001
% 1111111

C = [1 1 1 1 1 1 0 0 0 1 1 0 0 0 1 1 0 0 0 1 1 0 0 0 1 1 0 0 0 1 1 0 0 0 1]; 
% 1111111
% 1000000
% 1000000
% 1000000
% 1111111

D = [1 1 1 1 1 1 0 0 0 1 1 0 0 0 1 1 0 0 0 1 1 0 0 0 1 1 0 0 0 1 0 1 1 0 0]; 
% 1111110
% 1000001
% 1000001
% 1000000
% 1111110

E = [1 1 1 1 1 1 0 1 0 1 1 0 1 0 1 1 0 1 0 1 1 0 1 0 1 1 0 1 0 1 1 0 1 0 1]; 
% 1111111
% 1000000
% 1111111
% 1000000
% 1111111

F = [1 1 1 1 1 1 0 1 0 0 1 0 1 0 0 1 0 1 0 0 1 0 1 0 0 1 0 1 0 0 1 0 1 0 0];
% 1111111
% 1000000
% 1111111
% 1000000
% 1000000

G = [1 1 1 1 1 1 0 1 0 1 1 0 1 0 1 1 0 1 0 1 1 0 1 0 1 1 0 1 0 1 1 0 1 1 1]; 
% 1111111
% 1000000
% 1111111
% 1000001
% 1111111

H = [1 1 1 1 1 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 0 1 0 1 1 1 1 1]; 
% 1000001
% 1000001
% 1111111
% 1000001
% 1000001

I = [1 0 0 0 1 1 0 0 0 1 1 0 0 0 1 1 1 1 1 1 1 0 0 0 1 1 0 0 0 1 1 0 0 0 1]; 
% 1111111
% 0001000
% 0001000
% 0001000
% 1111111

J = [1 0 0 0 1 1 0 0 0 1 1 0 0 0 1 1 1 1 1 1 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0]; 
% 1111111
% 0001000
% 0001000
% 0001000
% 1111000

X = [A', B' , C', D', E', F', G', H', I', J']; 
Y = [1, 0, 0, 0, 1, 0, 0, 0, 1, 0]; 

% Codigo UNI: 20230014H
% Pesos y bias = +/- 0.1
% alfa = 0.4

% Esquema y gráfico de la red
fprintf('La red tiene un esquema: 35-10 x 1 x 10\n')

% Gráfico de la red
red = perceptron(); 
red = configure(red, X, Y); 
view(red)

% Uso detallado del algoritmo paso a paso
epoch = 1;
errores_globales = [];
alfa = 0.4; 
W = 0.1 * ones(size(X, 1), 1);
bias = -0.1;

while true
    errores = zeros(1, size(X,2)); 
    fprintf('Se esta iniciando la época: %d\n', epoch);

    for i = 1:size(X,2)
        % Calculo de la salida
        linear = W' * X(:,i) + bias; 
        salida = hardlim(linear); 
        fprintf('La salida obtenida es de %d\n', salida)
        fprintf('La salida esperada es de %d\n', Y(i))

        % Calculo del error
        error = salida - Y(i); 
        fprintf('Por lo tanto, se tiene un error de %d\n', error)
       
        % Si el error es diferente de cero, se actualiza
        if error ~= 0
            fprintf('Actualizando pesos y bias...\n')
            errores(i) = 1; 
            W = W - alfa * error * X(:, i); 
            bias = bias - alfa * error; 
            fprintf('Los nuevos pesos son: \n')
            disp(W)
            fprintf('El nuevo bias es: %d\n', bias)
        else
            % Si el errores es igual a cero no se actualiza
            fprintf('Entonces no se actualiza\n')
        end
    end
    % Se aumenta una época
    epoch = epoch + 1; 

    % Se agregan los errores en esta época
    errores_globales = [errores_globales, sum(errores)]; 

    % Criterio de parada
    if sum(errores) == 0
        fprintf('No se encontraron errores en esta época, terminando el algoritmo...\n')
        break
    end
end

% Impresión de resultados
fprintf('Algoritmo terminado con éxito!\n')
fprintf('El algoritmo se entrenó en %d épocas\n', epoch-1)
fprintf('Los pesos finales encontrados son: \n')
disp(W)
fprintf('Los bias finales encontrados son: \n')
disp(bias);

% Gráfica de evolución del número de errores
figure()
plot(1:epoch-1, errores_globales)
title('Número de errores en función de las épocas')
xlabel('Época')
ylabel('Número de errores')

% Verificación de la red entrenada
salida = hardlim(W' * X + bias);
fprintf('Salida esperada\n')
disp(Y)
fprintf('Salida obtenida\n')
disp(salida)
%% Números triangulares menores a 10

clear all;
clc;
close all;

% Los números triangulares menores a 10 son: 1, 3 y 6

uno = [0 0 0 0 1 1 0 0 0 1 1 1 1 1 1 0 0 0 0 1 0 0 0 0 1];
% 01100
% 00100
% 00100
% 00100
% 11111

dos = [1 0 0 0 1 1 0 0 1 1 1 0 1 0 1 1 1 0 0 1 1 0 0 0 1];
% 11111
% 00010
% 00100
% 01000
% 11111

tres = [1 0 1 0 1 1 0 1 0 1 1 0 1 0 1 1 0 1 0 1 1 1 1 1 1];
% 11111
% 00001
% 11111
% 00001
% 11111

cuatro = [1 1 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 1 1 1 1 1];
% 10001
% 10001
% 11111
% 00001
% 00001

cinco = [1 1 1 0 1 1 0 1 0 1 1 0 1 0 1 1 0 1 0 1 1 0 1 1 1];
% 11111
% 10000
% 11111
% 00001
% 11111

seis = [1 0 1 1 1 1 0 1 0 1 1 0 1 0 1 1 0 1 0 1 1 1 1 1 1]; 
% 11111
% 00001
% 11111
% 10001
% 11111

siete = [1 0 1 0 0 1 0 1 0 0 1 0 1 0 0 1 1 1 1 1 0 0 1 0 0]; 
% 11110
% 00010
% 11111
% 00010
% 00010

ocho = [1 1 1 1 1 1 0 1 0 1 1 0 1 0 1 1 0 1 0 1 1 1 1 1 1]; 
% 11111
% 10001
% 11111
% 10001
% 11111

nueve = [1 1 1 0 0 1 0 1 0 0 1 0 1 0 0 1 0 1 0 0 1 1 1 1 1]; 
% 11111
% 10001
% 11111
% 00001
% 00001

X =[uno', dos', tres', cuatro', cinco', seis', siete', ocho', nueve'];
Y = [1, 0, 1, 0, 0, 1, 0, 0, 0]; 

% Código UNI: 20230014H
% Pesos y bias +/- 0.1
% Tasa de aprendizaje = 0.4

% Esquema y gráfico de la red
red = perceptron();
red = configure(red, X, Y);
view(red);

% Uso detallado del algorito paso a paso
alfa = 0.4; 
epoch = 1; 
error = 0; 
max_epochs = 10000;
errores_globales = [];

W = [0.1; 0.1; 0.1; 0.1; 0.1;
     0.1; 0.1; 0.1; 0.1; 0.1;
     0.1; 0.1; 0.1; 0.1; 0.1;
     0.1; 0.1; 0.1; 0.1; 0.1;
     0.1; 0.1; 0.1; 0.1; 0.1;];

B = 0.1; 

while true
    fprintf('Estamos en la época %d\n', epoch)
    errores = zeros(1, size(X,2));

    for i = 1:size(X, 2)
        % Selección del punto
        entrada = X(:, i);
        disp('Selección del nuevo punto')
        disp('El punto seleccionado es: ')
        disp(entrada')

        % Calcular la salida lineal
        linear = W' * entrada + B;
        salida = hardlim(linear);
        fprintf('La salida obtenida es: %d\n', salida)
        fprintf('La salida esperada es: %d\n', Y(i))
    
        % Calcular el error
        error = salida - Y(i);
        fprintf('Por lo tanto, el error es de: %d\n', error)

        if abs(error) == 1
            errores(i) = 1;
            % Actualización de pesos y bias
            W = W - alfa * error * entrada;
            B = B - alfa * error;
           
            disp('Los nuevos pesos son: ')
            disp(W)
            disp('Los nuevos bias son: ')
            disp(B)
        else
            disp('Entonces los pesos y bias no se actualizan')
        end

    end
    % Sumamos una época
    epoch = epoch + 1;

    % Almacenamos el número de errores en esta época
    errores_globales = [errores_globales, sum(errores)];
    
    % Criterio de parada
    if sum(errores) == 0
        fprintf('Ya no se detectaron errores, terminando el algoritmo...\n')
        break
    end
end

fprintf('Entrenamiento terminado!\n')

% Numero de épocas de entrenamiento
fprintf('La red se entrenó en: %d épocas\n', epoch-1)

% valores finales de W y B
fprintf('Los pesos finales encontrados son los siguientes: \n')
disp(W)
fprintf('Los bias finales encontrados son los siguientes: \n')
disp(B)

% Gráfica de evolución del número de errores
figure
plot(1:epoch-1, errores_globales')
title('Número de errores en función de las épocas')
xlabel('Época')
ylabel('Número de errores')

% Verificación de la red entrenada
salida = hardlim(W' * X + B);
fprintf('La salida esperada es \n')
disp(Y)
fprintf('La salida obtenida es \n')
disp(salida)






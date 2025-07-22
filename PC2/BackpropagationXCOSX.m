% Red Backpropagation para aproximar la función y = x + cos(x) 

% Una capa oculta
% Sigmoide y lineal 

clear all; 
clc; 
close all; 

% Esquema y gráfico de la red
% Se tendrán 25 neuronas en la capa oculta
% Se tendrán 2001 juegos de entradas
% Entonces, el esquema de red es: 1x2001-25-1x2001

% Gráfico de la red
red = network;

% Matrices representativas
% I = [I1, I2, I3, I4, I5, ...]
% W1 = [W11 W12, W13, W14, ... W1-25]
% W2 = [W11; W21; W31; W41 ... W25-1]
% B1 = [B1 B2 B3 ... B25]
% B2 = [B1']

% Generación de datos
X = -10:0.01:10;
Y = X + cos(X);

% Escalado
media = mean(X); 
desviacion = std(X); 
X = (X - media) / desviacion;

max_epochs = 5000; 
alfa = 0.001; 
neuronas_ocultas = 25; 
epoch = 1;
ecm_matrix = []; 
ecm_aceptable = 0.001; 

% Inicialización de pesos y bias
rng(42)
W1 = rand(1, neuronas_ocultas); 
W2 = rand(neuronas_ocultas, 1);
B1 = rand(neuronas_ocultas, 1); 
B2 = rand(); 


disp('Parámetros para el modelo Backpropagation')
disp('Se considerarán 25 neuronas en la capa oculta')
disp('Se considerarán 2001 entradas')
disp('Se tendrá una neurona en la capa de salida para aproximar la función x + cos(x)')
fprintf('Iniciando entrenamiento...\n')

% Entranimiento detallado paso a paso
for epoch = 1:max_epochs
    ecm = 0; 
    for j = 1:size(X, 2)
        % Forward Propagation
        linear = W1' * X(j) + B1;
        % Activación sigmoidal
        H1 = logsig(linear);

        linear2 = W2' * H1 + B2;
        % Activación lineal
        H2 = linear2;

        % Actualización del error
        error = H2 - Y(j);
        ecm = ecm + error * error;

        % Backpropagation
        delta2 = error * 1;
        W2 = W2 - alfa * delta2 * H1;
        B2 = B2 - alfa * delta2; 

        delta1 = (W2 * delta2) .* H1 .* (1 - H1); 
        W1 = W1 - alfa * X(j) * delta1';
        B1 = B1 - alfa * delta1;
    end
    ecm = sqrt(ecm / size(X, 2));
    ecm_matrix = [ecm_matrix, ecm]; 

    % Imprimir ECM cada 50 épocas
    if mod(epoch, 50) == 0
        fprintf('Época: %d\tECM: %d\n', epoch, ecm)
    end

    % Criterio de parada
    if ecm < ecm_aceptable
        fprintf('Terminando el algoritmo porque se alcanzó el ECM aceptable\n')
        break
    end
end

fprintf('Algoritmo terminado...\n')

% Número de épocas de entrenamiento
fprintf('El algoritmo se entrenó en %d épocas\n', epoch)

% Pesos finales
disp('Los pesos finales son: ')
disp('Para la capa oculta')
disp(W1)
disp('Para la capa de salida')
disp(W2)
disp('Los bias finales para la capa oculta son')
disp(B1)
disp('Los bias finales para la capa de salida son')
disp(B2)

% Evaluación del modelo
X_prueba = [4, 1, 2, 5, -2, 3, -3, -6, -7];
Y_esperado = X_prueba + cos(X_prueba);
X_prueba = (X_prueba - media) / desviacion; 
Z1 = logsig(W1' * X_prueba + B1);
Z2 = W2' * Z1 + B2;

% Impresión de los resultados
disp('Se quiere probar el modelo con los siguientes puntos')
disp(X_prueba)
fprintf('Valores obtenidos con el argoritmo\n')
disp(Z2)
fprintf('Valores esperados\n')
disp(Y_esperado)

% Gráfica del ECM
figure
plot(1:size(ecm_matrix, 2), ecm_matrix)
title('ECM según las épocas de entrenamiento')
xlabel('Época')
ylabel('ECM')

% Gráfica de salida predicha vs esperada
Z1 = logsig(W1' * X + B1);
Z2 = W2' * Z1 + B2;
figure
plot(1:size(X,2), Z2)
hold on;
plot(1:size(X,2), Y);
title('Salida predicha vs esperada')
xlabel('Entrada x')
ylabel('Salida x + cos(x)')
legend('Salida predicha', 'Salida esperada')
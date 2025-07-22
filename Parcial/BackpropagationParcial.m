% Red neuronal Backpropagation para aproximar y = x^3 + 2x - 1
% Red MLP con 10 neuronas ocultas
% Funciones: tansig, purelin
close all;
clear;
clc;

% Generar 100 puntos entre -2 y 2
JE = 100; 
minimo = -2; 
maximo = 2; 

% Creación de entradas
rng(42)
X = minimo + rand(1, JE) * (maximo - minimo);
X = sort(X, 'ascend');

Y = X.^3 + 2*X - 1;

neuronas_ocultas = 10; 

% a) Crear y configurar la red neuronal
red = fitnet(neuronas_ocultas);
red = configure(red, X, Y); 
view(red)

% b) Entrenar y simular la red
red = train(red, X, Y);

% b) Entrenamiento manual de la red
% Variables globales 
alfa = 0.01; 
ecma = 0.05; 
max_epochs = 8000; 
ecm_matrix = []; 
epoch = 1; 

% Inicialización de pesos y bias
W1 = randn(1, neuronas_ocultas); 
W2 = randn(neuronas_ocultas, 1); 
B1 = randn(neuronas_ocultas, 1);
B2 = randn(1, 1); 

W1_copy = W1; 
W2_copy = W2; 
B1_copy = B1; 
B2_copy = B2; 

for epoch = 1:max_epochs
    ecm = 0; 
    % Impresión del avance según época
    if mod(epoch, 200) == 0
        fprintf('El algoritmo se encuentra en la época %d\n', epoch)
    end
    for i = 1:JE
        % Selección del punto
        punto = X(1, i); 

        % Propagación hacia adelante
        linear1 = W1' * punto + B1; 
        Z1 = tansig(linear1); 

        linear2 = W2' * Z1 + B2;
        Z2 = linear2; 

        % Backpropagation
        error = Z2 - Y(i);
        ecm = ecm + error * error; 

        % Activación lineal: f' = 1
        delta2 = error * 1;

        W2 = W2 - alfa * Z1 * delta2'; 
        B2 = B2 - alfa * delta2; 
        
        % Activación tanh: f' = (1 - f^2)
        delta1 = (W2 * delta2) .* (1 - Z1.^2);
        
        W1 = W1 - alfa * punto * delta1'; 
        B1 = B1 - alfa * delta1; 
    end

    % Actualización del ECM y guardado
    ecm = sqrt(ecm/2);
    ecm_matrix = [ecm_matrix, ecm]; 

    % Criterio de parada
    if ecm <= ecma
        fprintf('Terminando el algoritmo porque se alcanzó el ECM aceptable\n')
        break; 
    end
end
fprintf('Algoritmo terminado con éxito!\n')

% Calcular salida con la primera red
Z1_1ra = tansig(W1' * X + B1); 
Z2_1ra = W2' * Z1_1ra + B2; 

% e) FA: tansig - logsig
ecm_matrix_2 = []; 
epoch2 = 1; 

fprintf('Iniciando entrenamiento de la 2da red\n')
for epoch2 = 1:max_epochs
    ecm = 0; 
    % Impresión del avance según época
    if mod(epoch2, 200) == 0
        fprintf('El algoritmo se encuentra en la época %d\n', epoch2)
    end
    for i = 1:JE
        % Selección del punto
        punto = X(1, i); 

        % Propagación hacia adelante
        linear1 = W1_copy' * punto + B1_copy; 
        Z1 = tansig(linear1); 

        linear2 = W2_copy' * Z1 + B2_copy;
        Z2 = logsig(linear2); 

        % Backpropagation
        error = Z2 - Y(i);
        ecm = ecm + error * error; 

        % Activación logsig: f' = f * (1 - f)
        delta2 = error .* Z2 .* (1 - Z2);

        W2_copy = W2_copy - alfa * Z1 * delta2'; 
        B2_copy = B2_copy - alfa * delta2; 
        
        % Activación tansig: f' = (1 - f^2)
        delta1 = (W2_copy * delta2) .* (1 - Z1.^2);
        
        W1_copy = W1_copy - alfa * punto * delta1'; 
        B1_copy = B1_copy - alfa * delta1; 
    end

    % Actualización del ECM y guardado
    ecm = sqrt(ecm/2);
    ecm_matrix_2 = [ecm_matrix_2, ecm]; 

    % Criterio de parada
    if ecm <= ecma
        fprintf('Terminando el algoritmo porque se alcanzó el ECM aceptable\n')
        break; 
    end
end

fprintf('Entrenamiento de la segunda red terminado!\n')

% Calcular salida con la segunda red
Z1_2da = tansig(W1_copy' * X + B1_copy); 
Z2_2da = logsig(W2_copy' * Z1_2da + B2_copy); 

%% c) Graficar resultados
% Grafica de los resultados
figure
plot(X, Y)
hold on;
plot(X, Z2_1ra)
plot(X, Z2_2da)
xlabel('Entrada X')
ylabel('Función X^3 + 2X - 1')
title('Salida esperada vs salida predicha')
legend('Salida esperada', 'Salida predicha con la 1ra red', 'Salida predicha con la 2da red')
grid on; 

% d) Número de épocas y valores finales de pesos y bias
fprintf('Para la primera red\n')
fprintf('El modelo se entrenó en %d épocas\n', epoch)
fprintf('Los pesos finales de la capa oculta son:\n')
disp(W1)
fprintf('Los pesos finales de la capa de salida son: \n')
disp(W2)
disp('Los bias finales de la capa oculta son')
disp(B1)
disp('El bias final de la capa de salida es')
disp(B2)

fprintf('Para la segunda red\n\n')
fprintf('El modelo se entrenó en %d épocas\n', epoch2)
fprintf('Los pesos finales de la capa oculta son:\n')
disp(W1_copy)
fprintf('Los pesos finales de la capa de salida son: \n')
disp(W2_copy)
disp('Los bias finales de la capa oculta son')
disp(B1_copy)
disp('El bias final de la capa de salida es')
disp(B2_copy)

% Gráficas el ecm
figure
plot(1:epoch, ecm_matrix)
hold on;
plot(1:epoch2, ecm_matrix_2)
title('ECM en las redes')
xlabel('Época')
ylabel('ECM')
grid on; 
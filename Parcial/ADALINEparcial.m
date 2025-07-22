%  Entrenar la red (A XOR B) OR (A OR C)

clear; 
clc; 
close all; 

% Código UNI: 20230014H
% Pesos y bias iniciales +/- 0.4

% Paso cero: Verificación de la red
fprintf('Se desea verificar que la red es entrenable\n')
X = [0 0 0 0 1 1 1 1
     0 0 1 1 0 0 1 1
     0 1 0 1 0 1 0 1]; 
Y = [0 1 1 1 1 1 1 1]; 
fprintf('La salida deseada es: %d %d %d %d %d %d %d %d\n', Y)
fprintf('Se ve que se puede trazar un plano de separación que separa una de las esquinas\n')
fprintf('Por lo tanto la red es entrenable\n');
plotpv(X, Y)

% a) Esquema de la red
fprintf('La red tiene un ER: 3x8 - 1 x 8\n')

% a) Gráfico de la red
red = linearlayer();
red = configure(red, X, Y);
view(red)

% b) Matrices representativas
% I = [I11 I12 I13 I14 ... I18;
%      I21 I22 I23 I24 ... I28;
%      I31 I32 I33 I34 ... I38];

% W = [W11; W21; W31] 

% B = [B1]

% c) Pesos y biases iniciales
W = [0.4; -0.4; 0.4]; 
B = 0.4; 

% Variables globales
alfa = 0.005; 
ecma = 0.506; 
max_epochs = 1000; 
ecm_matrix = []; 
epoch = 1; 
umbral = 0.6; 
JE = size(X, 2);

% d) Uso detallado del algoritmo paso a paso, mostrando resultados en cada
% paso
for epoch = 1:max_epochs
    ecm = 0;

    fprintf('Se está entrenando la época %d\n', epoch)

    for i = 1:JE
        % Selección del punto
        punto = X(:, i);
        fprintf('Punto seleccionado: %d %d %d\n', punto)

        % Cálculo de la salida
        salida = W' * punto + B; 
        fprintf('Salida obtenida: %.3f\n', salida)

        % Cálculo del error
        error = salida - Y(i); 
        fprintf('Error encontrado: %.3f\n', error)
        
        %  Actualización del ECM
        ecm = ecm + error * error; 

        % Actualización
        fprintf('Actualizando pesos y bias...\n')
        W = W - alfa * error * punto; 
        B = B - alfa * error; 
        disp('Pesos actualizados')
        disp(W)
        disp('Bias actualizado')
        disp(B)
    end
    ecm = sqrt(ecm / 2); 
    fprintf('El ECM de esta época es: %.3f\n', ecm)

    % Actualización de la matriz de ECMs
    ecm_matrix = [ecm_matrix, ecm]; 

    % Criterio de parada
    if ecm <= ecma
        fprintf('Terminando el algoritmo porque se alcanzó el ECM aceptable...\n')
        break
    end
end
fprintf('Algoritmo de entrenamiento finalizado con éxito!\n\n')

% e) Número de épocas de entrenamiento y valores finales de pesos y bias
fprintf('La red se entrenó en %d épocas\n', epoch)
fprintf('Los pesos finales encontrados son: \n')
disp(W)
fprintf('El bias final encontrado es: \n')
disp(B)

% f) Extra - Gráfico del ECM
fprintf('Mostrando gráfico del ECM...\n')
figure
plot(1:epoch, ecm_matrix)
title('ECM según la época')
xlabel('Época')
ylabel('ECM')
grid on; 
fprintf('Gráfico generado con éxito!\n')

% g) Extra - Comprobación de la red
fprintf('Comprobando la red...\n')
fprintf('La salida deseada es: %d %d %d %d %d %d %d %d\n', Y)
salida_final = (W' * X + B) > umbral; 
fprintf('La salida obtenida es: %d %d %d %d %d %d %d %d\n', salida_final)
fprintf('Puede verse que la salida obtenida es igual a la salida deseada\n')
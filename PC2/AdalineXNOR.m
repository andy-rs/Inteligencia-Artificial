% Red ADALINE aplicado a la MADALINE para la función lógica XNOR
% Pesos y bias iniciales: +/- 0.4

close all; 
clear; 
clc; 

X = [0 0 1 1;
     0 1 0 1]; 
Y = [1 0 0 1]; 

% a) Esquema de la red
fprintf('La red tiene un esquema de red 2x4 - 1x4\n')

% b) Gráfico de la red
red = feedforwardnet(2);
red.layers{1}.transferFcn = 'hardlim'; 
red.layers{2}.transferFcn = 'purelin';
red = configure(red, X, Y);
view(red)

% b) Matrices representativas

% I = [I11 I12;
%      I21 I22]

% Primeras dos ADALINE
% W1 = [W11 W12;
%       W21 W22]

% ADALINE de salida
% W2 = [W11; W21]

% Primeras dos ADALINE
% B1 = [B1; B2]

% ADALINE de salida
% B2 = [B1']

% Uso detallado del algoritmo paso a paso
% Parámetros generales 
alfa = 0.01;
ecma = 0.36;
JE = size(X, 2);

%% Entrenamiento de la primera ADALINE
% Salida esperada: -(A or B)
Y1 = [1 0 0 0]; 

% Pesos iniciales 
W1 = [0.4; -0.4]; 
B1 = 0.4;
max_epochs = 500;
ecm_matrix_1 = []; 
epoch1 = 1;

% Entrenamiento
fprintf('Iniciando entrenamiento...\n')
for epoch1 = 1:max_epochs
    ecm = 0; 
    fprintf('Estamos en la época: %d\n', epoch1)
    for i = 1:JE
        % Selección del punto
        punto = X(:, i);
        fprintf('Se seleccionó el punto. %d %d\n', punto)

        % Calculo de la salida lineal
        linear = W1' * punto + B1;
        fprintf('Con lo que la salida lineal es: %.3f\n', linear)

        % Error
        error = linear - Y1(i);
        fprintf('Lo que da un error de %.3f\n', error)

        % Actualización
        W1 = W1 - alfa * error * punto; 
        B1 = B1 - alfa * error;
        fprintf('Los pesos y bias actualizados son los siguientes\n')
        disp('Pesos')
        disp(W1)
        disp('Bias')
        disp(B1)

        % Suma del error en forma cuadrática
        ecm = ecm + error * error; 
    end
    
    % Actualización del ecm
    ecm = sqrt(ecm / 2); 
    fprintf('El ECM de esta época es: %.4f\n', ecm)
    % Se guarda el ecm
    ecm_matrix_1 = [ecm_matrix_1, ecm];

    % Criterio de parada
    if ecm <= ecma
        disp('Terminando el algoritmo porque se alcanzó el ecma aceptable')
        break
    end
end

fprintf('El entrenamiento ha terminado!\n')

% Verificación de las salidas
s1 = (W1' * X + B1) > 0.5;
fprintf('La salida esperada era: %d %d %d %d\n', Y1)
fprintf('La salida obtenida es: %d %d %d %d\n', s1)

% Impresión del ecm
disp('Los ECMs cada 10 épocas son:')
for i=1:10:size(ecm_matrix_1,2)
    fprintf('ECM: %.4f\n', ecm_matrix_1(i))
end
fprintf('El ECM final es: %.4f\n', ecm_matrix_1(end))
fprintf('Mostrando gráfica del ECM para esta ADALINE...\n')

% Gráfica del ecm
figure
plot(1:epoch1, ecm_matrix_1)
title('ECM en la primera ADALINE')
xlabel('Época')
ylabel('ECM')

%% Entrenamiento de la segunda ADALINE
% Salida esperada: (A and B)
Y2 = [0 0 0 1]; 

% Pesos iniciales 
W2 = [0.4; -0.4]; 
B2 = 0.4;
max_epochs = 500;
ecm_matrix_2 = []; 
epoch2 = 1;

% Entrenamiento
fprintf('Iniciando entrenamiento de la segunda ADALINE...\n')
for epoch2 = 1:max_epochs
    ecm = 0; 
    fprintf('Estamos en la época: %d\n', epoch2)
    for i = 1:JE
        % Selección del punto
        punto = X(:, i);
        fprintf('Se seleccionó el punto. %d %d\n', punto)

        % Calculo de la salida lineal
        linear = W2' * punto + B2;
        fprintf('Con lo que la salida lineal es: %.3f\n', linear)

        % Error
        error = linear - Y2(i);
        fprintf('Lo que da un error de %.3f\n', error)

        % Actualización
        W2 = W2 - alfa * error * punto; 
        B2 = B2 - alfa * error;
        fprintf('Los pesos y bias actualizados son los siguientes\n')
        disp('Pesos')
        disp(W2)
        disp('Bias')
        disp(B2)

        % Suma del error en forma cuadrática
        ecm = ecm + error * error; 
    end
    
    % Actualización del ecm
    ecm = sqrt(ecm / 2); 
    fprintf('El ECM de esta época es: %.4f\n', ecm)
    % Se guarda el ecm
    ecm_matrix_2 = [ecm_matrix_2, ecm];

    % Criterio de parada
    if ecm <= ecma
        disp('Terminando el algoritmo porque se alcanzó el ecma aceptable')
        break
    end
end

fprintf('El entrenamiento ha terminado!\n')

% Verificación de las salidas
s2 = (W2' * X + B2) > 0.5;
fprintf('La salida esperada era: %d %d %d %d\n', Y2)
fprintf('La salida obtenida es: %d %d %d %d\n', s2)

% Impresión del ecm
disp('Los ECMs cada 10 épocas son:')
for i=1:10:size(ecm_matrix_2,2)
    fprintf('ECM: %.4f\n', ecm_matrix_2(i))
end
fprintf('El ECM final es: %.4f\n', ecm_matrix_2(end))
fprintf('Mostrando gráfica del ECM para esta ADALINE...\n')

% Gráfica del ecm
figure
plot(1:epoch2, ecm_matrix_2)
title('ECM en la segunda ADALINE')
xlabel('Época')
ylabel('ECM')

%% Entrenamiento de la tercera ADALINE
% Salida esperada: (S1 or S2)
Y3 = [1 0 0 1]; 
X = [s1; s2];

% Pesos iniciales 
W3 = [0.4; -0.4]; 
B3 = 0.4;
max_epochs = 500;
ecm_matrix_3 = []; 
epoch3 = 1;

% Entrenamiento
fprintf('Iniciando entrenamiento de la tercera ADALINE...\n')
for epoch3 = 1:max_epochs
    ecm = 0; 
    fprintf('Estamos en la época: %d\n', epoch3)
    for i = 1:JE
        % Selección del punto
        punto = X(:, i);
        fprintf('Se seleccionó el punto. %d %d\n', punto)

        % Calculo de la salida lineal
        linear = W3' * punto + B3;
        fprintf('Con lo que la salida lineal es: %.3f\n', linear)

        % Error
        error = linear - Y3(i);
        fprintf('Lo que da un error de %.3f\n', error)

        % Actualización
        W3 = W3 - alfa * error * punto; 
        B3 = B3 - alfa * error;
        fprintf('Los pesos y bias actualizados son los siguientes\n')
        disp('Pesos')
        disp(W3)
        disp('Bias')
        disp(B3)

        % Suma del error en forma cuadrática
        ecm = ecm + error * error; 
    end
    
    % Actualización del ecm
    ecm = sqrt(ecm / 2); 
    fprintf('El ECM de esta época es: %.4f\n', ecm)
    % Se guarda el ecm
    ecm_matrix_3 = [ecm_matrix_3, ecm];

    % Criterio de parada
    if ecm <= ecma
        disp('Terminando el algoritmo porque se alcanzó el ecma aceptable')
        break
    end
end

fprintf('El entrenamiento ha terminado!\n')

% Verificación de las salidas
s3 = (W3' * X + B3) > 0.5;
fprintf('La salida esperada era: %d %d %d %d\n', Y3)
fprintf('La salida obtenida es: %d %d %d %d\n', s3)

% Impresión del ecm
disp('Los ECMs cada 10 épocas son:')
for i=1:10:size(ecm_matrix_3,2)
    fprintf('ECM: %.4f\n', ecm_matrix_3(i))
end
fprintf('El ECM final es: %.4f\n', ecm_matrix_3(end))
fprintf('Mostrando gráfica del ECM para esta ADALINE...\n')

% Gráfica del ecm
figure
plot(1:epoch3, ecm_matrix_3)
title('ECM en la tercera ADALINE')
xlabel('Época')
ylabel('ECM')

fprintf('Entrenamiento de la red terminado!\n')

% Número de épocas de entrenamiento
fprintf('La red se ha entrenado en: %d épocas\n', epoch1 + epoch2 + epoch3)

% Valores finales de pesos y bias
disp('Pesos finales')
disp('Para la primera ADALINE')
disp(W1)
disp('Para la segunda ADALINE')
disp(W2)
disp('Para la tercera ADALINE')
disp(W3)
disp('Pesos en ese orden')
disp('Prineras dos ADALINE')
disp(B1)
disp(B2)
disp('ADALINE de la salida')
disp(B3)
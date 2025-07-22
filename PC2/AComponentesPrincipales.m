% Análisis de componentes principales

clear;
close all;
clc;

neuronas = 6; 
JE = 4; 
dimension = 2; 
minimo = -3; 
maximo = 3; 
rng(42)

% Generar matrices de entradas
X = minimo + rand(dimension, JE) * (maximo - minimo);
fprintf('Las entradas a evaluar son: \n')
disp(X)

% Generar pesos iniciales
W = minimo + rand(neuronas, dimension) * (maximo - minimo); 
fprintf('Los pesos de las neuronas son:\n')
disp(W)

% a) Esquema de la red
fprintf('La red tiene un esquema de red: 2x4 - 6 - 1x6\n\n')

% b) Gráfico de la red
%      |-- N11 N12  ->  d1
%      |-- N21 N22  ->  d2 
% I1 |_|-- N31 N32  ->  d3
% I2 | |-- N41 N42  ->  d4
%      |-- N51 N52  ->  d5
%      |-- N61 N62  ->  d6

% En el gráfico cada entrada (con dos coordinadas) se procesa
% por cada neurona (dos pesos) y se produce una salida (distancia)

% Matrices representativas
% I = [I11 I12 I13 I14;
%      I21 I22 I23 I34]

% W = [W11 W12;
%      W21 W22;
%      W31 W32;
%      W41 W42;
%      W51 W52;
%      W61 W62];

% Procesamiento
distancias_JE = zeros(1, JE);
neuronas_ganadoras = zeros(1, JE); 

fprintf('Iniciando procesamiento...\n')
% Iteración para cada JE
for i = 1:JE
    % Generar vector de distancias nuevo
    distancias_neuronas = zeros(1, neuronas);

    % Selección de la entrada
    entrada = X(:, i);
    fprintf('Evaluando el vector (%.3f, %.3f)\n', entrada(1), entrada(2))

    % Iteración para cada neurona
    for j = 1:neuronas
        % Selección de pesos
        pesos = W(j, :);

        % Cálculo de la distancia solicitada
        distancia = sum(abs(entrada - pesos'));
        fprintf('La distancia para la neurona %d es %.3f\n', j, distancia)

        % Almacenar distancia
        distancias_neuronas(j) = distancia;
    end
    % Conseguir la distancia mínima para el juego de entradas
    [dist_min, indice_neurona] = min(distancias_neuronas);
    distancias_JE(i) = dist_min;
    neuronas_ganadoras(i) = indice_neurona;
    fprintf('La distancia mínima para este JE es: %.3f\n', dist_min)
    fprintf('La neurona ganadora es: %d\n\n', indice_neurona)
end

fprintf('Procesamiento finalizado con éxito!\n\n')

% Mostrar resultados del procesamiento
fprintf('Mostrando resumen del procesamiento...\n')
fprintf(['Las neuronas ganadoras para cada juego de entrada son: ' ...
    '%d %d %d %d %d %d\n'], neuronas_ganadoras)
fprintf('\nSus respectivas distancias son: %.3f %.3f %.3f %.3f', distancias_JE)

% Gráfica de neuronas y entradas en el plano
figure
scatter(X(1, :), X(2, :), 'blue')
hold on;
scatter(W(:, 1), W(:, 2), 'red')

for i = 1:JE
    ganadora = neuronas_ganadoras(i);
    pesos_ganadora = W(ganadora, :); 
    entrada = X(:, i); 
    plot([entrada(1), pesos_ganadora(1)], [entrada(2), pesos_ganadora(2)])
end

title('Entradas y neuronas vistas en 2D')
xlabel('Coordenada 1')
ylabel('Coordenada 2')
legend('Entradas', 'Neuronas')
grid on;
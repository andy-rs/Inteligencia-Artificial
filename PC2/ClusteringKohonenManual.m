% Red de Kohonen para clasificar datos agrupados
clear; 
close all; 
clc; 

% Creación de los datos agrupados
rng(42)
clusters = 6; 
puntos = 12; 
std_deviation = 0.03;
bordes = [0 1; 0 1]; 
X = nngenc(bordes, clusters, puntos, std_deviation);

% Visualización de los datos
figure
scatter(X(1, :), X(2, :), 'x')
xlabel('Dimensión 1')
ylabel('Dimensión 2')
title('Clusters generados')

% Parámetros generales de la red
filas = 3; 
columnas = 5; 
neuronas = 15;

% a) Esquema de la red
fprintf('La red tiene un ER: 2x72 - 15 - 15 x 72\n')
fprintf(['Ya que hay 72 entradas con dos características cada una, 15 neuronas procesadoras' ...
    ' y 15 salidas para cada una de las 72 entradas\n'])

% a) Gráfico de la red
dimension = [filas columnas];
red = selforgmap(dimension);
red = configure(red, X);
view(red)

% b) Matrices representativas
% I = [I11 I12 I13 ... I1-72;
%      I21 I22 I23 ... I2-72]

% W = [W11 W12 W13 W14 W15;
%      W21 W22 W23 W24 W25;
%      W31 W32 W33 W34 W35]

% donde Wij = (wij1, wij2) 

% c) Parámetros de la creación de los datos agrupados
fprintf('Los parámetros de la creación de los datos agrupados son:\n')
fprintf('Número de grupos: %d\n', clusters)
fprintf('Número de puntos en cada grupo: %d\n', puntos)
fprintf('Desviación estándar: %.4f\n', std_deviation)
fprintf('Bordes: [%d %d; %d %d]\n', bordes(1, :), bordes(2, :))

%% d) Resultados del procesamiento
rng(42)
% Variables generales
JE = puntos * clusters; 
W = rand(filas, columnas, 2);
ganadoras = zeros(2, JE);
distancias_minimas = zeros(1, JE); 
alfa_o = 0.3;
radio_o = 2;
radio_f = 0.5; 
alfa_f = 0.01;
epocas = 300;

% Bucle principal
fprintf('Iniciando entrenamiento...\n')
for epoch = 1:epocas
    % Impresión del avance de épocas
    if mod(epoch, 20) == 0
        fprintf('Entranando en la época %d\n', epoch)
    end

    for i = 1:JE
        % Selección de la entrada
        entrada = X(:, i); 
        
        % Variables generales
        idx = 0;
        idy = 0;
        mejor_distancia = 100;
    
        % Calculo de las distancias para cada neurona
        for j = 1:filas
            for k = 1:columnas
                % Cálculo de la distancia
                pesos = [W(j, k, 1) W(j, k, 2)];
                distancia = sum(abs(pesos - entrada'));
    
                % Se guardan los índices de la ganadora
                if distancia < mejor_distancia
                    idx = j;
                    idy = k;
                    mejor_distancia = distancia; 
                end
            end
        end
        
        % Calculo de la tasa de aprendizaje
        alfa = alfa_o * (alfa_f/alfa_o) ^ (epoch / epocas);
        radio = radio_o * (radio_f / radio_o) ^ (epoch / epocas);
        
        % Activación en escalón
        for l = 1:filas
            for m = 1:columnas
                distancia = abs(idx - l) + abs(idy - m);
                activacion = 0;

                if distancia <= radio
                    activacion = 1;
                end
                % Actualización de los pesos de las vecinas
                W(l, m, 1) = W(l, m, 1) - alfa * activacion * (W(l, m, 1) - entrada(1));
                W(l, m, 2) = W(l, m, 2) - alfa * activacion * (W(l, m, 2) - entrada(2));
            end
        end

        % Guardar info en la época final
        if epoch == epocas
            ganadoras(1, i) = idx; ganadoras(2, i) = idy;
            distancias_minimas(i) = mejor_distancia; 
        end
    end
end

fprintf('Entrenamiento finalizado con éxito!\n\n')

% d) Escriba los resultados del tipo de procesamiento
fprintf('Estos son los resultados del procesamiento\n')
fprintf('Las neuronas ganadoras fueron\n')
for i = 1:JE
    fprintf('Para la entrada %d: (%d, %d)\n', i, ganadoras(1, i), ganadoras(2, i))
end

% e) Adicional - Gráfico de la asignación de pesos
fprintf('Generando gráfica 2D para ver los resultados...\n')
figure;
scatter(X(1,:), X(2,:), 'filled');
hold on;
for i = 1:JE
    w1 = W(ganadoras(1, i), ganadoras(2, i), 1);
    w2 = W(ganadoras(1, i), ganadoras(2, i), 2);
    plot([X(1, i) w1], [X(2, i) w2], 'red')
end
title('Asignación de entradas a neuronas ganadoras')
xlabel('Dimension 1')
ylabel('Dimension 2')
grid on; 
fprintf('Gráfica generada con éxito\n')
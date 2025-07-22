% Antenas en telecomunicaciones
clear; clc; close all; 
rng(0); 

% Parámetros del algoritmo genético
nAntennas = 3;
numTargets = 50; 
popSize = 50; 
numGenerations = 100; 
tasaMutacion = 0.1; 
sigma = 0.5; 
tournamentSize = 3; 
radio = 10; 
tasaCruce = 0.7;
lower = 0;
upper = 50; 

fprintf('Iniciando algoritmo genético para resolver el problema de colocación de antenas\n')
fprintf('Parámetros del AG\n')
fprintf('Número de antenas: %d\n', nAntennas)
fprintf('Función de aptitud: # de zonas cubiertas\n')
fprintf('Tamaño de la población: %d\n', popSize)
fprintf('Número de generaciones: %d\n', numGenerations)
fprintf('Tasa de cruce: %.3f\n', tasaCruce)
fprintf('Tasa de mutación: %.3f\n', tasaMutacion)

% Inicialización de la población inicial
poblacion = zeros(popSize, 2 * nAntennas);
fprintf('\nLa población inicial es la siguiente\n')
for i = 1:popSize
    add = lower + rand(1, 2 * nAntennas) * (upper - lower);
    fprintf('(%.3f %.3f), (%.3f %.3f), (%.3f %.3f)\n', add)
    poblacion(i, :) = add;
end

% Especificaciones
fprintf('\nLa función de aptitud es: # de zonas cubiertas\n')
fprintf('La selección se hará por torneo, con un tamaño de %d\n', tournamentSize)
fprintf('El cruce se hará mediante cruce de un punto\n')
fprintf('La mutación se hará por mutación gausianna, con sigma = %.3f\n', sigma)

fprintf('\nIniciando el algoritmo genético\n')

% Inicialización de los objetivos
objetivos = lower + rand(numTargets, 2) * (upper - lower);

% Matrices generales 
mejores_soluciones = []; 
fitness_mejores = []; 
mejor_cobertura_global = zeros(1, numGenerations); 

% Bucle principal
for gen = 1:numGenerations
    % Impresión del avance
    if mod(gen, 50) == 0
        fprintf('El algoritmo genético se encuentra en la generación %d\n', gen)
    end
    
    % Evaluar aptitud
    fitness = evaluar_aptitud(poblacion, objetivos, radio);
    
    % Guardar mejor cobertura global
    [mejor, ~] = max(fitness); 
    mejor_cobertura_global(gen) = mejor; 

    % Mostrar las mejores soluciones
    soluciones_epoca = mostrar_soluciones(poblacion, fitness, gen);
    mejores_soluciones = [mejores_soluciones; soluciones_epoca]; 

    % Seleccionar
    seleccionados = torneo(poblacion, fitness, tournamentSize);

    % Cruce
    hijos = cruce_un_punto(seleccionados, tasaCruce); 

    % Mutación
    mutados = mutacion_gaussiana(hijos, tasaMutacion, sigma, upper, lower); 

    % Reemplazar población
    poblacion = mutados; 
end

fprintf('Algoritmo genético terminado!\n')

% Mostrar las mejores coberturas según generaciones
figure
plot(1:numGenerations, mejor_cobertura_global); 
xlabel('Generación')
ylabel('Número de zonas cubiertas')
title('Número de coberturas mayor según generaciones')

% Mostrar antenas y su cobertura
best = mejores_soluciones(end-4, :);
figure
scatter(objetivos(:,1), objetivos(:,2))
hold on; 
scatter(best(1), best(2), 'filled', 'red')
scatter(best(3), best(4), 'filled', 'red')
scatter(best(5), best(6), 'filled', 'red')
viscircles([best(1), best(2)], radio)
viscircles([best(3), best(4)], radio)
viscircles([best(5), best(6)], radio)
xlabel('Coordenada 1')
ylabel('Coordenada 2')
title('Antenas (rojo), zonas (azul) y su cobertura')

% Funciones de soporte
% Evaluación de la aptitud
function fitness = evaluar_aptitud(poblacion, objetivos, radio)
    fitness = zeros(1, size(poblacion, 1)); 
    % Iteración sobre todos los individuos
    for i = 1:size(poblacion, 1)
        individuo = poblacion(i, :);
        cubiertos = 0;
        % Iteración sobre todos los objetivos
        for j = 1:size(objetivos, 1)
            objetivo = objetivos(j, :);
            for k = 1:2:size(individuo, 2)
                A = [individuo(k), individuo(k+1)];
                distancia = norm(objetivo - A); 
                if distancia < radio
                    cubiertos = cubiertos + 1;
                    break; 
                end
            end
        end
        fitness(i) = cubiertos; 
    end
end

% Selección basada en torneo
function seleccionados = torneo(poblacion, fitness, tournamentSize)
    [len, genes] = size(poblacion); 
    seleccionados = zeros(len, genes); 

    for i = 1:len
        indices = randperm(len, tournamentSize); 
        [~, idx] = max(fitness(indices));
        idx_ganador = indices(idx); 
        seleccionados(i, :) = poblacion(idx_ganador, :); 
    end
end

% Cruce de un punto
function hijos = cruce_un_punto(seleccionados, tasaCruce)
    [len, genes] = size(seleccionados); 
    hijos = zeros(len, genes); 
    for i = 1:2:len
        if rand < tasaCruce
            p1 = randperm(genes, 1); 
            hijos(i, 1:p1) = seleccionados(i, 1:p1); 
            hijos(i, p1+1:end) = seleccionados(i+1, p1+1:end);
            hijos(i+1, 1:p1) = seleccionados(i+1, 1:p1); 
            hijos(i+1, p1+1:end) = seleccionados(i, p1+1:end);            
        else
            hijos(i, :) = seleccionados(i, :);
            hijos(i+1, :) = seleccionados(i+1, :);
        end
    end
end

% Función para mutación gaussiana
function mutados = mutacion_gaussiana(hijos, tasaMutacion, sigma, sup, inf)
    [len, genes] = size(hijos); 
    mutados = hijos;
    for i = 1:len
        for j = 1:genes
            if rand < tasaMutacion
                mutados(i, j) = min(sup, mutados(i, j) + sigma * randn());
                if mutados(i,j) < inf, mutados(i, j) = inf; end
            end
        end
    end
end

% Función para mostrar soluciones
function soluciones = mostrar_soluciones(poblacion, fitness, gen)
    [firness_ordenado, idx] = sort(fitness, 'descend');
    poblacion_ordenada = poblacion(idx, :); 
    fprintf('\nMostrando las 5 mejores soluciones de la generacion %d\n', gen)
    soluciones = poblacion_ordenada(1:5, :); 
    fitness_soluciones = firness_ordenado(1:5); 
    for i = 1:5
        fprintf('Solución %d, con aptitud %.2f\n', i, fitness_soluciones(i))
        disp(soluciones(i,:))
    end
    fprintf('Estas son consideradas solución porque:\n')
    fprintf('Respetan el área geográfica\n')
    fprintf('Tienen las mejores aptitudes para el problema\n')
    fprintf('Cumplen con los parámetros dispuestos\n')
end

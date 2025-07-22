% Novedad

clear; 
clc; 
close all;

% Generar un vector de 20 valores enteros en [-3, 5]
% Semilla para obtener siempre los mismos valores
rng(42)
fprintf('Generando un vector de 20 valores enteros en [-3, 5]...\n')
vector_inicial = randi([-3 5], 1, 20); 
fprintf('El vector generado es:\n')
fprintf('%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n', vector_inicial)

% Generar 10 nuevos valors entre -4 y 7
fprintf('Generando 10 nuevos valors entre [-4, 7]...\n')
vector_nuevo = randi([-4, 7], 1, 10); 
fprintf('%d %d %d %d %d %d %d %d %d %d\n', vector_nuevo)

% Matrices para resultados globales
novedades = []; 
no_novedades = [];
vector_total = vector_nuevo; 
historial_promedios = [];
colores = zeros(size(vector_nuevo, 2), 3); 

% Procesamiento por novedad
promedio = mean(vector_inicial);
fprintf('El promedio con el que se inicia es de %.3f\n\n', promedio)

% Bucle principal
fprintf('Iniciando el procesamiento...\n')
for i = 1:size(vector_nuevo, 2)
    % Actualizamos el historial de promedios
    historial_promedios = [historial_promedios, promedio]; 

    % Selección del nuevo valor
    valor = vector_nuevo(i);
    fprintf('El valor nuevo tomado es de %d\n', valor)

    % Calculo de la diferencia
    diferencia = abs(valor - promedio);
    fprintf('La diferencia con el promedio es de %.3f\n', diferencia)
    
    % Criterios para considerar novedad o no
    if diferencia >= 1
        fprintf('En base a esto, se trata de una novedad\n')

        % Actualizar el vector de novedades
        novedades = [novedades, valor]; 
        fprintf('Hasta ahora se tienen las siguientes novedades: \n')
        disp(novedades)

        % Actualizar el vector de colores
        colores(i, :) = [1 0 0];  
    else
        fprintf('No se trada de una novedad\n')

        % Actualizar el vector de no novedades
        no_novedades = [no_novedades, valor];
        fprintf('Hasta ahora se tienen los valores considerados como no novedades: \n')
        disp(no_novedades)
        
        % Actualizar el vector de colores
        colores(i, :) = [0 0 1]; 
    end
    vector_total = [vector_total, valor];
    promedio = mean(vector_total); 
    fprintf('El nuevo promedio es de %.3f\n', promedio)
end

fprintf('Fin del procesamiento!\n')
fprintf('Se encontraron las siguientes novedades:\n')
disp(novedades)
fprintf('Se encontraron las siguientes no novedades:\n')
disp(no_novedades)
fprintf('Mostrando gráficos relevantes...\n')

% Gráfica del historial de promedios
figure
plot(1:size(vector_nuevo, 2), historial_promedios)
xlabel('Indice el valor analizado')
ylabel('Promedio en dicho valor')
title('Promedio según los valores analizados')
yline(historial_promedios(1))
grid on;

% Gráfica de los valores y su promedio
figure
barras = bar(1:size(vector_nuevo, 2), vector_nuevo, 'FaceColor', 'flat');
barras.CData = colores;
hold on;
scatter(1:size(historial_promedios, 2), historial_promedios, 'filled', 'black')
title('Promedios vs valores nuevos')
xlabel('Indice del valor nuevo')
ylabel('Valor nuevo analizado')
legend('Valores de análisis (Rojo: Novedades)', 'Promedio')
grid on;
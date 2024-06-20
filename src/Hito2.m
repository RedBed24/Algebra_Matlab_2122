% Autor: Samuel Espejo Gil

% Travel time calculado previamente
% El método de calcular las rutas es igual para todas, simplemente se
% cambian los nodos de incio y fin

%% primera ruta
% mostrar
fig= figure(2);
ax= axes('Parent', fig);
show_map(ax, bounds, 'Camino Hospital ESI', data_dir, map_filename)
p= plot(G_visual);
p.XData= nodes.lon;
p.YData= nodes.lat;

% calculo del camino mínimo
[camino, tiempos, indices]= shortestpath(G, 4034, 3350);
% calcular tiempo y distancia
disp("Ruta 1: Hospital a la ESI:")
disp("Tiempo: "+sum(tiempos)+"min")
disp("Distancia: "+sum(G.Edges.length(indices))+"m")
disp(" ")
highlight(p, camino, 'EdgeColor', 'b', 'NodeColor', 'b', 'LineWidth', 2);

%% segunda ruta
fig= figure(3);
ax= axes('Parent', fig);
show_map(ax, bounds, 'Camino ITSI Auditorio', data_dir, map_filename)
p= plot(G_visual);
p.XData= nodes.lon;
p.YData= nodes.lat;

% calculo del camino mínimo
[camino, tiempos, indices]= shortestpath(G, 4785, 4082);
% calcular tiempo y distancia
disp("Ruta 2: ITSI al Auditorio:")
disp("Tiempo: "+sum(tiempos)+"min")
disp("Distancia: "+sum(G.Edges.length(indices))+"m")
disp(" ")
highlight(p, camino, 'EdgeColor', 'b', 'NodeColor', 'b', 'LineWidth', 2);

%% tercera ruta
fig= figure(4);
ax= axes('Parent', fig);
show_map(ax, bounds, 'Camino Auditorio ITSI', data_dir, map_filename)
p= plot(G_visual);
p.XData= nodes.lon;
p.YData= nodes.lat;

% calculo del camino mínimo
[camino, tiempos, indices]= shortestpath(G, 4082, 4785);
% calcular tiempo y distancia
disp("Ruta 3: Auditorio al ITSI:")
disp("Tiempo: "+sum(tiempos)+"min")
disp("Distancia: "+sum(G.Edges.length(indices))+"m")
disp(" ")
highlight(p, camino, 'EdgeColor', 'b', 'NodeColor', 'b', 'LineWidth', 2);

%% Limpieza de variables no necesarias para otros hitos:
clear fig ax p camino tiempos indices
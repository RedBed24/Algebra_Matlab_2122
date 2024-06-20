% Incremental practice for Algebra & Discrete Mathematics
% 2021-22
% 
% Name of the student: Samuel Espejo Gil
% Hito 1

% Maps are downloaded from: https://www.openstreetmap.org/
% Remark: To convert from .osm file to the input data, you can use the
% Python script at: https://github.com/AndGem/OsmToRoadGraph

clear
clc;

%% Variable definition
data_dir = 'data/'; % Relative path to the data
map_filename = 'CiudadReal'; % Values: ESI, RondaCiudadReal, CiudadReal

% Set the bounds for the map (do not change)
switch map_filename
    case 'ESI'
        bounds = [-3.9272, -3.9140; 38.9871, 38.9940];
    case 'RondaCiudadReal'
        bounds = [-3.9388, -3.9136; 38.9795, 38.9965];
    case 'CiudadReal'
        bounds = [-3.9568, -3.8964; 38.9670, 39.0038];
    otherwise
        error("Wrong value for variable 'map_filename'");
end

%% Load graph data

[n_nodes, nodes, n_edges, edges] = load_pycgr(data_dir, map_filename);

%% Construct the graph
% Undirected graph for visualization

G_visual= graph(edges.source, edges.target);

% Actual digraph
% Add reverse direction to bidirectional roads (from target to source)

% adelantamos trabajo del hito 2, añadimos el vector travelTime a las
% aristas, calculado con la formula dada ./ hace división elemento a
% elemento
edges.travelTime=edges.length./(edges.maxspeed*0.9)*(60/1000);

anadidos=0;
% i toma los indices de las aristas bidirecionales
for i=find(edges.bidirectional==1)'
    anadidos=anadidos+1;
    edges.source(n_edges+anadidos)= edges.target(i);
    edges.target(n_edges+anadidos)= edges.source(i);
    edges.length(n_edges+anadidos)= edges.length(i);
    edges.maxspeed(n_edges+anadidos)= edges.maxspeed(i);
    edges.travelTime(n_edges+anadidos)= edges.travelTime(i);
    edges.name(n_edges+anadidos)= edges.name(i);
end
% se crea el grafo con una tabla para añadir la información necesaria,
G= digraph(edges.source, edges.target, table(edges.travelTime, edges.length, edges.maxspeed, edges.name, 'VariableNames', {'Weight', 'length', 'maxSpeed', 'name'}));

%% Plot the graph

fig= figure(1);
ax = axes('Parent', fig);
show_map(ax, bounds, map_filename, data_dir, map_filename)
p= plot(G_visual);
p.XData= nodes.lon;
p.YData= nodes.lat;

%% Limpieza de variables no necesarias para otros hitos:
clear fig ax edges i n_nodes p
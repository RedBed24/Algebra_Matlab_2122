% Autor: Samuel Espejo Gil

%% se cagran los datos
ODmatrixdata=xlsread('data/Odmatrix.xlsx');
ODmatrix={};
ODmatrix.IDcentroid= ODmatrixdata(:, 1);
ODmatrix.attracted= ODmatrixdata(:, 2);
ODmatrix.generated= ODmatrixdata(:, 3);

%% calculo de la demanda total
totalDemand= sum(ODmatrix.generated);

%% calculo del flujo

G.Edges.flow=zeros(n_edges+anadidos, 1);
for i=1:size(ODmatrix.IDcentroid)
    for j=1:size(ODmatrix.IDcentroid)
        if i~=j
            [spt, foo, idx]=shortestpath(G, ODmatrix.IDcentroid(i), ODmatrix.IDcentroid(j));
            % se saca el camino mínimo, y para las aristas del camino se
            % incrementa el flujo como se indica en la fórmula
            G.Edges.flow(idx)= G.Edges.flow(idx)+ODmatrix.generated(i)*ODmatrix.attracted(j)/totalDemand;
        end
    end
end

%% representación

G_visual.Edges.LineW= zeros(n_edges, 1);
for i=1:n_edges
    
    % se busca la arista en un sentido y en el otro
    idx1=findedge(G, G_visual.Edges.EndNodes(i, 1), G_visual.Edges.EndNodes(i, 2));
    idx2=findedge(G, G_visual.Edges.EndNodes(i, 2), G_visual.Edges.EndNodes(i, 1));
    
    if idx1~=0 && idx2~=0 % si ambos caminos existe (la arista es bidireccional)
        G_visual.Edges.LineW(i)= 8*(G.Edges.flow(idx1)+G.Edges.flow(idx2))/max(G.Edges.flow);
    elseif idx1~=0
        G_visual.Edges.LineW(i)= 16*G.Edges.flow(idx1)/max(G.Edges.flow);
    elseif idx2~=0
        G_visual.Edges.LineW(i)= 16*G.Edges.flow(idx2)/max(G.Edges.flow);
    end
    
    if G_visual.Edges.LineW(i)<0.2 % para poner un mínimo
        G_visual.Edges.LineW(i)= 0.2;
    end
end

fig= figure(1);
ax = axes('Parent', fig);
show_map(ax, bounds, map_filename, data_dir, map_filename)
p= plot(G_visual);
p.XData= nodes.lon;
p.YData= nodes.lat;
% se asigna la anchura de las líneas
p.LineWidth = G_visual.Edges.LineW;
p.NodeColor= 'b';
p.EdgeColor= 'b';
% se marcan los centroides
highlight(p,ODmatrix.IDcentroid, 'NodeColor', 'r', 'MarkerSize', 5);

%% Limpieza de variables no necesarias para otros hitos:
clear i j spt foo idx fig ax p idx1 idx2 i ODmatrixdata
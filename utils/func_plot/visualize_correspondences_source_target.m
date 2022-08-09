function visualize_correspondences_source_target(S1, S2, T12)

S2 = shift_mesh_target(S1, S2);

[g1,g2,g3] = set_mesh_color(S1);

% Visualize the source and target meshes 
visualize_map_on_source(S1, S2, T12); hold on
visualize_map_on_target(S1, S2, T12)

% Plots the correspondences between meshes' vertices
per_ = floor(length(S1.surface.X)/25);

X1 = S1.surface.X(1:per_:end);      Y1 = S1.surface.Y(1:per_:end);      Z1 = S1.surface.Z(1:per_:end);
X2 = S2.surface.X(T12(1:per_:end)); Y2 = S2.surface.Y(T12(1:per_:end)); Z2 = S2.surface.Z(T12(1:per_:end));

f1 = 1 - g1(T12(1:per_:end));
f2 = 1 - g2(T12(1:per_:end));
f3 = 1 - g3(T12(1:per_:end));

for i = 1:length(X1)
    % Plots the line correspondes
    plot3([X1(i) X2(i)]', ...
          [Y1(i) Y2(i)]', ...
          [Z1(i) Z2(i)]', 'color', [f1(i); f2(i); f3(i)], 'linewidth', 1.5); hold on
      
    % Plots the meshes' vertices
    plot3(X1(i), Y1(i), Z1(i), '.', 'color', [f1(i); f2(i); f3(i)], 'markersize', 20)
    plot3(X2(i), Y2(i), Z2(i), '.', 'color', [f1(i); f2(i); f3(i)], 'markersize', 20)
end
end

function S2 = shift_mesh_target(S1, S2)
    S2.surface.X = S2.surface.X + 0.6*(max(S1.surface.X) - min(S1.surface.X));
    S2.surface.Y = S2.surface.Y + 0.6*(max(S1.surface.Y) - min(S1.surface.Y));
    S2.surface.Z = S2.surface.Z + 0.6*(max(S1.surface.Z) - min(S1.surface.Z));
end

function [g1,g2,g3] = set_mesh_color(S)
    g1 = normalize_function(0, 1, S.surface.X);
    g2 = normalize_function(0, 1, S.surface.Y);
    g3 = normalize_function(0, 1, S.surface.Z);
    g1 = reshape(g1, [], 1);
    g2 = reshape(g2, [], 1);
    g3 = reshape(g3, [], 1);
end

function fnew = normalize_function(min_new, max_new, f)
    fnew = f - min(f);
    fnew = (max_new - min_new)*fnew/max(fnew) + min_new;
end
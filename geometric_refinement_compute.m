clc; clear; close all;
% input your 3D path
path = ".\cast_off_confidentiality\";
% path = ".\test\";
res_file = fullfile(path, 'geometric_refinement.txt');
cates = dir(path);

for i = 3 : length(cates) 
    cur_folder = cates(i).folder;
    cur_name = cates(i).name;
    filename = fullfile(cur_folder, cur_name, "Model.obj");
    fprintf("---Computing %s---\n", cur_name);
    % load data
    [vertices, faces, vn, vt, tf, nf] = readOBJ_f(filename);
    % compute the geometric refinement
    geometric_refinement = compute_geometric_refinement(vertices, faces);
    % convert unit to mm
    geometric_refinement = geometric_refinement * 1000;
    % write the geometric refinement
    write_res(res_file, cur_name, geometric_refinement)    
end
fprintf("---Complete!---\n");


function geometric_refinement = compute_geometric_refinement(vertices, faces)
    IDX1 = faces(:, 1);
    P1 = vertices(IDX1, :);
    
    IDX2 = faces(:, 2);
    P2 = vertices(IDX2, :);
    
    IDX3 = faces(:, 3);
    P3 = vertices(IDX3, :);
    
    L1 = sum((P2 - P1).^2, 2);
    L2 = sum((P3 - P2).^2, 2);
    L3 = sum((P1 - P3).^2, 2);
    
    geometric_refinement = (mean(L1) + mean(L2) + mean(L3)) / 3;
    
    fprintf("The geometric refinement of your 3D model：%6f m\n", geometric_refinement);
end

function write_res(file, name, res)
    current_datetime = datetime();
    current_datetime_str = datestr(current_datetime);
    fid = fopen(file, 'a+');
    fprintf(fid, "[%s] [%s] Geometric Refinement: %.8f mm\n", current_datetime_str, name, res);
    fclose(fid);
end
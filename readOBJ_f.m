function [vertices, faces, vn, vt, tf, nf] = readOBJ_f(filename)
    opts = delimitedTextImportOptions('Delimiter',' ');
    data = readtable(filename,opts);
    
    %% parse vertices
    idx1 = strcmp(data.Var1, 'v');
    if ~isempty(idx1)
        vertices = data(idx1, 2 : 4);
        vertices = str2double(table2array(vertices));
    else
        vertices = [];
    end
    
    %% parse faces
    idx2 = strcmp(data.Var1, 'f');
    if ~isempty(idx2)
        f = data(idx2, 2 : 4);
        faceNum = size(f, 1);
        testStr = table2array(f(1, 1));
        testStr = cell2mat(testStr);
        if length(strfind(testStr, '/')) == 2
            f1 = getDouble(f(:, 1));
            f2 = getDouble(f(:, 2));
            f3 = getDouble(f(:, 3));
            faces = [f1(:, 1), f2(:, 1), f3(:, 1)];
            tf    = [f1(:, 2), f2(:, 2), f3(:, 2)];
            nf    = [f1(:, 3), f2(:, 3), f3(:, 3)];

        elseif length(strfind(testStr, '/')) == 1
            f1 = getDouble(f(:, 1));
            f2 = getDouble(f(:, 2));
            f3 = getDouble(f(:, 3));
            faces = [f1(:, 1), f2(:, 1), f3(:, 1)];
            tf    = [];
            nf    = [f1(:, 2), f2(:, 2), f3(:, 2)];
            
        else
            faces = str2double(table2array(f));
            tf = [];
            nf = [];
        end
    else
        faces = [];
        tf = [];
        nf = [];
    
    end

    %% parse vt
    idx3 = strcmp(data.Var1, 'vt');
    if ~isempty(idx3)
        vt = data(idx3, 2 : 3);
        vt = str2double(table2array(vt));
    else
        vt = [];
    end
    
    %% parse vn
    idx4 = strcmp(data.Var1, 'vn');
    if ~isempty(idx4)
        vn = data(idx4, 2 : 4);
        vn = str2double(table2array(vn));
    else
        vn = [];
    end
end

function col_double = getDouble(col)
    col_array = table2array(col);
    split_col_array = cellfun(@(x) strsplit(x, '/'), col_array, 'UniformOutput', false);
    col_str = vertcat(split_col_array{:});
    col_double = str2double(col_str);
end
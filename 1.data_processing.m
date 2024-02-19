[network_, features_sel] = read_and_process();

[n_individuals_, ~ ]= size(network_);
[n_individuals, n_items] = size(features_sel);
if n_individuals_ ~= n_individuals
   disp("The dimension of network and features_selected don't match")
end
clear n_individuals_

write_school_data(network_, features_sel, n_items, n_individuals);


function [network_, features_sel] =  read_and_process()
%% setup

directory = pwd;
cd(directory);

verbose = 1;
% we only pick the 129 selected students (without any nan in any period of time) from the dataset
sel129 = xlsread("sel129.csv"); 
sel = sel129;

% read friends

fr1 = xlsread("fr1.csv"); % first period (actually second school year)
fr2 = xlsread("fr2.csv"); % second period (actually third school year)
fr3 = xlsread("fr3.csv"); % third period (actually fourth school year)

frall = fr1 + fr2 + fr3; % together with the following processing, it 
                         % becomes a disjunction (logical or-operator)

%% process friends
% The encoding rules are : 1 for friend, 2 for best friend, 10 for NAN


if false % in case fr1 fr2 fr3 need separate processing
    for i = 1:160  % processing fr1
        for j= 1:160
            if fr1(i, j) >= 10
                fr1(i, j) = NaN;
            end
            if fr1(i, j) >= 2
                fr1(i, j) = 1;
            end
        end
    end
    clear i; clear j;
    
    
    for i = 1:160  % processing fr2
        for j= 1:160
            if fr2(i, j) >= 10
                fr2(i, j) = NaN;
            end
            if fr2(i, j) >= 2
                fr2(i, j) = 1;
            end
        end
    end
    clear i; clear j;
    
    for i = 1:160  % processing fr3
        for j= 1:160
            if fr3(i, j) >= 10
                fr3(i, j) = NaN;
            end
            if fr3(i, j) >= 2
                fr3(i, j) = 1;
            end
        end
    end
    clear i; clear j;
end

for i = 1:160 % processing friend_all (disjunction)
    for j= 1:160
        if frall(i, j) >= 10
            frall(i, j) = NaN;
        end
        if frall(i, j) >= 2
            frall(i, j) = 1;
        end
    end
end
clear i; clear j;


disp("set up finished")

%% read alcohol, tabacco and cannabis

alc = xlsread("alc.csv"); 
alc1 = alc(:, 1); alc2 = alc(:, 2); alc3 = alc(:, 3); 
alc1 = fillmissing(alc1, 'constant', mode(alc1));  % replace missing value with the mode in respective period of time
alc2 = fillmissing(alc2, 'constant', mode(alc2));
alc3 = fillmissing(alc3, 'constant', mode(alc3));
tbc = xlsread("tbc.csv");
tbc1 = tbc(:, 1); tbc2 = tbc(:, 2); tbc3 = tbc(:, 3);
tbc1 = fillmissing(tbc1, 'constant', mode(tbc1));
tbc2 = fillmissing(tbc2, 'constant', mode(tbc2));
tbc3 = fillmissing(tbc3, 'constant', mode(tbc3));
can = xlsread("can.csv");
can1 = can(:, 1); can2 = can(:, 2); can3 = can(:, 3);
can1 = fillmissing(can1, 'constant', mode(can1));
can2 = fillmissing(can2, 'constant', mode(can2));
can3 = fillmissing(can3, 'constant', mode(can3));


disp("data reading finished.")

%% clean data
%- remove NaN values, or select individuals without nan values

% need to select the individuals that don't present any NaN in those
% features

nan_matrix = isnan([alc1 alc2 alc3 tbc1 tbc2 tbc3 can1 can2 can3]); % we need to read alc. etc in original form which keeps the NaN
has_all_features = sum(nan_matrix, 2)==0;
sel1 = sel.*has_all_features==1;

% make sure everyone has a friend at least, which is guaranteed by
% the feature : selection129, or sel
% This is done by iteratively remove individuals that are eliminated (for
% having no friends.) Practically, a boolean vector of selection, sel1, is 
% iteratively updated.

if verbose
    fprintf("There is %d NaN found in friendship among selected individuals.\n", sum(isnan(frall(sel, sel)), 'all')); 
end
sel2 = sel1;
for i = 1:160
    if sel1(i) == 0
        continue
    end
    if sum(frall(i, sel1)) == 0
        sel2(i) = 0;
    end
end
while sum(sel2-sel1) ~= 0 % maybe friends were removed by the last step
   sel1 = sel2;
   for i = 1:160
        if sel1(i) == 0
            continue
        end
        if sum(frall(i, sel1)) == 0
            sel2(i) = 0;
        end
   end
end



disp("Rows containing NaN have been identified.")
fprintf("Selected %d features out of 160.\n", sum(sel2))

%% define network and features

network_ = frall(sel2, sel2)==1; % convert to logical 

%%

% we are using alc1>=(5,4,3,2), tbc1>=(3,2), can1>=(4,3,2), music1(column 1-16), leisure1(column 1-16)
% now we combine them into a matrix. Rows are people. Columns are features.
features = [alc1>=5 alc1>=4 alc1>=3 alc1>=2 tbc1>=3 tbc1>=2 can1>=4 can1>=3 can1>=2 alc2>=5 alc2>=4 alc2>=3 alc2>=2 tbc2>=3 tbc2>=2 can2>=4 can2>=3 can2>=2 alc3>=5 alc3>=4 alc3>=3 alc3>=2 tbc3>=3 tbc3>=2 can3>=4 can3>=3 can3>=2];
features_sel = features(sel2, :);

disp("data processing finished.")
end


function [] = write_school_data(EI, V, n_items, n_individuals)
    
    disp(174)
    %% write v_data_school
    fileID = fopen(fullfile(pwd, "v_data_school.txt"), "w");

    for t = 1:n_items
        for i = 1:n_individuals
            fprintf(fileID, int2str(V(i, t)));
            fprintf(fileID, " ");
        end
        fprintf(fileID, "\n");
    end
    
    clear i;
    clear t;
    disp("v_data_school written successfully.")

    %% write graph_data_school

    fileID = fopen(fullfile(pwd, "graph_data_school.txt"), "w");

    for i = 1:n_individuals
        for j = 1:n_individuals
            if EI(i, j)
                fprintf(fileID, int2str(i));
                fprintf(fileID, " ");
                fprintf(fileID, int2str(j));
                fprintf(fileID, "\n");
            end
        end
    end
    clear i;
    clear j;
    disp("graph_data_school written successfully.")
end




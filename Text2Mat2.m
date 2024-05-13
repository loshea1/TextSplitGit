%Working version of splitting up the text document to the specific elements
%for all data sets. If there is a dataset with a different .txt format,
%then a new function needs to be created 

clear
clc

path = addpath('Z:\Leah Summer 2021\Projects\MiTsS\CODE\MATLAB\TextSplit_Master');
load('AllData.mat')
global AllData

% Use dir to get info about files in current folder with '.txt' extension
files = dir(fullfile(pwd, '*.txt'));
numTxtFiles = numel(files); % Count the number of '.txt' files

for i = 1:numTxtFiles
    
    file = files(i).name;
    fid = fopen(file, 'r');
    
    Data = textscan(fid, '%s', 'delimiter', '\n');
    Data = table2array(rmmissing(cell2table(Data{1,1})));
    
    expression = '([^_]+)_(.+)\.';
    sPlit = regexp(file, expression, 'tokens');
    
    subID = sPlit{1}{1};
    trial = sPlit{1}{2};
    
    %looks at the third line of data (because for the new collection there
    %can either be two rows of content before the data collection or every
    %other row is raw so it should be raw either way) and determines if 
    %'raw' is NOt in the string. (~) indicates "not". Want to be consistent
    %with Pseudo Machine Learning: 1 (true) means V1 or V3 and 0 (fasle)
    %means V2
    
    textID = ~contains(string(Data{3,1}), 'raw');
    
    if textID == 0
        %find occruence of "filtered: raw:"
        index = strfind(Data,"filtered: raw:");
        
        for i = 1:length(Data)
            if index{i,1} > 0
                %create a variable that splits the cell into filt and raw
                n = strsplit(Data{i,1}, 'filtered:');
                %reorder cell array
                Data =[Data(1:i-1,:);'filtered: '; n{1,2};Data(i+1:end,:)];
            end
            
        end
    end
    
    data = Data{1,1};
    a = strcmp(data(1:3),'REC');
    b = strcmp(data(1:3),'ROM');
    
    %Determine which kind of data format it is
    if (textID == 1) && (a ~= 1) && (b~=1)
        trial = [trial(2:end) trial(1)];
        version1(Data, subID, trial);
    elseif textID == 0
        trial = [trial(2:end) trial(1)];
        version2(Data, subID, trial);
    elseif((textID == 1) && ((a == 1) || (b==1)))
        if length(Data{2,1}) ~= 3
            clin = subID;
            fullPath = fullfile(pwd);
            [~, subID, ~] = fileparts(fullPath);
            version3(Data, subID, clin, trial);
        else
            clin = subID;
            fullPath = fullfile(pwd);
            [~, subID, ~] = fileparts(fullPath);
            version4(Data, subID, clin, trial);
        end
    end
    
    save('\\fs2.smpp.local\SMULAB2\Leah Summer 2021\Projects\MiTsS\CODE\MATLAB\TextSplit_Master\AllData.mat', 'AllData');
    
    fclose(fid);
end
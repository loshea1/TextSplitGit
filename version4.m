%================ IF IT IS THE VERSION 4 OF DATA COLLECTION ==============%
%================ Corresponds with Max's Code ============================%

function version4(Data, subID, clin, trial)
%From MaxReadText.m
global AllData

%format long g
headers = {'t', 'Y', 'A', 'T'};

try
    data = cell(1,4);
    
    % Initialize counters for each section
    section_counter = 1;
    line_counter = 1;
    row = 1;

    for i = 1:length(Data)
        
        % Read a line from the file
        line = Data{i,1};

        % Check if the line is empty or starts with 'REC EVENT:' or 'ROM EVENT:'
        if isempty(line) || strcmp(line, 'REC EVENT: ') || strcmp(line, 'ROM EVENT: ')
            % Extracting test variable
            test = line(1:3);
            continue;
        end

        % Determine the section based on the line content dynamically
        section_identifier = strtok(line);
        if section_identifier(end) == ':'
            section = strrep(section_identifier(1:end-1), char(0), '');
            section_counter = find(strcmp(headers, section));
            line_counter = line_counter + 1;
            row = 1;
            continue;
        end

        % Split the line into numeric values
        values = str2double(line);

        % Store the values in the appropriate cell of the data cell array
        %AllData.(subID).(test).headers{1,section_counter} = values;
        data{row, section_counter} = values;
        % Increment counters
        line_counter = line_counter + 1;
        row = row + 1;
    end

    data(end, :) = [];

  AllData.(subID).(clin).(trial).(test).Original = data;
  AllData.(subID).(clin).(trial).(test).Time_s = data(:,1);
  AllData.(subID).(clin).(trial).(test).Pos_Y = data(:,2);
  AllData.(subID).(clin).(trial).(test).Acc_Y = data(:,3);
  AllData.(subID).(clin).(trial).(test).Tot_Sen = data(:,4);
  
catch ME
    % Handle any errors that occur during file processing
    disp(['Error: ' ME.message]);
    if exist('fid', 'var') && fid > 0
        fclose(fid);
    end
    
end

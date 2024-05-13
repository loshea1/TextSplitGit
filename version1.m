%================ IF IT IS THE VERSION 1 OF DATA COLLECTION ==============%
%=================== 01, 02, & 06 are V1 =================================%

function version1(Data, subID, trial)
    global AllData
    filebycolumn = cellfun(@(x) strsplit(x, ','), Data, 'UniformOutput', false);
    fieldarray = vertcat(filebycolumn{:});
    
    %Create structure to save to%
    structVars = struct('Original',[],'Time_s',[],'Time_count',[],'Pos_X',[],'Pos_Y',[],...
        'Pos_Z',[],'Acc_X',[],'Acc_Y',[],'Acc_Z',[],'Gyro_X',[],'Gyro_Y',[],...
        'Gyro_Z', [], 'Grav_X', [], 'Grav_Y', [], 'Grav_Z', [], 'SEN', [], ...
        'H', [], 'Tot_Sen', []);
    
    AllData.(subID).(trial) = struct('Raw', structVars,'Filt', structVars);

    %Convert cell array to a table with the headers
    T = cell2table(fieldarray);
    
    if width(T)==13
        T(:, 13) = []; %Delete the last column
    end
    
    % Convert to numbers
    for i = 1:12
        T.(i) = str2double(T{:,i});
    end
    T = table2array(T);
    
    AllData.(subID).(trial).Raw.Original   = fieldarray;  %Raw data
    AllData.(subID).(trial).Raw.Time_count = T(:,1);      %Time_count
    AllData.(subID).(trial).Raw.Pos_X      = T(:,2);      %X pos
    AllData.(subID).(trial).Raw.Pos_Y      = T(:,3);      %Y pos
    AllData.(subID).(trial).Raw.Pos_Z      = T(:,4);      %Z pos
    AllData.(subID).(trial).Raw.Acc_X      = T(:,5);      %X Acc (U)
    AllData.(subID).(trial).Raw.Acc_Y      = T(:,6);      %Y Acc (V)
    AllData.(subID).(trial).Raw.Acc_Z      = T(:,7);      %Z Acc (W)
    AllData.(subID).(trial).Raw.Gyro_X     = T(:,10);     %X Gyro (A)
    AllData.(subID).(trial).Raw.Gyro_Y     = T(:,11);     %Y Gyro (B)
    AllData.(subID).(trial).Raw.Gyro_Z     = T(:,12);     %Z Gyro (C)
    AllData.(subID).(trial).Raw.SEN        = T(:,8);      %Sen S
    AllData.(subID).(trial).Raw.H          = T(:,9);      %Sen H
    
    % Make sure position values go from 0 to 180
    for i = 2:4
        for j = 1:length(T)
            if T(j,i) > 360
                %T(j,i) = abs(T(j,i)-360);
                T(j,i) = (T(j,i)+180)/360;
            else
                %T(j,i) = abs(T(j,i));
                T(j,i) = T(j,i);
            end
        end
    end
    
    for i = 2:4
        M = min(T(:,i));
        for j = 1:length(T)
            T(j,i) = (T(j,i) - M);
        end
    end
    T = array2table(T);
    
    %Filter the Force Data
    x = [table2array(T(:, 8)), table2array(T(:, 9))];
    fs=355; %Sampling frequency
    
    for i = 1:size(x,2)
        %Savitzky-Golay filter (data, filter order, frame length)
        y(:,i) = sgolayfilt(x(:,i),3,15);
    end
    
    %Replace the filtered data
    T(:,8) = array2table(y(:,1));
    T(:,9) = array2table(y(:,2));
    
    % Find total Sensor value and zero
    b = T{1,8}-T{1,9};             %subtract the first sensor by the second
    Q = T{:,8} - T{:,9};           %Do that for the entire column
    P = array2table(Q(:,:)- b);    %zero by subtracting b (Tot_sen)
    
    %Convert time from microseconds to seconds and zero
    t = table2array(T(1,1))*(10^(-6));   %t is the initial start time
    W = table2array(T(:,1))*(10^(-6))-t; %Time vector in seconds and zeroed
    X = table2array(T(:, 5));            %X acceleration vector
    Y = table2array(T(:, 6));            %Y acceleration vector
    Z = table2array(T(:, 7));            %Z acceleration vector
    
    % Add new variables to table
    T{:,1} = W; %Change the time to the zeroed time
    T = [T P];
    
    %Delete the last row of table T (zeros mess up the graph in excel)
    T(end,:) = [];
    
    AllData.(subID).(trial).Filt.Original = table2array(T);  %Raw data
    AllData.(subID).(trial).Filt.Time_s  = T(:,1);   %Time
    AllData.(subID).(trial).Filt.Pos_X   = T(:,2);   %X pos
    AllData.(subID).(trial).Filt.Pos_Y   = T(:,3);   %Y pos
    AllData.(subID).(trial).Filt.Pos_Z   = T(:,4);   %Z pos
    AllData.(subID).(trial).Filt.Acc_X   = T(:,5);   %X Acc (U)
    AllData.(subID).(trial).Filt.Acc_Y   = T(:,6);   %Y Acc (V)
    AllData.(subID).(trial).Filt.Acc_Z   = T(:,7);   %Z Acc (W)
    AllData.(subID).(trial).Filt.Gyro_X  = T(:,10);  %X Gyro (A)
    AllData.(subID).(trial).Filt.Gyro_Y  = T(:,11);  %Y Gyro (B)
    AllData.(subID).(trial).Filt.Gyro_Z  = T(:,12);  %Z Gyro (C)
    AllData.(subID).(trial).Filt.SEN     = T(:,8);   %Sen S
    AllData.(subID).(trial).Filt.H       = T(:,9);   %Sen H
    AllData.(subID).(trial).Filt.Tot_Sen = T(:,13);  %Tot Sens
end


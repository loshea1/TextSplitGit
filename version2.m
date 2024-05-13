%===========IF IT IS VERSION 2 OF DATA COLLECTION=========================%
%=============== 03, 04, 05, 08, & 09 are V2 =============================%

function version2(Data, subID, trial)
global AllData

%Create structure to save to%
structVars = struct('Original',[],'Time_s',[],'Time_count',[],'Pos_X',[],'Pos_Y',[],...
    'Pos_Z',[],'Acc_X',[],'Acc_Y',[],'Acc_Z',[],'Gyro_X',[],'Gyro_Y',[],...
    'Gyro_Z', [], 'Grav_X', [], 'Grav_Y', [], 'Grav_Z', [], 'SEN', [], ...
    'H', [], 'Tot_Sen', []);

AllData.(subID).(trial) = struct('Raw', structVars,'Filt', structVars);

Rlength = 0;
Flength = 0;

for i = 1:length(Data)
    if (Data{i}(1) == 'r')
        Rlength = Rlength+1;
        AllData.(subID).(trial).Raw.Original{Rlength, 1} = Data{i};
        splitData = strsplit(Data{i}, ':');
        if numel(splitData) >1
            RawSplitData{Rlength, 1} = splitData{2};
        else
            RawSplitData{Rlength, 1} = 0;
        end
    end
    if (Data{i}(1) == 'f')
        Flength = Flength+1;
        AllData.(subID).(trial).Filt.Original{Flength, 1} = Data{i};
        splitData = strsplit(Data{i}, ':');
        if numel(splitData) >1
            FiltSplitData{Flength, 1} = splitData{2};
        else
            FiltSplitData{Flength, 1} = 0;
        end
    end
end

test = {'Raw', 'Filt'};
count = 1;

for j = 1:2
    if j == 1
        span = length(RawSplitData);
    else
        span = length(FiltSplitData);
    end
    
    for i = 1:span
        if j == 1
            if ischar(RawSplitData{i})
             matches = regexp(RawSplitData{i}, '([a-zA-Z])([^a-zA-Z]*)', 'tokens');
            end
        else
            if ischar(FiltSplitData{i})
             matches = regexp(FiltSplitData{i}, '([a-zA-Z])([^a-zA-Z]*)', 'tokens');
            end
        end
        
        if ~isempty(matches)
            if matches{1,1}{1,1} == 't'
                if j == 1
                    AllData.(subID).(trial).Raw.Time_count{count,1} = matches{1,1}{1,2};
                elseif j == 2
                    AllData.(subID).(trial).Filt.Time_s{count,1} = matches{1,1}{1,2};
                end
            elseif matches{1,1}{1,1} == 'x'
                AllData.(subID).(trial).(test{j}).Pos_X{count,1} = matches{1,1}{1,2};
            elseif matches{1,1}{1,1} == 'u'
                AllData.(subID).(trial).(test{j}).Acc_X{count,1} = matches{1,1}{1,2};
            elseif matches{1,1}{1,1} == 'a'
                AllData.(subID).(trial).(test{j}).Gyro_X{count,1} = matches{1,1}{1,2};
            elseif matches{1,1}{1,1} == 'p'
                AllData.(subID).(trial).(test{j}).Grav_X{count,1} = matches{1,1}{1,2};
            end
            if length(matches) == 2
                if matches{1,2}{1,1} == 's'
                    if j == 1
                        AllData.(subID).(trial).Raw.SEN{count,1} = matches{1,2}{1,2};
                    elseif j ==2
                        AllData.(subID).(trial).Filt.Tot_Sen{count,1} = matches{1,2}{1,2};
                    end
                elseif matches{1,2}{1,1} == 'y'
                    AllData.(subID).(trial).(test{j}).Pos_Y{count,1} = matches{1,2}{1,2};
                elseif matches{1,2}{1,1} == 'v'
                    AllData.(subID).(trial).(test{j}).Acc_Y{count,1}  = matches{1,2}{1,2};
                elseif matches{1,2}{1,1} == 'b'
                    AllData.(subID).(trial).(test{j}).Gyro_Y{count,1} = matches{1,2}{1,2};
                elseif matches{1,2}{1,1} == 'q'
                    AllData.(subID).(trial).(test{j}).Grav_Y{count,1} = matches{1,2}{1,2};
                end
            end
            if length(matches) == 3
                if matches{1,3}{1,1} == 'h'
                    AllData.(subID).(trial).(test{j}).H{count,1} = matches{1,3}{1,2};
                elseif matches{1,3}{1,1} == 'z'
                    AllData.(subID).(trial).(test{j}).Pos_Z{count,1} = matches{1,3}{1,2};
                elseif matches{1,3}{1,1} == 'w'
                    AllData.(subID).(trial).(test{j}).Acc_Z{count,1}  = matches{1,3}{1,2};
                elseif matches{1,3}{1,1} == 'c'
                    AllData.(subID).(trial).(test{j}).Gyro_Z{count,1} = matches{1,3}{1,2};
                elseif matches{1,3}{1,1} == 'r'
                    AllData.(subID).(trial).(test{j}).Grav_Z{count,1} = matches{1,3}{1,2};
                    count = count + 1;
                end
            end
        else
            count = count+1;
        end
    end
    count = 1;
end


%================= Make sure the arrays are equal to 500 =================%
Vars = {'Time_s','Time_count','Pos_X','Pos_Y','Pos_Z','Acc_X',...
    'Acc_Y','Acc_Z','Gyro_X','Gyro_Y','Gyro_Z','Grav_X','Grav_Y','Grav_Z',...
    'SEN','H','Tot_Sen'};

for j = 1:2
    for i = 1:numel(Vars)
        if ~isempty(AllData.(subID).(trial).(test{j}).(Vars{i}))
            
            currentValue = length(AllData.(subID).(trial).(test{j}).(Vars{i}));
            
            if  currentValue < 500
                size = 500 - currentValue;
                add = cell(size, 1);
                AllData.(subID).(trial).(test{j}).(Vars{i}) = vertcat(AllData.(subID).(trial).(test{j}).(Vars{i}), add);
            elseif currentValue > 500
                size = currentValue - 500;
                AllData.(subID).(trial).(test{j}).(Vars{i}) = AllData.(subID).(trial).(test{j}).(Vars{i})(1:end-size);
            end
        end
    end
end
end
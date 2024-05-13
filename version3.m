%================ IF IT IS THE VERSION 3 OF DATA COLLECTION ==============%
%================03/08/22 Testing. 10, 11, 12 ============================%

%  For this testing, filtering was done off-line. In the text document f is
%  for the filtered time and total sensor values

function version3(Data, subID, clin, trial)
global AllData

    %Create structure to save to%
    AllData.(subID).(clin).(trial) = struct('Original',[],'Time_s',[],...
        'Time_count',[],'Pos_X',[],'Pos_Y',[],'Pos_Z',[],'Acc_X',[],...
        'Acc_Y',[],'Acc_Z',[],'Gyro_X',[],'Gyro_Y',[],'Gyro_Z', [],...
        'Grav_X',[],'Grav_Y',[],'Grav_Z',[],'SEN',[],'H',[],'Tot_Sen',[]);
    
    AllData.(subID).(clin).(trial).Original = Data;
    
    Rlength = 0;
    Flength = 0;
    
    for i = 2:length(Data)
        if (Data{i}(2) == 'r')
            Rlength = Rlength+1;
            splitData = strsplit(Data{i}, ':');
            RawSplitData{Rlength, 1} = splitData{2};
        end
        if (Data{i}(2) == 'f')
            Flength = Flength+1;
            splitData = strsplit(Data{i}, ':');
            FiltSplitData{Flength, 1} = splitData{2};
        end
    end
    
    %remove all f: blanks
    FiltSplitData(2:2:end)=[];
    
    count = 1;
    for i = 1:length(FiltSplitData)
        matches = regexp(FiltSplitData{i}, '([a-zA-Z])([^a-zA-Z]*)', 'tokens');
        
        if matches{1,1}{1,1} == 't'
            AllData.(subID).(clin).(trial).Time_s{count,1} = matches{1,1}{1,2};
        end
        if  matches{1,2}{1,1} == 's'
            AllData.(subID).(clin).(trial).Tot_Sen{count,1} = matches{1,2}{1,2};
        end
        count = count + 1;
    end

    count = 1;
    for i = 1:length(RawSplitData)
        
        matches = regexp(RawSplitData{i}, '([a-zA-Z])([^a-zA-Z]*)', 'tokens');
        
        if matches{1,1}{1,1} == 't'
            AllData.(subID).(clin).(trial).Time_count{count,1} = matches{1,1}{1,2};
        elseif matches{1,1}{1,1} == 'x'
            AllData.(subID).(clin).(trial).Pos_X{count,1} = matches{1,1}{1,2};
        elseif matches{1,1}{1,1} == 'u'
            AllData.(subID).(clin).(trial).Acc_X{count,1} = matches{1,1}{1,2};
        elseif matches{1,1}{1,1} == 'a'
            AllData.(subID).(clin).(trial).Gyro_X{count,1} = matches{1,1}{1,2};
        elseif matches{1,1}{1,1} == 'p'
            AllData.(subID).(clin).(trial).Grav_X{count,1} = matches{1,1}{1,2};
        end
        
        if matches{1,2}{1,1} == 's'
            AllData.(subID).(clin).(trial).SEN{count,1} = matches{1,2}{1,2};
        elseif matches{1,2}{1,1} == 'y'
            AllData.(subID).(clin).(trial).Pos_Y{count,1} = matches{1,2}{1,2};
        elseif matches{1,2}{1,1} == 'v'
            AllData.(subID).(clin).(trial).Acc_Y{count,1}  = matches{1,2}{1,2};
        elseif matches{1,2}{1,1} == 'b'
            AllData.(subID).(clin).(trial).Gyro_Y{count,1} = matches{1,2}{1,2};
        elseif matches{1,2}{1,1} == 'q'
            AllData.(subID).(clin).(trial).Grav_Y{count,1} = matches{1,2}{1,2};
        end
        
        if matches{1,3}{1,1} == 'h'
            AllData.(subID).(clin).(trial).H{count,1} = matches{1,3}{1,2};
        elseif matches{1,3}{1,1} == 'z'
            AllData.(subID).(clin).(trial).Pos_Z{count,1} = matches{1,3}{1,2};
        elseif matches{1,3}{1,1} == 'w'
            AllData.(subID).(clin).(trial).Acc_Z{count,1}  = matches{1,3}{1,2};
        elseif matches{1,3}{1,1} == 'c'
            AllData.(subID).(clin).(trial).Gyro_Z{count,1} = matches{1,3}{1,2};
        elseif matches{1,3}{1,1} == 'r'
            AllData.(subID).(clin).(trial).Grav_Z{count,1} = matches{1,3}{1,2};
            count = count + 1;
        end
    end
end
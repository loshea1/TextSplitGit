%This script is to run during your code that will commit and push all
%changes to current branch in Github

function GitCommit(message)
%CHECKS
    % Check if Git is installed
    [status, ~] = system('git --version');
    if status ~= 0
        error('Git is not installed or not in the system path.');
    end
    % Check if .git directory exists
    if ~exist('.git', 'dir')
        disp('Local Git repository does not exist.');
    end
    % Get user email associated with Git
    [status, ~] = system('git config user.email');
    if status ~= 0
        disp('No email is associated with Git');
    end
%=========================================================================%    
    %If all checks pass:
    system('git add .'); % Add all files to the Git repository
    
    command = ['git commit -m message']; % Commit the changes
    system(command); 
    
    [~ , currBranch] = system('git rev-parse --abbrev-ref HEAD');
    currBranch = strtrim(currBranch);
    
    % Ask user if they want to push changes to currBranch (Y/N)
    pushCurrBranch = input(['Do you want to push changes to current branch: ', currBranch, '? (Y/N): '], 's');
    if strcmpi(pushCurrBranch, 'Y')
        system('git push -u origin HEAD'); % Push the committed changes to the current branch
        disp(['Changes pushed to branch ', currBranch]);
    else
        % List all available branches
        [~, branchOutput] = system('git branch');
        branches = textscan(branchOutput, '%s', 'Delimiter', '\n');
        branches = branches{1};
        
        % Display branches with associated index numbers
        disp('Available branches:');
        for i = 1:numel(branches)
            disp([num2str(i), ': ', branches{i}]);
        end
        
        % Ask the user if they want to push changes to any available branch
        pushOtherBranch = input('Do you want to push changes to any other available branch? (Y/N): ', 's');
        if strcmpi(pushOtherBranch, 'Y')
            % Prompt the user to select a branch
            branchIndex = input('Enter the index number of the branch to push changes to: ');
            
            % Validate the input
            if isscalar(branchIndex) && branchIndex >= 1 && branchIndex <= numel(branches)
                branchName = branches{branchIndex};
                % Switch to the selected branch
                system(['git checkout ', branchName]);
                % Push changes to the selected branch
                system(['git push -u origin ', branchName]);
                disp(['Changes pushed to branch ', branchName]);
            else
                disp('Invalid branch index.');
            end
        else
            disp('No changes were pushed.');
        end
    end
    %ask user if they want to push changes to currBranch (Y/N)
    %if yes, perform next line  
    
    %system('git push -u origin HEAD'); % Push the committed changes to the 'master' branch
    
    %if no, list all avaiable branches. ask user if they want to push
    %changes to any available branch (Y/N)
    
    %if yes, push changes to selected branch index
    
    %if no, disp no changes were pushed. 
end
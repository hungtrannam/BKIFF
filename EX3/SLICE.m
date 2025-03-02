clear;

type = 'EVA';  % Set the type as 'DIS'
file = sprintf('EVA/%s_20.mat', type);
load(file);

if exist('metrics', 'var') && isstruct(metrics)
    fieldNames = fieldnames(metrics);

    % Initialize structures for storing statistical data
    medianValues = struct();
    iqrValues = struct();

    % Prepare data for ANOVA
    group = {};
    anovaData = [];

    % Collecting data and labels for ANOVA
    for i = 1:length(fieldNames)
        fieldName = fieldNames{i};
        if isnumeric(metrics.(fieldName).Time)
            fieldData = metrics.(fieldName).Time;  % Access field data
            
            % Calculate the median of the field data
            medianValues.(fieldName) = median(fieldData);
            iqrValues.(fieldName) = iqr(fieldData);
            
            % Append data for ANOVA
            anovaData = [anovaData; fieldData];
            group = [group; repmat({fieldName}, length(fieldData), 1)];
        else
            fprintf('The field %s contains non-numeric data and was skipped.\n', fieldName);
        end
    end

    % Display the median values
    disp('Median values:');
    disp(medianValues);
    disp('IQR values:');
    disp(iqrValues);

    % Perform ANOVA if there's enough data
    if ~isempty(anovaData)
        ano = anovaData';
        [p, tbl, stats] = kruskalwallis(ano(:), group, 'off');  % Perform ANOVA without displaying the figure
        fprintf('P-value from ANOVA: %f\n', p);
        disp(tbl);  % Display the ANOVA table
    else
        fprintf('No data available for ANOVA.\n');
    end

else
    error('The loaded file does not contain a struct named ''metrics'' or the variable is not a struct.');
end

function logMessage(logFile, message)
    % Ghi thông tin vào file log
    fprintf(logFile, '%s\n', datestr(now)); % Ghi thời gian hiện tại
    fprintf(logFile, '%s\n', message);
end
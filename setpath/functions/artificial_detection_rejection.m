function [T_data, D_data] = artificial_detection_rejection(T_data, T_num, D_data, D_num, threshold_value)
% artificial_detection_rejection - signal processing for artifact detection and rejection
%
% Usage:
%   Preprocessed signal = artificial_detection_rejection(T_data, T_num, D_data, D_num, threshold_value)
%
%
% Inputs:
%   T_data - signal classified as target
%   T_num - number of target trials
%   D_data - signal classified as distracter
%   D_num - number of distracter trials
%   threshold_value - threshold setting for artifact removal
%
% outputs:
%   Preprocessed signal - signal with artifacts removed exceeding the threshold
%
%
%%
i = 1; removeDataInfo = {}; removeData = [];
i2 = 1; removeDataInfo2 = {}; removeData2 = [];

% Artifact removal for target signals exceeding 15
if T_num > 15
    TT_data = T_data;
    for ch = 1:size(T_data, 1)
        for tr = 1:size(T_data, 3)
            if max(T_data(ch,:,tr), [], 'all') > threshold_value
                removeData(i) = max(T_data(ch,:,tr)); % Value exceeding the threshold
                removeDataInfo{i} = [ch, tr, max(T_data(ch,:,tr))]; % Store data exceeding the threshold in {channel, trial, value}
                TT_data(ch,:,tr) = 0;

                i = i + 1;
            end
        end
    end

    % Sort data exceeding the threshold
    [~, sorted_index] = sort(removeData);
    removeDataInfo = removeDataInfo(sorted_index);

    % Add data to ensure at least 15 trials are retained after artifact removal (Add starting from the smallest value)
    for ch = 1:size(T_data, 1)
        for tr = 1:size(T_data, 3)
            if max(T_data(ch,:,tr), [], 'all') > threshold_value
                removeDataInfo_i = true;
                for j = 1:size(removeDataInfo,2)
                    if removeDataInfo{j}(1) == ch && removeDataInfo_i
                        if size(find(TT_data(ch,1,:)),1) < 15
                            TT_data(ch,:,tr) = T_data(ch,:,tr);
                            removeDataInfo{j}(1) = 0; removeDataInfo{j}(2) = 0;

                            removeDataInfo_i = false;
                        end
                    end
                end

            end
        end
    end
    T_data = TT_data;
end

% Artifact removal for distracter signals exceeding 15
if D_num > 15
    DD_data = D_data;
    for ch = 1:size(D_data, 1)
        for tr = 1:size(D_data, 3)
            if max(D_data(ch,:,tr), [], 'all') > threshold_value
                removeData2(i2) = max(D_data(ch,:,tr)); % Value exceeding the threshold
                removeDataInfo2{i2} = [ch, tr, max(D_data(ch,:,tr))]; % Store data exceeding the threshold in {channel, trial, value}
                DD_data(ch,:,tr) = 0;

                i2 = i2 + 1;
            end
        end
    end

    % Sort data exceeding the threshold
    [~, sorted_index] = sort(removeData2);
    removeDataInfo2 = removeDataInfo2(sorted_index);

    % Add data to ensure at least 15 trials are retained after artifact removal (Add starting from the smallest value)
    for ch = 1:size(D_data, 1)
        for tr = 1:size(D_data, 3)
            if max(D_data(ch,:,tr), [], 'all') > threshold_value
                removeDataInfo_i2 = true;
                for j = 1:size(removeDataInfo2,2)
                    if removeDataInfo2{j}(1) == ch && removeDataInfo_i2
                        if size(find(DD_data(ch,1,:)),1) < 15
                            DD_data(ch,:,tr) = D_data(ch,:,tr);
                            removeDataInfo2{j}(1) = 0; removeDataInfo2{j}(2) = 0;

                            removeDataInfo_i2 = false;
                        end
                    end
                end

            end
        end
    end
    D_data = DD_data;
end
end

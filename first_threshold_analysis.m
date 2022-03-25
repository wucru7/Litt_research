feature = load('JAW_59_18_022019_0910_linelength.mat').feature;
max_feature = max(feature);
onset = readtable('JAW_059_19_022019 ON OFF SZ.xlsx');
onset.SZOnset_EDF = onset.SZOnset_EDF.*(41/onset.SZOnset_EDF(1));
onset.SZOffset_EDF = onset.SZOffset_EDF.*(59/onset.SZOffset_EDF(1));
[num, ~] = size(onset);
sz_max_feature = [];
sz_integral_feature = [];
for i = 1:num
    temp = [];
    for j = int32(onset.SZOnset_EDF(i)):int32(onset.SZOffset_EDF(i))
        sz_max_feature = [sz_max_feature max_feature(j)];
        temp = [temp max_feature(j)];
    end
    sz_integral_feature = [sz_integral_feature max(temp)];
end
min_thres = min(sz_max_feature);
max_thres = max(sz_max_feature);
x_axis = min_thres:1.0e+04:max_thres;
interval = length(x_axis);
seizure_interval = length(sz_max_feature);
int_interval = length(sz_integral_feature);
captured = zeros(1, length(x_axis));
int_captured = zeros(1, length(x_axis));
percentage = zeros(1, length(x_axis));
for i = 1:interval
    captured(i) = sum(sz_max_feature>x_axis(i))/seizure_interval;
    int_captured(i) = sum(sz_integral_feature>x_axis(i))/int_interval;
    percentage(i) = sum(sz_max_feature>x_axis(i))/sum(max_feature>x_axis(i));
    disp(sum(sz_max_feature>x_axis(i)))
    disp(sum(max_feature>x_axis(i)))
end
figure(1)
plot(x_axis, captured, 'r')
hold on
plot(x_axis, int_captured, 'g')
hold on
plot(x_axis, percentage, 'b')
xlabel('threshold')
ylabel('percentage')

threshold = x_axis(6);
time = find(max_feature>threshold);
list = ['JAW_59_18_022019_0910.edf'; 'JAW_72_19_071519_1611.edf'; ...
    'JAW_72_19_081019_1133.edf'; 'JAW_72_19_090519_1732.edf'; 'JAW_72_19_111319_1721.edf'];
name = list(1,:);
save(strcat(strcat(name(1:end-4), '_linelength_threshold_'), string(floor(threshold))), 'time');
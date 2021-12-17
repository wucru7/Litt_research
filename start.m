% install matlab signal processing toolbox

% read in data
data = edfread('JAW_59_18_022019_0910.edf');
info = edfinfo('JAW_59_18_022019_0910.edf');
fs = info.NumSamples/seconds(info.DataRecordDuration);
channels = info.SignalLabels;
onset = readtable('JAW_059_19_022019 ON OFF SZ.xlsx');
onset.SZOnset_EDF = onset.SZOnset_EDF.*(41/onset.SZOnset_EDF(1));
onset.SZOffset_EDF = onset.SZOffset_EDF.*(59/onset.SZOffset_EDF(1));

% plot original seizures

% maxtime = max(onset.SZOffset_EDF-onset.SZOnset_EDF);
% figure(1)
% num_channels = length(channels);
% for i = 1:num_channels
%     subplot(6,10,i)
%     % all
%     % t = (0:info.NumSamples(i)*maxtime-1)/fs(i);
%     % one
%     p = 5;
%     t = (0:info.NumSamples(i)*(onset.SZOffset_EDF(p)-onset.SZOnset_EDF(p)))/fs(i);
%         % 2 and 8 and 18 are outliers
%         % all
%         % for j = 1:18
%         % for j = [1,3:7,9:17]
%         % one
%         for j = [p]
%             hold on
%             y = zeros(1,length(t));
%             for k = int32(onset.SZOnset_EDF(j)):int32(onset.SZOffset_EDF(j))-1
%                 y(1+(k-int32(onset.SZOnset_EDF(j)))*fs(i):fs(i)+(k-int32(onset.SZOnset_EDF(j)))*fs(i)) ...
%                     = data.(i){k};
%             end
%             plot(t,y)
%         end
%     title(channels(i))
% end

% resampling
old_freq = 2000;
new_freq = 250;
% linear resampling
new_resample = zeros(height(data)*new_freq, num_channels);
for i = 1:num_channels
    for j = 1:height(data)
        % this = data(j,channels(i)).(channels(i)){1,1};
        this = data.(i){j};
        new_resample(1+(j-1)*new_freq:j*new_freq,i) = this(1:old_freq/new_freq:end);
    end
end

hdr = edfheader("EDF");
hdr.NumSignals = info.NumSignals;
hdr.NumDataRecords = info.NumDataRecords;
hdr.DataRecordDuration = info.DataRecordDuration;
hdr.Reserved = info.Reserved;
hdr.PhysicalMin = info.PhysicalMin;
hdr.PhysicalMax = info.PhysicalMax;
hdr.DigitalMin = info.DigitalMin;
hdr.DigitalMax = info.DigitalMax;
hdr.Patient = info.Patient;
hdr.SignalLabels = info.SignalLabels;
hdr.Recording = info.Recording;
hdr.StartDate = info.StartDate;
hdr.StartTime = info.StartTime;
hdr.TransducerTypes = info.TransducerTypes;
hdr.PhysicalDimensions = info.PhysicalDimensions;
hdr.Prefilter = info.Prefilter;
hdr.SignalReserved = info.SignalReserved;

edfwrite('JAW_59_18_022019_0910_resampled.edf', hdr, new_resample);

% use energy of signal to filter out initial, square of the signal
% various features: entropy, linelength, frequency, autocorrelation. things 
% might happen at different stages. 
% 
% table2array

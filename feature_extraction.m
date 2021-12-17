% data = edfread('JAW_59_18_022019_0910.edf');
% info = edfinfo('JAW_59_18_022019_0910.edf');
channels = info.SignalLabels;
num_channels = length(channels);
freq = info.NumSamples(1);

% extract energy
energy_persec = 1;
energy_freq = freq/energy_persec;
energy_matrix = zeros(num_channels, height(data)*energy_persec);
for i = 1:num_channels
% for i = 1:2
    for j = 1:height(data)
    % for j = 1:10
        this = data.(i){j};
        for k = 1:energy_persec
            temp = this((k-1)*energy_freq+1:k*energy_freq);
            energy_matrix(i,(j-1)*energy_persec+k) = sum(temp.*temp);
        end
    end
end

% extract linelength
ll_persec = 1;
ll_freq = freq/ll_persec;
ll_matrix = zeros(num_channels, height(data)*ll_persec);
for i = 1:num_channels
    for j = 1:height(data)
        this = data.(i){j};
        for k = 1:ll_persec
            temp = this((k-1)*ll_freq+1:k*ll_freq);
            ll_matrix(i,(j-1)*ll_persec+k) = sum(abs(temp));
        end
    end
end

% extract entropy
% entropy_matrix = zeros(num_channels, height(data)*freq-1);
% for i = 1:num_channels
%     this = [];
%     for j = 1:height(data)
%         this = [this, data.(i){j}];
%     end
%     entropy_matrix(i,:)=pentropy(this, freq);
% end

% install econometrics toolbox
% extract autocorrelation
% at_matrix = zeros(num_channels, height(data)*freq);
% for i = 1:num_channels
%     this = [];
%     for j = 1:height(data)
%         this = [this, data.(i){j}];
%     end
%     at_matrix(i,:)=autocorr(this);
% end

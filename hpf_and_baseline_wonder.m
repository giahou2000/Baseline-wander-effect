% MATLAB code to show the effect of High Pass Filter and baseline wonder in
% OOK-NRZ signal

clear;
clc;

Rb = 1e6; % bitrate
Tb = 1/Rb; % bit duration
nsamp = 10; % samples per symbol
Tsamp = Tb/nsamp; % sampling time
Lsym = 1e3; % number of bits
fc_rb = 5e-2; % normalized cut-off frequency
A = 1; % normalized amplitude


%% Calculate impulse response of filters

tx_impulse = ones(1, nsamp) * A; % Tx filter
fc = fc_rb * Rb; % actual cut-off frequency of HPF

t = Tsamp:Tsamp:10*Tb; % time vector
hpf_impulse(1) = 1 * exp(-2*pi*fc*t(1)); % impulse response
for loop=2:length(t)
    hpf_impulse(loop) = -1*(exp(2*pi*fc*t(1))-1)*exp(-2*pi*fc*t(loop));
end


%% Effect of HPF on OOK

OOK = randi([0, 1], 1, Lsym);
OOK = 2 * OOK - 1; % removing DC component
signal = filter(tx_impulse, 1, upsample(OOK, nsamp)); % rectangular pulse shaping
hpf_output = filter(hpf_impulse, 1, signal); % hpf output


%% Visualization

plotstart = (10*nsamp + 1);
plotfinish = plotstart + 15*nsamp;
t = 0:Tsamp:Tsamp*(plotfinish - plotstart);
subplot(3, 1, 1); plot(t, signal(plotstart:plotfinish), 'k');
legend("Initial signal");
subplot(3, 1, 2); plot(t, hpf_output(plotstart:plotfinish), 'k');
legend("HPF output");
subplot(3, 1, 3); plot(t, -signal(plotstart:plotfinish) + hpf_output(plotstart:plotfinish), 'k');
legend("Average value of the hpf output");











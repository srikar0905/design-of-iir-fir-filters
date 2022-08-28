% Sine signal with noise
Fs = input ('Enter the sampling frequency of the sine signal (Hz):' );
amp = input ('Enter the amplitude of the sine signal:' );
f1 = input('Enter the input frequency of the sine signal (Hz):' );
 phase = input('Enter the phase of the sine signal (rad):' );
 Ts = 1/Fs; t = 0:Ts:10; randn('state',0);
y = amp*sin((2*3.14*f1*t) + phase) + 0.5*randn(size(t));
%Program to design a Butterworth Lowpass IIR filter 
fp=input('Enter the pass band frequency fp =' );
fs=input('Enter the stop band frequency fs =' );
rp=input('Enter the pass band attenuation rp =' );
rs=input('Enter the stop band attenuation rs =' );
 f2=input ('Enter the sampling frequency f =' );
%Normalized the frequencies
wp=fp/(f2/2); ws=fs/(f2/2);
%Calculate the filter order
[n,wn]=buttord(wp,ws,rp,rs);
disp('Filter ordern n= ,);
n %Calculate the filter coefficient [b,a]=butter(n,wn);
%Filtering z=filtfilt(b,a,y);
 %Plot the signal
subplot(2,1,1), plot(y), title('Sine signal with noise');
subplot(2,1,2), plot(z), title('Filtered sine signal');
figure, plot([b,a]), title('Butterworth Lowpass IIR Filter Coefficient');
%Plotting the filter response figure, freqz(b,a,500,f2); 
title ('Magnitude and phase response of the IIR butterworth filter'); 



% Sine signal with noise
Fs = input ('Enter the sampling frequency of the sine signal (Hz):500 ');
amp = input ('Enter the amplitude of the sine signal: 5');
f1 = input('Enter the input frequency of the sine signal (Hz): 5');
 phase = input('Enter the phase of the sine signal (rad): 0');
 Ts = 1/Fs; t = 0:Ts:10; randn('state',0);
y = amp*sin((2*3.14*f1*t) + phase) + 0.5*randn(size(t));
%Program to design a Butterworth Lowpass IIR filter fp=input('Enter the pass band
frequency fp = ');
fs=input('Enter the stop band frequency fs = 7000');
rp=input('Enter the pass band attenuation rp = 8000');
rs=input('Enter the stop band attenuation rs = 0.12');
 f2=input ('Enter the sampling frequency f = 50');
%Normalized the frequencies
wp=fp/(f2/2); ws=fs/(f2/2);
%Calculate the filter order
[n,wn]=buttord(wp,ws,rp,rs);
disp('Filter ordern n= 49');
n %Calculate the filter coefficient [b,a]=butter(n,wn);
%Filtering z=filtfilt(b,a,y);
 %Plot the signal
subplot(2,1,1), plot(y), title('Sine signal with noise');
subplot(2,1,2), plot(z), title('Filtered sine signal');
figure, plot([b,a]), title('Butterworth Lowpass IIR Filter Coefficient');
%Plotting the filter response figure, freqz(b,a,500,f2); 
title ('Magnitude and phase response of the IIR butterworth filter'); 





Enter the sampling frequency of the sine signal (Hz): 100
Enter the amplitude of the sine signal: 1
Enter the input frequency of the sine signal (Hz): 1
Enter the phase of the sine signal (rad):0
Enter the pass band frequency fp =2000
Enter the stop band frequency fs =3000
Enter the pass band attenuation rp = 0.9
Enter the stop band attenuation rs = 40
Enter the sampling frequency f =10000 


Enter the sampling frequency of the sine signal (Hz):500 
Enter the amplitude of the sine signal:5
Enter the input frequency of the sine signal (Hz):5
Enter the phase of the sine signal (rad):0
Enter the pass band frequency fp =7000
Enter the stop band frequency fs =8000
Enter the pass band attenuation rp =0.12
Enter the stop band attenuation rs =50 
Enter the sampling frequency f =50000 
Filter
order n= 49



bassEnhancer = audiopluginexample.BassEnhancer;
audioTestBench(bassEnhancer)





Fs  = 44100;                            % all in Hz
Fcb =   100;
Fct =  1600;
basstan   = tan(pi*Fcb/Fs);
trebletan = tan(pi*Fct/Fs);

dbrange  = [-6:-1, +1:+6];              % -6 dB to +6 dB 
linrange = 10.^(dbrange/20);
boost = linrange(linrange>1);
cut   = linrange(linrange<=1);
Nfilters = 2 * length(dbrange);         % 2X for bass and treble
a2_bass_boost    = (basstan - 1) / (basstan + 1);
b1_bass_boost   = 1 + ((1 + a2_bass_boost) .* (boost - 1)) / 2;
b2_bass_boost   = a2_bass_boost + ...
                  ((1 + a2_bass_boost) .* (boost - 1)) / 2;

a2_bass_cut      = (basstan - cut) / (basstan + cut);
b1_bass_cut     = 1 + ((1 + a2_bass_cut) .* (cut - 1)) / 2;
b2_bass_cut     = a2_bass_cut + ((1 + a2_bass_cut) .* (cut - 1)) / 2;

a2_treble_boost  = (trebletan - 1) / (trebletan + 1); 
b1_treble_boost   = 1 + ((1 - a2_treble_boost) .* (boost - 1)) / 2;
b2_treble_boost   = a2_treble_boost + ...
                    ((a2_treble_boost - 1) .* (boost - 1)) / 2;

a2_treble_cut      = (cut .* trebletan - 1) / (cut .* trebletan + 1);
b1_treble_cut     = 1 + ((1 - a2_treble_cut) .* (cut - 1)) / 2;
b2_treble_cut     = a2_treble_cut + ...
                    ((a2_treble_cut - 1) .* (cut - 1)) / 2;
filterbank = cell(1, 2*Nfilters);     % 2X for numerator and denominator
% Duplicate a2's into vectors
a2_bass_boost   = repmat(a2_bass_boost,   1, length(boost));
a2_bass_cut     = repmat(a2_bass_cut,     1, length(cut));
a2_treble_boost = repmat(a2_treble_boost, 1, length(boost));
a2_treble_cut   = repmat(a2_treble_cut,   1, length(cut));

filterbank_num = [b1_bass_cut, b1_bass_boost, b1_treble_cut, b1_treble_boost ; ...
                  b2_bass_cut, b2_bass_boost, b2_treble_cut, b2_treble_boost ]';
% a1 is always one
filterbank_den = [ones(1, Nfilters); ...
                  a2_bass_cut, a2_bass_boost, a2_treble_cut, a2_treble_boost]';

filterbank(1:2:end) = num2cell(filterbank_num, 2);
filterbank(2:2:end) = num2cell(filterbank_den, 2);
fvtool(filterbank{:}, 'FrequencyScale', 'log', 'Fs', Fs);
 

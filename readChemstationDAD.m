%%% Martin Peeks 2015
%%% version 0.1, 28th Feb 2015
%%% martinp23@googlemail.com

%%% This script imports a 'dad1.uv' file from an agilent chemstation
%%% "Filename.D"-type data repository for HPLC.

%%% Adapted from Aston project (https://code.google.com/p/aston/)
%%% Aston code: https://code.google.com/p/aston/source/browse/aston/file_adapters/AgilentUV.py?spec=svn2589442ad04b001baaf3581d7947a8ce98767c1c&r=2589442ad04b001baaf3581d7947a8ce98767c1c
%%% 
%%% The Aston project is licensed GNU GPL v3.
%%%
%%% usage: [timepoints,wavelengths,data] =
%%% [t,w,d] = readChemstationDAD('/Users/user/Folder.D/dad1.uv');
%%% % wait a while
%%% mesh(w,t,d)

%%% have fun!

function [timepoints,wavelengths,data] = readChemstationDAD(path)

fid = fopen(path,'r','l');

fseek(fid,278,'bof');
nscans = fread(fid,1,'int',1,'b');
timepoints = zeros(nscans,1);

npos = 514;
data = [];

% we will do the "loop" once so we can preallocate the big 'data' matrix
fseek(fid,npos,'bof'); 
npos = npos + fread(fid,1,'ushort',0,'l');
timepoints(1) = fread(fid,1,'ulong',0,'l') / 60000;
nm_srt = fread(fid,1,'ushort',0,'l') / 20;
nm_end = fread(fid,1,'ushort',0,'l') / 20;
nm_stp = fread(fid,1,'ushort',0,'l') / 20;
fseek(fid,8,'cof');
data = zeros(nscans,(nm_end-nm_srt)/nm_stp);
% s is spectrum
s = zeros((nm_end-nm_srt)/nm_stp,1);
% v is value. The first value is read before the loop
v = fread(fid,1,'int16',0,'l') / 2000;
s(1) = v;
for wv = 2:((nm_end-nm_srt)/nm_stp)
    ov = fread(fid,1,'int16',0,'l');
    if (ov == -32768)
        v = fread(fid,1,'int16',0,'l') /2000;
    else
        v = v + ov/2000;
    end
    s(wv) = v;
end
data(1,:) = s;

for ii = 2:nscans
    fseek(fid,npos,'bof'); 
    npos = npos + fread(fid,1,'ushort',0,'l');
    timepoints(ii) = fread(fid,1,'ulong',0,'l') / 60000;
    nm_srt = fread(fid,1,'ushort',0,'l') / 20;
    nm_end = fread(fid,1,'ushort',0,'l') / 20;
    nm_stp = fread(fid,1,'ushort',0,'l') / 20;
    fseek(fid,8,'cof');
    % s is spectrum
    s = zeros((nm_end-nm_srt)/nm_stp,1);
    % v is value. The first value is read before the loop
    v = fread(fid,1,'int16',0,'l') / 2000;
    s(1) = v;
    for wv = 2:((nm_end-nm_srt)/nm_stp)
        ov = fread(fid,1,'short',0,'l');
        if (ov == -32768)
            v = fread(fid,1,'int32',0,'l') /2000;
        else
            v = v + ov/2000;
        end
        s(wv) = v;
    end
    data(ii,:) = s;
end
wavelengths = [nm_srt:nm_stp:nm_end-1];



fclose(fid);
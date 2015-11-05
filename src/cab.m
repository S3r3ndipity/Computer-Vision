function cab(varargin) 
% CAB close all but 
% This function closes all figures currently open EXCEPT for 
% those listed as arguments. 'cab' stands for 'close all but'. 
% 
% SYNTAX: 
% CAB figure_handle1 figure_handle2 ... (command line syntax) 
% CAB(figure_handle1, figure_handle2, ...) 
% Use 0 for gcf. CAB 0 closes all figures except current one. 
% CAB : same as close all 
% 
if nargin==0, 
close all; 
return 
end

% all_figs = findall(0, 'type', 'figure'); % Uncomment this to include ALL windows, including those with hidden handles (e.g. GUIs) 
all_figs = findobj(0, 'type', 'figure');

if iscellstr(varargin) % command line syntax 
figs2keep=cellfun(@str2double,varargin); 
else 
figs2keep=[varargin{:}]; 
end 
figs2keep(figs2keep==0)=gcf; 
delete(setdiff(all_figs, figs2keep));
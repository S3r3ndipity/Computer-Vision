function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 28-Dec-2014 18:37:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

handles.base_pos = get(handles.axes1, 'Position');

im = im2double(imread(sprintf('../data/%s', varargin{1})));
handles.im = im;
handles.im_height = size(im, 1);
handles.im_width = size(im, 2);

setupSliders(handles);

axes(handles.axes1);
w = handles.im_width;
h = handles.im_height;
LR_posx = handles.base_pos(1) + (handles.base_pos(3) - w)/2;
LR_posy = handles.base_pos(2) + (handles.base_pos(4) - h)/2;
set(handles.axes1, 'position', [LR_posx, LR_posy w h])
imshow(handles.im);

axes(handles.axes2);
imshow(handles.im);

axes(handles.axes3);
imshow(handles.im);

handles.p_mask = [];
handles.e_mask = [];

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
function setupSliders(handles)
% Slider gives desired change (in pixels) in width
set(handles.width_slider, 'Max', handles.im_width);
set(handles.width_slider, 'Min', -handles.im_width + 1);
set(handles.width_slider, 'Value', 0);
set(handles.width_slider, 'SliderStep', [0.005, 0.05]);
% slider_LRx = handles.base_pos(1) + handles.base_pos(3)/2 - 10;
% slider_LRy = handles.base_pos(2) - 20;
% width = handles.base_pos(3)/2 + 10;
% set(handles.width_slider, 'Position', [slider_LRx, slider_LRy, width, 25]);
% Slider gives desired change (in pixels) in height
set(handles.height_slider, 'Max', handles.im_height);
set(handles.height_slider, 'Min', -handles.im_height + 1);
set(handles.height_slider, 'Value', 0);
set(handles.height_slider, 'SliderStep', [0.005, 0.05]);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in PreCompute.
function PreCompute_Callback(hObject, eventdata, handles)
% hObject    handle to PreCompute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
im = handles.im;
imT = permute(im, [2, 1, 3]);
% Pre-compute and put Vinds in the workspace
[handles.Hinds, ~] = PreCompute(imT, (handles.p_mask)', (handles.e_mask)');
[handles.Vinds, handles.init_energies] = PreCompute(im, handles.p_mask, handles.e_mask);
handles.imT = imT;

%Update handles structure
guidata(hObject, handles);

% --- Executes on button press in setup.
function setup_Callback(hObject, eventdata, handles)
% hObject    handle to setup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%display all the initial images
axes(handles.axes2);
imshow(handles.init_energies, 'Colormap', hot);

axes(handles.axes1);
Ax = findall(0,'type','axes');
w = handles.im_width;
h = handles.im_height;
LR_posx = handles.base_pos(1) + (handles.base_pos(3) - w)/2;
LR_posy = handles.base_pos(2) + (handles.base_pos(4) - h)/2;
set(Ax(1), 'position', [LR_posx, LR_posy w h])
imshow(handles.im);

%setup the capability to do enlarging of photos
%retrieve global variables
im = handles.im;
imT = handles.imT;
Vinds = handles.Vinds;
Hinds = handles.Hinds;

total_increase = 1; %e.g. 1 means increase by 100%
if (strcmp(get(handles.prop_bpt,'String'),'none'))
    prop = 0.5;
else
    prop = str2double(get(handles.prop_bpt,'String')) / 100;
end
half_iter = floor(total_increase/(2*prop));
[handles.Venlarged, handles.VBinds] = enlarge(im, Vinds, floor(size(im, 2)*prop), 2*half_iter);
[handles.Henlarged, handles.HBinds] = enlarge(imT, Hinds, floor(size(im, 1)*prop), 2*half_iter);
disp('enlarged');

handles.Axes = Ax;

%Update handles structure
guidata(hObject, handles);


% --- Executes on slider movement.
function width_slider_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% get(hObject)
im = handles.im;
Venlarged = handles.Venlarged;
Henlarged = handles.Henlarged;
Vinds = handles.Vinds;
Hinds = handles.Hinds;
VBinds = handles.VBinds;
HBinds = handles.HBinds;

delta = round(get(hObject, 'Value'));
set(handles.width_val, 'String', sprintf('%d', delta));
dir = 1;

resized_im = GenResize(im, Venlarged, Henlarged, Vinds, Hinds, VBinds, HBinds, delta, dir);
[h, w, ~] = size(resized_im);

LR_posx = handles.base_pos(1) + (handles.base_pos(3) - w)/2;
LR_posy = handles.base_pos(2) + (handles.base_pos(4) - h)/2;
set(handles.axes1, 'position', [LR_posx, LR_posy w h])
axes(handles.axes1);
imshow(resized_im);

axes(handles.axes3);
imshow(im);
hold on;
[y, x] = find(Vinds <= abs(delta) & Vinds > 0);
plot(x, y, 'r.', 'MarkerSize', 2);
hold off;


% --- Executes on slider movement.
function height_slider_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
im = handles.im;
Venlarged = handles.Venlarged;
Henlarged = handles.Henlarged;
Vinds = handles.Vinds;
Hinds = handles.Hinds;
VBinds = handles.VBinds;
HBinds = handles.HBinds;

delta = round(get(hObject, 'Value'));
set(handles.height_val, 'String', sprintf('%d', delta));
dir = 2;

resized_im = GenResize(im, Venlarged, Henlarged, Vinds, Hinds, VBinds, HBinds, delta, dir);
[h, w, ~] = size(resized_im);

LR_posx = handles.base_pos(1) + (handles.base_pos(3) - w)/2;
LR_posy = handles.base_pos(2) + (handles.base_pos(4) - h)/2;
set(handles.axes1, 'position', [LR_posx, LR_posy w h])
axes(handles.axes1);
imshow(resized_im);
% figure;
% imshow(resized_im);

axes(handles.axes3);
imshow(im);
hold on;
% dir = 2
[x, y] = find(Hinds <= abs(delta) & Hinds > 0);
plot(x, y, 'r.', 'MarkerSize', 2);
hold off;



% --- Executes when user presses enter in text box.
function prop_bpt_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of prop_bpt as text
%        str2double(get(hObject,'String')) returns contents of prop_bpt as a double
setup_Callback(handles.setup, eventdata, handles);

function width_val_Callback(hObject, eventdata, handles)
val = str2double(get(hObject,'String'));
set(handles.width_slider, 'Value', val);
width_slider_Callback(handles.width_slider, eventdata, handles);


function height_val_Callback(hObject, eventdata, handles)
val = str2double(get(hObject,'String'));
set(handles.height_slider, 'Value', val);
height_slider_Callback(handles.height_slider, eventdata, handles);

% --- Executes on button press in display.
function display_Callback(hObject, eventdata, handles)
axes(handles.axes1);
w = handles.im_width;
h = handles.im_height;
LR_posx = handles.base_pos(1) + (handles.base_pos(3) - w)/2;
LR_posy = handles.base_pos(2) + (handles.base_pos(4) - h)/2;
set(handles.axes1, 'position', [LR_posx, LR_posy w h])
imshow(handles.im);

axes(handles.axes3);
imshow(handles.im);

% --- Executes on button press in protect.
function protect_Callback(hObject, eventdata, handles)
rect = getrect(handles.axes1);
xmin = round(rect(1));
ymin = round(rect(2));
width = round(rect(3));
height = round(rect(4));

e_value = -100;
p_value = 1000;
p_mask = double(e_value) * ones(handles.im_height, handles.im_width);

for i = ymin:(ymin + height)
    for j = xmin:(xmin + width)
        p_mask(i, j) = p_value;
    end
end
if (isempty(handles.p_mask))
   handles.p_mask = double(e_value) * ones(handles.im_height, handles.im_width); 
end
handles.p_mask = max(handles.p_mask, p_mask);

axes(handles.axes3);
hold on;
[row, col] = find(p_mask == p_value);
[~, ~, LRx] = find(col, 1, 'first');
[~, ~, LRxmax] = find(col, 1, 'last');
[~, ~, LRy] = find(row, 1, 'first');
[~, ~, LRymax] = find(row, 1, 'last');
rectangle('Position', [LRx, LRy, LRxmax - LRx, LRymax - LRy], 'EdgeColor', 'g', 'LineWidth', 2);
hold off;

%Update handles structure
guidata(hObject, handles);

% --- Executes on button press in erase.
function erase_Callback(hObject, eventdata, handles)
rect = getrect(handles.axes1);
disp(rect);
xmin = round(rect(1));
ymin = round(rect(2));
width = round(rect(3));
height = round(rect(4));

e_value = -100; %totals tend to all be greater than -5
p_value = 1000;
e_mask = double(p_value) .* ones(handles.im_height, handles.im_width);

for i = ymin:(ymin + height)
    for j = xmin:(xmin + width)
        e_mask(i, j) = e_value;
    end
end
if (isempty(handles.e_mask))
   handles.e_mask = double(p_value) .* ones(handles.im_height, handles.im_width); 
end
handles.e_mask = min(handles.e_mask, e_mask);

axes(handles.axes3);
hold on;
[row, col] = find(e_mask == e_value);
[~, ~, LRx] = find(col, 1, 'first');
[~, ~, LRxmax] = find(col, 1, 'last');
[~, ~, LRy] = find(row, 1, 'first');
[~, ~, LRymax] = find(row, 1, 'last');
rectangle('Position', [LRx, LRy, LRxmax - LRx, LRymax - LRy], 'EdgeColor', [1 0.8 0], 'LineWidth', 2);
hold off;

%Update handles structure
guidata(hObject, handles);

% --- Executes on button press in reset_size.
function reset_size_Callback(hObject, eventdata, handles)
set(handles.width_val, 'String', 0);
set(handles.height_val, 'String', 0);
width_val_Callback(handles.width_val, eventdata, handles);
height_val_Callback(handles.height_val, eventdata, handles);



% --- Executes on button press in reset_all.
function reset_all_Callback(hObject, eventdata, handles)
reset_size_Callback(handles.reset_size, eventdata, handles);
handles.p_mask = [];
handles.e_mask = [];
axes(handles.axes3);
imshow(handles.im);

%Update handles structure
guidata(hObject, handles);


%%%%%%%%%% A bunch of functions I haven't touched. %%%%%%%%%%%%%%%%%%%%

% --- Executes during object creation, after setting all properties.
function width_slider_CreateFcn(hObject, eventdata, handles)

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function height_slider_CreateFcn(hObject, eventdata, handles)
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function prop_bpt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prop_bpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function width_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to width_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function height_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to height_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

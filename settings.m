function varargout = settings(varargin)
% SETTINGS MATLAB code for settings.fig
%      SETTINGS, by itself, creates a new SETTINGS or raises the existing
%      singleton*.
%
%      H = SETTINGS returns the handle to a new SETTINGS or the handle to
%      the existing singleton*.
%
%      SETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SETTINGS.M with the given input arguments.
%
%      SETTINGS('Property','Value',...) creates a new SETTINGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before settings_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to settings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help settings

% Last Modified by GUIDE v2.5 15-Oct-2017 22:24:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @settings_OpeningFcn, ...
                   'gui_OutputFcn',  @settings_OutputFcn, ...
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


% --- Executes just before settings is made visible.
function settings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to settings (see VARARGIN)

% Load default settings
load 'C:\Users\apost\Desktop\Projects\Speaker Recognition\settings.mat'

handles.fs          = data.fs;          % default: 8000
handles.alpha       = data.alpha;       % default: 0.95
handles.threshold   = data.threshold;   % default: 1e-5 for clear recording

handles.gmmubmsize  = data.gmmubmsize;  % default: 32
handles.kmeans      = data.kmeans;      % default: true
handles.dnorm       = data.dnorm;       % default: true

handles.nFFT        = data.nFFT;        % default: 256
handles.overlap     = data.overlap;     % default: 128
handles.nMFCC       = data.nMFCC;       % default: 12
handles.nFilters    = data.nFilters;    % default: 20
handles.minFreq     = data.minFreq;     % default: 20
handles.maxFreq     = data.maxFreq;     % default: 4000

handles.energy      = data.energy;      % default true
handles.deltas      = data.deltas;      % default true
handles.deltasdeltas= data.deltasdeltas;% default true
handles.cmvn        = data.cmvn;        % default true

handles.options     = data.options;     % default 'edDnp'

% Set those values to GUI
set(handles.fsbox,           'String', handles.fs);
set(handles.alphabox,        'String', handles.alpha);
set(handles.thresholdbox,    'String', handles.threshold);

set(handles.gmmubmsizebox,   'String', handles.gmmubmsize);
set(handles.kmeansbox,       'Value', handles.kmeans);
set(handles.dnormbox,        'Value', handles.dnorm);

set(handles.NFFTbox,         'String', handles.nFFT);
set(handles.overlapbox,      'String', handles.overlap);
set(handles.nMFCCbox,        'String', handles.nMFCC);
set(handles.nFilterBanksbox, 'String', handles.nFilters);
set(handles.minFreqbox,      'String', handles.minFreq);
set(handles.maxFreqbox,      'String', handles.maxFreq);

set(handles.energybox,       'Value', handles.energy);
set(handles.deltasbox,       'Value', handles.deltas);
set(handles.deltasdeltasbox, 'Value', handles.deltasdeltas);
set(handles.cmvnbox,         'Value', handles.cmvn);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes settings wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = settings_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Return new parameters
varargout{1} = handles.fs;
varargout{2} = handles.alpha;
varargout{3} = handles.threshold;

varargout{4} = handles.gmmubmsize;
varargout{5} = handles.kmeans;
varargout{6} = handles.dnorm;

varargout{7} = handles.nFFT;
varargout{8} = handles.overlap;
varargout{9} = handles.nMFCC;
varargout{10} = handles.nFilters;
varargout{11} = handles.minFreq;
varargout{12} = handles.maxFreq;

varargout{13} = handles.energy;
varargout{14} = handles.deltas;
varargout{15} = handles.deltasdeltas;
varargout{16} = handles.cmvn;

varargout{17} = handles.options;

% Save new parameters
data = handles;
save 'C:\Users\apost\Desktop\Projects\Speaker Recognition\settings.mat' data

% Delete figure
delete(handles.figure1);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, use UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

if strcmp(eventdata.Key, 'escape')
    figure1_CloseRequestFcn(hObject, eventdata, handles)
elseif strcmp(eventdata.Key, 'return')
    savebutton_Callback(hObject, eventdata, handles)
end


% --- Executes on button press in savebutton.
function savebutton_Callback(hObject, eventdata, handles)
% hObject    handle to savebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fs = str2double(get(handles.fsbox, 'String'));
if fs < 8000 || fs > 44100
   set(handles.fsbox, 'String', '');
   warndlg('Sampling Frequency must be between 8000 and 44100');
else
    handles.fs = fs;
end

alpha = str2double(get(handles.alphabox, 'String'));
if alpha <= 0.9 || alpha >= 1
   set(handles.alphabox, 'String', '');
   warndlg('Pre-emphasis coefficient must be between 0.9 and 1');
else
    handles.alpha = alpha;
end

threshold = str2double(get(handles.thresholdbox, 'String'));
if threshold < 1e-6 || threshold > 1e-4
   set(handles.thresholdbox, 'String', '');
   warndlg('VAD threshold must be between 1e-6 and 1e-4');
else
    handles.threshold = threshold;
end

gmmubmsize = str2double(get(handles.gmmubmsizebox, 'String'));
if gmmubmsize < 32 || gmmubmsize > 512
    set(handles.gmmubmsizebox, 'String', '');
    warndlg('Sampling Frequency must be between 32 and 512');
elseif gmmubmsize ~= pow2(nextpow2(gmmubmsize))
    gmmubmsize = pow2(nextpow2(gmmubmsize));
    set(handles.gmmubmsizebox, 'String', gmmubmsize);
    warndlg('GMM-UBM size must be a power of 2');
else
    handles.gmmubmsize = gmmubmsize;
end

handles.kmeans = get(handles.kmeansbox, 'Value');

handles.subpopulations = get(handles.dnorm, 'Value');

nFFT = str2double(get(handles.NFFTbox, 'String'));
if nFFT < 128 || nFFT > 1024
    set(handles.NFFTbox, 'String', '');
    warndlg('Number of FFT bins must be between 128 and 1024');
elseif nFFT ~= pow2(nextpow2(nFFT))
    nFFT = pow2(nextpow2(nFFT));
    set(handles.NFFTbox, 'String', nFFT);
    warndlg('Number of FFT bins must be a power of 2');
else
    handles.nFFT = nFFT;
end

overlap = str2double(get(handles.overlapbox, 'String'));
if overlap < 64 || overlap > nFFT/2
   set(handles.overlapbox, 'String', '');
   warndlg('Overlap must be between 64 and nFFT/2');
else
    handles.overlap = overlap;
end

nMFCC = str2double(get(handles.nMFCCbox, 'String'));
if nMFCC < 12 || nMFCC > 20
   set(handles.nMFCCbox, 'String', '');
   warndlg('Number of MFCC must be between 12 and 20');
else
    handles.nMFCC = nMFCC;
end

nFilters = str2double(get(handles.nFilterBanksbox, 'String'));
if nFilters < 20 || alpha > 55
   set(handles.nFilterBanksbox, 'String', '');
   warndlg('Number of filter banks must be between 20 and 55');
else
    handles.nFilters = nFilters;
end

minFreq = str2double(get(handles.minFreqbox, 'String'));
if minFreq < 1 || minFreq > 20000
   set(handles.minFreqbox, 'String', '');
   warndlg('Minimum Frequency must be between 1 and 20000');
else
    handles.minFreq = minFreq;
end

maxFreq = str2double(get(handles.maxFreqbox, 'String'));
if maxFreq <= minFreq || maxFreq > 20000
   set(handles.maxFreqbox, 'String', '');
   warndlg('Maximum Frequency must be between minFreq and 20000');
else
    handles.maxFreq = maxFreq;
end

handles.energy = get(handles.energybox, 'Value');

handles.deltas = get(handles.deltasbox, 'Value');

handles.deltasdeltas = get(handles.deltasdeltasbox, 'Value');

handles.cmvn = get(handles.cmvnbox, 'Value');

handles.options = 'p';
if handles.energy
    handles.options = [handles.options 'e'];
end
if handles.deltas
    handles.options = [handles.options 'd'];
end
if handles.deltasdeltas
    handles.options = [handles.options 'D'];
end
if handles.cmvn
    handles.options = [handles.options 'n'];
end

guidata(hObject, handles);

uiresume(handles.figure1);


% --- Executes during object creation, after setting all properties.
function NFFTbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NFFTbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function nFilterBanksbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nFilterBanksbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function overlapbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to overlapbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function minFreqbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minFreqbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function nMFCCbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nMFCCbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function maxFreqbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxFreqbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function gmmubmsizebox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gmmubmsizebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function fsbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fsbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function alphabox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alphabox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function thresholdbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thresholdbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function gmmubmsizebox_Callback(hObject, eventdata, handles)
% hObject    handle to gmmubmsizebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gmmubmsizebox as text
%        str2double(get(hObject,'String')) returns contents of gmmubmsizebox as a double



function nFilterBanksbox_Callback(hObject, eventdata, handles)
% hObject    handle to nfilterbanksbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nfilterbanksbox as text
%        str2double(get(hObject,'String')) returns contents of nfilterbanksbox as a double



function NFFTbox_Callback(hObject, eventdata, handles)
% hObject    handle to NFFTbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NFFTbox as text
%        str2double(get(hObject,'String')) returns contents of NFFTbox as a double



function overlapbox_Callback(hObject, eventdata, handles)
% hObject    handle to overlapbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of overlapbox as text
%        str2double(get(hObject,'String')) returns contents of overlapbox as a double



function minFreqbox_Callback(hObject, eventdata, handles)
% hObject    handle to minFreqbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minFreqbox as text
%        str2double(get(hObject,'String')) returns contents of minFreqbox as a double



function nMFCCbox_Callback(hObject, eventdata, handles)
% hObject    handle to nMFCCbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nMFCCbox as text
%        str2double(get(hObject,'String')) returns contents of nMFCCbox as a double



function maxFreqbox_Callback(hObject, eventdata, handles)
% hObject    handle to maxFreqbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxFreqbox as text
%        str2double(get(hObject,'String')) returns contents of maxFreqbox as a double



function fsbox_Callback(hObject, eventdata, handles)
% hObject    handle to fsbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fsbox as text
%        str2double(get(hObject,'String')) returns contents of fsbox as a double



function alphabox_Callback(hObject, eventdata, handles)
% hObject    handle to alphabox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alphabox as text
%        str2double(get(hObject,'String')) returns contents of alphabox as a double



function thresholdbox_Callback(hObject, eventdata, handles)
% hObject    handle to thresholdbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thresholdbox as text
%        str2double(get(hObject,'String')) returns contents of thresholdbox as a double


% --- Executes on button press in energybox.
function energybox_Callback(hObject, eventdata, handles)
% hObject    handle to energybox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of energybox


% --- Executes on button press in deltasbox.
function deltasbox_Callback(hObject, eventdata, handles)
% hObject    handle to deltasbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of deltasbox


% --- Executes on button press in deltasdeltasbox.
function deltasdeltasbox_Callback(hObject, eventdata, handles)
% hObject    handle to deltasdeltasbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of deltasdeltasbox


% --- Executes on button press in kmeansbox.
function kmeansbox_Callback(hObject, eventdata, handles)
% hObject    handle to kmeansbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of kmeansbox


% --- Executes on button press in subpopulationsbox.
function subpopulationsbox_Callback(hObject, eventdata, handles)
% hObject    handle to subpopulationsbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of subpopulationsbox


% --- Executes on button press in cmvnbox.
function cmvnbox_Callback(hObject, eventdata, handles)
% hObject    handle to cmvnbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cmvnbox



function username_Callback(hObject, eventdata, handles)
% hObject    handle to username (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of username as text
%        str2double(get(hObject,'String')) returns contents of username as a double


% --- Executes during object creation, after setting all properties.
function username_CreateFcn(hObject, eventdata, handles)
% hObject    handle to username (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in dnormbox.
function dnormbox_Callback(hObject, eventdata, handles)
% hObject    handle to dnormbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dnormbox

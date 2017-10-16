function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
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
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 16-Oct-2017 15:31:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

addpath(genpath('pre-processing'));
addpath(genpath('feature-extraction'));
addpath(genpath('feature-matching'));

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
handles.athreshold  = data.athreshold;  % default
handles.username    = '';

% Add some extra handles
handles.recorder = audiorecorder(handles.fs, 16, 1);
handles.audio 	 = [];
handles.mfcc     = [];

% Clear axes
cla(handles.origsignalaxis, 'reset');
cla(handles.procsignalaxis, 'reset');
cla(handles.mfccaxis,       'reset');

% Set window title
set(handles.figure1, 'Name', 'GUI');
set(handles.usertext, 'String', '');

% Move window in the center of the screen
movegui(gcf, 'center');

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles, 'recorder')
    if handles.recorder.isrecording
        stop(handles.recorder);
    end
end
delete(hObject);


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

if strcmp(eventdata.Key, 'escape')
    delete(hObject);
end


% --- Executes on button press in recordbutton.
function recordbutton_Callback(hObject, eventdata, handles)
% hObject    handle to recordbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mode = get(handles.modebutton, 'String');
if strcmp(mode, 'Recognition')
    t = timer('Name', 'timer', 'ExecutionMode', 'fixedRate', 'Period', ...
        0.1, 'StartDelay', 0.3, 'TimerFcn', {@finduser, hObject, handles});
else
    t = timer('Name', 'timer', 'ExecutionMode', 'fixedRate', 'Period', ...
        0.1, 'StartDelay', 0.3, 'TimerFcn', {@verifyuser, hObject, handles});
end

value = get(hObject, 'Value');

if value == 1
    record(handles.recorder);
    start(t);    
elseif handles.recorder.isrecording == true
    stop(handles.recorder);
    stop(timerfind('Name', 'timer'));
    delete(timerfind);  % clear timers
end


function [] = finduser(~, ~, hObject, handles)
%[] = FINDUSER(~, ~, hObject, handles) finds the most likely speaker of
%the audio recordered

if ~isfield(handles, 'recorder') || ~handles.recorder.isrecording
    error('No speech sample available! Please try again')
end

audio = getaudiodata(handles.recorder);
handles.audio = audio;

axes(handles.origsignalaxis);
plot(1/handles.fs:1/handles.fs:length(audio)/handles.fs, audio);

audio =  emphasize(vad(audio, handles.fs, handles.threshold)); % process data

axes(handles.procsignalaxis);
plot(1/handles.fs:1/handles.fs:length(audio)/handles.fs, audio, 'r');

axes(handles.mfccaxis);
handles.mfcc = mfcc(audio, handles.fs, handles.nFFT, handles.overlap, ...
    handles.nMFCC, handles.nFilters, handles.minFreq, handles.maxFreq,...
    handles.options);

users = arrayfun(@(x) x.name(1:end-4), dir('users\'), 'UniformOutput', false);
users = users(3:end-1);

nUsers = length(users);

% Log likelihood of each user
results = zeros(nUsers, 1);
for i = 1:nUsers
    load(strcat('users\', users{i}, '.mat'));
    results(i) = mean( llk(handles.mfcc, distribution) );
end

% Checking for the right user
[~, speaker] = max(results);

% Display User
set(handles.usertext, 'String', users{speaker});
set(handles.usertext, 'ForegroundColor', 'Black');

guidata(hObject,handles);


function [] = verifyuser(~, ~, hObject, handles)
%[] = FINDUSER(~, ~, hObject, handles) finds the most likely speaker of
%the audio recordered

if ~isfield(handles, 'recorder') || ~handles.recorder.isrecording
    error('No speech sample available! Please try again')
end

audio = getaudiodata(handles.recorder);
handles.audio = audio;

axes(handles.origsignalaxis);
plot(1/handles.fs:1/handles.fs:length(audio)/handles.fs, audio);

audio =  emphasize(vad(audio, handles.fs, handles.threshold)); % process data

axes(handles.procsignalaxis);
plot(1/handles.fs:1/handles.fs:length(audio)/handles.fs, audio, 'r');

axes(handles.mfccaxis);
handles.mfcc = mfcc(audio, handles.fs, handles.nFFT, handles.overlap, ...
    handles.nMFCC, handles.nFilters, handles.minFreq, handles.maxFreq,...
    handles.options);

load(char(strcat('users\', handles.username, '.mat')));
load('users\ubm.mat');
result = mean( llk(handles.mfcc, distribution) - llk(handles.mfcc, ubmDistribution)) / dnorm;

if result > handles.athreshold	% accepatance threshold
    set(handles.usertext, 'String', 'Pass');
    set(handles.usertext, 'ForegroundColor', 'Green');
else
    set(handles.usertext, 'String', 'Fail');
    set(handles.usertext, 'ForegroundColor', 'Red');
end

guidata(hObject,handles);


% --- Executes on button press in playbutton.
function playbutton_Callback(hObject, eventdata, handles)
% hObject    handle to playbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

value = get(hObject, 'Value');

if value
    handles.player = audioplayer(handles.audio, handles.fs);
    play(handles.player);
    guidata(hObject, handles);
    
    set(handles.playbutton, 'string', 'Stop');
else
    stop(handles.player);
    clear handles.player
    guidata(hObject, handles);
    
    set(handles.playbutton, 'string', 'Play');
end


% --- Executes on button press in modebutton.
function modebutton_Callback(hObject, eventdata, handles)
% hObject    handle to modebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of modebutton

if ~isempty(timerfind('Name', 'timer'))
    set(hObject, 'Value', ~get(hObject, 'Value'));
    return;
end

if get(hObject, 'Value') == 1
    if strcmp(handles.username, '');
        set(hObject, 'Value', 0);
        errordlg('You are not logged in. Please log in first');
    else
        set(hObject, 'String', 'Verification');
    end
else
    set(hObject, 'String', 'Recognition');
end


% --------------------------------------------------------------------
function audiomenu_Callback(hObject, eventdata, handles)
% hObject    handle to openmenuitem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function openmenuitem_Callback(hObject, eventdata, handles)
% hObject    handle to openmenuitem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = ...
    uigetfile({'*.wav'; '*.mp3'; '*.mp4'; '*.m4a'; '*.avi'}, 'Open audio file');

if ischar(filename) && ischar(pathname)
    axes(handles.origsignalaxis);
    [audio, fs] = audioread(fullfile(pathname, filename));
    audio = resample(audio, fs, handles.fs);
    plot(1/handles.fs:1/handles.fs:length(audio)/handles.fs, audio);

    axes(handles.procsignalaxis);
    audio = emphasize(vad(audio, handles.fs, handles.threshold));
    plot(1/handles.fs:1/handles.fs:length(audio)/handles.fs, audio, 'r');

    axes(handles.mfccaxis);
    handles.audio = audio;
    handles.mfcc = mfcc(audio, handles.fs, handles.nFFT, handles.overlap, ...
            handles.nMFCC, handles.nFilters, handles.minFreq, handles.maxFreq,...
            handles.options);
    
    if (strcmp(char(get(handles.modebutton, 'String')), 'Recognition'))
        users = arrayfun(@(x) x.name(1:end-4), dir('users\'), 'UniformOutput', false);
        users = users(3:end-1);

        nUsers = length(users);

        % Log likelihood of each user
        results = zeros(nUsers, 1);
        for i = 1:nUsers
            load(strcat('users\', users{i}, '.mat'));
            results(i) = mean( llk(handles.mfcc, distribution) );
        end

        % Checking for the right user
        [~, speaker] = max(results);

        % Display User
        set(handles.usertext, 'String', users{speaker});
        set(handles.usertext, 'ForegroundColor', 'Black');
    else
        load(char(strcat('users\', handles.username, '.mat')));
        load('users\ubm.mat');
        result = mean( llk(handles.mfcc, distribution) - llk(handles.mfcc, ubmDistribution)) / dnorm;

        if result > handles.athreshold	% accepatance threshold
            set(handles.usertext, 'String', 'Pass');
            set(handles.usertext, 'ForegroundColor', 'Green');
        else
            set(handles.usertext, 'String', 'Fail');
            set(handles.usertext, 'ForegroundColor', 'Red');
        end
    end
    
    guidata(hObject, handles);
end

% --------------------------------------------------------------------
function enrollmenuitem_Callback(hObject, eventdata, handles)
% hObject    handle to enrollmenuitem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(handles.mfcc)
    errordlg('MFCC have not been computed. Please open a audio file or record a speech.');
elseif ~exist('C:\Users\apost\Desktop\Projects\Speaker Recognition\users\ubm.mat', 'file')
    errordlg('UBM not found! Please create a UBM first.');
else
    load 'C:\Users\apost\Desktop\Projects\Speaker Recognition\users\ubm.mat'
    prompt = {'Enter user folder:', 'Enter username:'};
    dlg_title = 'Enroll';
    num_lines = 1;
    default_ans = {'C:\Users\apost\Desktop\Projects\Speaker Recognition\users\',''};
    answer = inputdlg(prompt, dlg_title, num_lines, default_ans, 'on');
   
    distribution = map(handles.mfcc, ubmDistribution);
    save(strcat(answer{1}, answer{2}, '.mat'), 'distribution');
    
    msgbox('User successfully enrolled');
end


% --------------------------------------------------------------------
function settingsmenu_Callback(hObject, eventdata, handles)
% hObject    handle to settingsmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function parammenuitem_Callback(hObject, eventdata, handles)
% hObject    handle to parammenuitem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[handles.fs, handles.alpha, handles.threshold, handles.gmmubmsize, ...
    handles.kmeans, handles.subpopulation, handles.nFFT, handles.ovelap, ...
    handles.nMFCC, handles.nFilters, handles.minFreq, handles.maxFreq, ...
    handles.energy, handles.deltas, handles.detlasdeltas, handles.cmvn,...
    handles.options] = settings;

guidata(hObject, handles);


% --------------------------------------------------------------------
function trainathresholduimenuitem_Callback(hObject, eventdata, handles)
% hObject    handle to trainathresholduimenuitem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

x = inputdlg('Threshold:', 'Train Acceptance Threshold');
if isnumeric(x)
    handles.athreshold = x;
    guidata(hObject, handles);
end


% --------------------------------------------------------------------
function trainubmmenuitem_Callback(hObject, eventdata, handles)
% hObject    handle to trainubmmenuitem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile({'*.wav'; '*.mp3'; '*.mp4';...
    '*.m4a'; '*.avi'}, 'Open audio files', 'MultiSelect', 'on');

if ischar(pathname)
    tic;

    % Turning off useless warnings
    warning('off', 'stats:kmeans:FailedToConverge');
    warning('off', 'stats:gmdistribution:IllCondCov');
    warning('off', 'stats:gmdistribution:FailedToConverge');
    warning('off', 'stats:gmdistribution:FailedToConvergeReps');

    % Feature Extraction
    ubmFeatures = [];
    for i = 1:length(filename)
        [audio, fs] = audioread(char(strcat(pathname, filename{i})));
        audio = resample(audio, fs, handles.fs);
        audio = emphasize(vad(audio, handles.fs, handles.threshold));

        handles.mfcc = mfcc(audio, handles.fs, handles.nFFT, handles.overlap, ...
            handles.nMFCC, handles.nFilters, handles.minFreq, handles.maxFreq, ...
            handles.options);
        ubmFeatures = [features; ubmFeatures];    
    end
    
    options = '';
    if gmm.kmeans, options = [options 'k']; end
    if gmm.subpopulations, options = [options 's']; end

    ubmDistribution = gmm(ubmFeatures, handles.gmmubmsize, options);

    save 'C:\Users\apost\Desktop\Projects\Speaker Recognition\users\ubm.mat' ubmDistribution;

    time = toc;
    msgbox(sprintf('Your UBM model is ready! Time elapsed %f seconds.', time), 'Complete');
end


% --------------------------------------------------------------------
function usermenuitem_Callback(hObject, eventdata, handles)
% hObject    handle to usermenuitem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get user's name
handles.username = inputdlg('Username:', 'User Log in');

% Check if user is enrolled
users = arrayfun(@(x) x.name(1:end-4), dir('users\'), 'UniformOutput', false);
users = users(3:end-1);
if ~ismember(handles.username, users)
    errordlg('User not found! Please try again');
    uiwait();
    usermenuitem_Callback(hObject, eventdata, handles);
else
    set(handles.figure1, 'Name', char(strcat({'GUI - '}, handles.username)));
    guidata(hObject, handles);  % save data
end

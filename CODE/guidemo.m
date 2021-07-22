function varargout = guidemo(varargin)
% GUIDEMO MATLAB code for guidemo.fig
%      GUIDEMO, by itself, creates a new GUIDEMO or raises the existing
%      singleton*.
%
%      H = GUIDEMO returns the handle to a new GUIDEMO or the handle to
%      the existing singleton*.
%
%      GUIDEMO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIDEMO.M with the given input arguments.
%
%      GUIDEMO('Property','Value',...) creates a new GUIDEMO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guidemo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guidemo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guidemo

% Last Modified by GUIDE v2.5 08-Mar-2021 11:51:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guidemo_OpeningFcn, ...
                   'gui_OutputFcn',  @guidemo_OutputFcn, ...
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


% --- Executes just before guidemo is made visible.
function guidemo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guidemo (see VARARGIN)

% Choose default command line output for guidemo
handles.output = hObject;
    SPEED=0;
 SPEED=num2str(SPEED);
    set(handles.edit1,'String',SPEED);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guidemo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guidemo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in browse.
function browse_Callback(hObject, eventdata, handles)
% hObject    handle to browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


    [filename, pathname] = uigetfile('*.*', 'Pick a MATLAB code file');
    
    if isequal(filename,0) || isequal(pathname,0)
    
        disp('User pressed cancel')
    
    else
        
    filename=(strcat(pathname,filename));
    vidObj = VideoReader(filename);
    vidFrame = read(vidObj, 1);
    axes(handles.axes1);
    imshow(vidFrame);
    handles.filename=filename;
    SPEED=0;
 SPEED=num2str(SPEED);
    set(handles.edit1,'String',SPEED);
    end
 

% Update handles structure
guidata(hObject, handles);
    

% --- Executes on button press in palyvideo.
function palyvideo_Callback(hObject, eventdata, handles)
% hObject    handle to palyvideo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        filename= handles.filename;

        vidObj = VideoReader(filename);

        % Specify that reading should start at 0.5 seconds from the
        % beginning.
        vidObj.CurrentTime = 0.5;
        i=1;
        FileExtension='.jpg';
   
        % Read video frames until available
        while hasFrame(vidObj)
            vidFrame = readFrame(vidObj);
            axes(handles.axes1);
            image(vidFrame);
            Filename=strcat(strcat(num2str(i)),FileExtension);
            imwrite(vidFrame,Filename);
            i=i+1;
            %currAxes.Visible = 'off';
            pause(1/vidObj.FrameRate);
        end
 
helpdlg('Process Completed');
      
        
% --- Executes on button press in videotracking.
function videotracking_Callback(hObject, eventdata, handles)
% hObject    handle to videotracking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

filename= handles.filename;
frame            = [];  % A video frame
detectedLocation = [];  % The detected location
trackedLocation  = [];  % The tracked location
label            = '';  % Label for the ball
utilities        = [];  % Utilities used to process the video
        
% Input video file which needs to be stabilized.
%filename = 'shaky_car.avi';

utilities=showDetections(filename,handles,label);
showTrajectory(utilities,handles);
% nested functions.  
frame            = [];  % A video frame
detectedLocation = [];  % The detected location
trackedLocation  = [];  % The tracked location
label            = '';  % Label for the ball
utilities        = [];  % Utilities used to process the video

param = getDefaultParameters();  % get Kalman configuration that works well

 trackSingleObject(param,utilities,filename,handles)


%hVideoSrc = VideoReader(filename);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

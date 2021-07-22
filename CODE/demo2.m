function varargout = demo2(varargin)
% DEMO2 MATLAB code for demo2.fig
%      DEMO2, by itself, creates a new DEMO2 or raises the existing
%      singleton*.
%
%      H = DEMO2 returns the handle to a new DEMO2 or the handle to
%      the existing singleton*.
%
%      DEMO2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEMO2.M with the given input arguments.
%
%      DEMO2('Property','Value',...) creates a new DEMO2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before demo2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to demo2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help demo2

% Last Modified by GUIDE v2.5 05-Apr-2021 13:42:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @demo2_OpeningFcn, ...
                   'gui_OutputFcn',  @demo2_OutputFcn, ...
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


% --- Executes just before demo2 is made visible.
function demo2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to demo2 (see VARARGIN)

% Choose default command line output for demo2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes demo2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = demo2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Browse.
function Browse_Callback(hObject, eventdata, handles)
% hObject    handle to Browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




    filename='sbest2.mp4';
    vidObj = VideoReader(filename);
    vidFrame = read(vidObj, 1);


url='http://192.168.1.8:8080/shot.jpg'   

frame            = [];  % A video frame
detectedLocation = [];  % The detected location
trackedLocation  = [];  % The tracked location
label            = '';  % Label for the ball
utilities        = [];  % Utilities used to process the video
        
% Input video file which needs to be stabilized.
%filename = 'shaky_car.avi';

param = getDefaultParameters();
utilities = createUtilities(param,filename);
trackedLocation = [];

idx = 0;
count=0;
setstr=0;
precount=1;
% handles=0;
NumFrames =utilities.videoReader.NumFrames ;
frmcnt=1;
SPEED='0'
%   while frmcnt < NumFrames
while(1);
    frame2=imread('mask33.png');
frame2=imcomplement(frame2);

    %     frame = readFrame(utilities.videoReader);
    frame=imread(url);
    red=frame(:,:,1)';
    green=frame(:,:,2)';;
    blue=frame(:,:,3)';
    
    framen(:,:,1)=red;
    framen(:,:,2)=green;
    framen(:,:,3)=blue;
    
    frame=framen;
    
    
    
    
%     frame=frame4;
    % [detectedLocation, isObjectDetected,utilities] = detectObject(frame,utilities)
    [detectedLocation,count,setstr,finalcount, isObjectDetected,utilities,precount] = detectObject(frame,utilities,count,setstr,precount,frame2);% detectedLocation = detectObject(frame,utilities);
    if finalcount > 0
        disp(finalcount);
        SPEED=10/finalcount*86.6;

        disp(SPEED);

        SPEED=num2str(SPEED);
        disp(SPEED);
      set(handles.edit1,'String',SPEED);
        
      frame4=imadd(frame,frame2);
        
        axes(handles.axes1);
    imshow(frame4);title(SPEED);

    pause(0.5);
    end
%     frame2=double(frame2);
    I=frame2;
     I = cat(3,I,I,I);
     frame2=I;
%     frame=double(frame);
    frame4=imadd(frame,frame2);
    %title(SPEED);
        axes(handles.axes1);

    imshow(frame4);

    pause(0.5);
    
   % Show the detection result for the current video frame.
   utilities=annotateTrackedObject(utilities,frame,trackedLocation,detectedLocation,label,handles)    % To highlight the effects of the measurement noise, show the detection
    % results for the 40th frame in a separate figure.
    idx = idx + 1;
%     if idx == 40
        foreground=utilities.foregroundMask;
%         [L num]=bwlabel(foreground);
%         propied=regionprops(L,'BoundingBox');
              RGBFrame = max(repmat(utilities.foregroundMask, [1,1,3]), im2single(frame));
% YPred='0'
%         for n=1:size(propied,1)
%                         RGBFrame = 	insertObjectAnnotation(RGBFrame, 'rectangle', propied(n).BoundingBox, YPred,'LineWidth',3,'Color',{'red'},'TextColor','black','FontSize',14);
% 
%         end
      imshow(RGBFrame);title(SPEED);

             axes(handles.axes1);

      pause(0.5);
%     end
        frmcnt=frmcnt+1;

  end % while
  
  % Close the window which was used to show individual video frame.



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

clear;
clc;
close all;
% [filename, pathname] = uigetfile('*.*', 'Pick a MATLAB code file');
% 
% if isequal(filename,0) || isequal(pathname,0)
% 
%     disp('User pressed cancel')
% 
% else

    filename='sbest2.mp4';
    vidObj = VideoReader(filename);
    vidFrame = read(vidObj, 1);
    imshow(vidFrame);


% end

url='http://192.168.1.11:8080/shot.jpg'   

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
handles=0;
NumFrames =utilities.videoReader.NumFrames ;
frmcnt=1;
    frame2=imread('mask33.bmp');
frame2=imcomplement(frame2);
SPEED='0'
%   while frmcnt < NumFrames
while(1);

    %     frame = readFrame(utilities.videoReader);
    frame=imread(url);
%     frame=frame4;
    % [detectedLocation, isObjectDetected,utilities] = detectObject(frame,utilities)
    [detectedLocation,count,setstr,finalcount, isObjectDetected,utilities,precount] = detectObject(frame,utilities,count,setstr,precount,frame2);% detectedLocation = detectObject(frame,utilities);
    if finalcount > 0
        disp(finalcount);
        SPEED=10/finalcount*86.6;

        disp(SPEED);

        SPEED=num2str(SPEED);
        disp(SPEED);
    %     set(handles.edit1,'String',SPEED);
        frame4=imadd(frame,frame2);
    imshow(frame4);title(SPEED);

    pause(0.5);
    end
    frame4=imadd(frame,frame2);title(SPEED);

    imshow(frame4);

    pause(0.5);
    
   % Show the detection result for the current video frame.
   utilities=annotateTrackedObject(utilities,frame,trackedLocation,detectedLocation,label,handles)    % To highlight the effects of the measurement noise, show the detection
    % results for the 40th frame in a separate figure.
    idx = idx + 1;
    if idx == 40
      combinedImage = max(repmat(utilities.foregroundMask, [1,1,3]), im2single(frame));
      imshow(combinedImage);title(SPEED);
      pause(0.5);
    end
        frmcnt=frmcnt+1;

  end % while
  
  % Close the window which was used to show individual video frame.



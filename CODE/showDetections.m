function utilities =showDetections(filename,handles,label)
  param = getDefaultParameters();
  utilities = createUtilities(param,filename);
  trackedLocation = [];

  idx = 0;
  count=0;
   setstr=0;
precount=1;
  while hasFrame(utilities.videoReader)
    frame = readFrame(utilities.videoReader);
% [detectedLocation, isObjectDetected,utilities] = detectObject(frame,utilities)
[detectedLocation,count,setstr,finalcount, isObjectDetected,utilities,precount] = detectObject(frame,utilities,count,setstr,precount)% detectedLocation = detectObject(frame,utilities);
if finalcount > 0
    disp(finalcount);
    SPEED=10/finalcount*86.6
    
    disp(SPEED);
    
    SPEED=num2str(SPEED);
    set(handles.edit1,'String',SPEED);
    
end
% Show the detection result for the current video frame.
utilities=annotateTrackedObject(utilities,frame,trackedLocation,detectedLocation,label,handles)    % To highlight the effects of the measurement noise, show the detection
    % results for the 40th frame in a separate figure.
    idx = idx + 1;
    if idx == 40
      combinedImage = max(repmat(utilities.foregroundMask, [1,1,3]), im2single(frame));
%       axes(handles.axes2); 
      imshow(combinedImage);
    end
  end % while
  
  % Close the window which was used to show individual video frame.
  uiscopes.close('All'); 
end


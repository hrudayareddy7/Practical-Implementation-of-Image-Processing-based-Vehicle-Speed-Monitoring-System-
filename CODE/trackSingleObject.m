function trackSingleObject(param,utilities,filename,handles)
  % Create utilities used for reading video, detecting moving objects,
  % and displaying the results.
  utilities = createUtilities(param,filename);

  isTrackInitialized = false;
  while hasFrame(utilities.videoReader)
    frame = readFrame(utilities.videoReader);

    % 
%[detectedLocation, isObjectDetected,utilities] = detectObject(frame,utilities)
%[detectedLocation,count,setstr,finalcount, isObjectDetected,utilities,precount] = detectObject(frame,utilities,count,setstr,precount)% detectedLocation = detectObject(frame,utilities);
[detectedLocation, isObjectDetected,utilities] = detectObjectnew(frame,utilities)
    if ~isTrackInitialized
      if isObjectDetected
        % Initialize a track by creating a Kalman filter when the ball is
        % detected for the first time.
        initialLocation = computeInitialLocation(param, detectedLocation);
        kalmanFilter = configureKalmanFilter(param.motionModel, ...
          initialLocation, param.initialEstimateError, ...
          param.motionNoise, param.measurementNoise);

        isTrackInitialized = true;
        trackedLocation = correct(kalmanFilter, detectedLocation);
        label = 'Initial';
      else
        trackedLocation = [];
        label = '';
      end

    else
      % Use the Kalman filter to track the ball.
      if isObjectDetected % The ball was detected.
        % Reduce the measurement noise by calling predict followed by
        % correct.
        predict(kalmanFilter);
        trackedLocation = correct(kalmanFilter, detectedLocation);
        label = 'Corrected';
      else % The ball was missing.
        % Predict the ball's location.
        trackedLocation = predict(kalmanFilter);
        label = 'Predicted';
      end
    end

    utilities=annotateTrackedObject(utilities,frame,trackedLocation,detectedLocation,label,handles)
  end % while
  
showTrajectory(utilities,handles)
end


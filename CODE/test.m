
function kalmanFilterForTracking

  filename='singleball.mp4'

utilities=showDetections(filename);

showTrajectory(utilities)
% nested functions.  
frame            = [];  % A video frame
detectedLocation = [];  % The detected location
trackedLocation  = [];  % The tracked location
label            = '';  % Label for the ball
utilities        = [];  % Utilities used to process the video

%%
% The procedure for tracking a single object is shown below.
function trackSingleObject(param)
  % Create utilities used for reading video, detecting moving objects,
  % and displaying the results.
  utilities = createUtilities(param,filename);

  isTrackInitialized = false;
  while hasFrame(utilities.videoReader)
    frame = readFrame(utilities.videoReader);

    % Detect the ball.
[detectedLocation, isObjectDetected,utilities] = detectObject(frame,utilities)

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

    utilities=annotateTrackedObject(utilities,frame,trackedLocation,detectedLocation,label)
  end % while
  
showTrajectory(utilities)
end


%%
% You can see the ball's trajectory by overlaying all video frames.
param = getDefaultParameters();  % get Kalman configuration that works well
                                 % for this example
                                 
trackSingleObject(param);  % visualize the results

%% Explore Kalman Filter Configuration Options
% Configuring the Kalman filter can be very challenging. Besides basic
% understanding of the Kalman filter, it often requires experimentation in
% order to come up with a set of suitable configuration parameters. The
% |trackSingleObject| function, defined above, helps you to explore the
% various configuration options offered by the |configureKalmanFilter|
% function.
%
% The |configureKalmanFilter| function returns a Kalman filter object. You
% must provide five input arguments.
%
%   kalmanFilter = configureKalmanFilter(MotionModel, InitialLocation,
%            InitialEstimateError, MotionNoise, MeasurementNoise)

%%
% The *MotionModel* setting must correspond to the physical characteristics
% of the object's motion. You can set it to either a constant velocity or
% constant acceleration model. The following example illustrates the
% consequences of making a sub-optimal choice.
param = getDefaultParameters();         % get parameters that work well
param.motionModel = 'ConstantVelocity'; % switch from ConstantAcceleration
                                        % to ConstantVelocity
% After switching motion models, drop noise specification entries
% corresponding to acceleration.
param.initialEstimateError = param.initialEstimateError(1:2);
param.motionNoise          = param.motionNoise(1:2);

trackSingleObject(param); % visualize the results

%%
% Notice that the ball emerged in a spot that is quite different from the
% predicted location. From the time when the ball was released, it was
% subject to constant deceleration due to resistance from the carpet.
% Therefore, constant acceleration model was a better choice. If you kept
% the constant velocity model, the tracking results would be sub-optimal no
% matter what you selected for the other values.

%%
% Typically, you would set the *InitialLocation* input to the location
% where the object was first detected. You would also set the
% *InitialEstimateError* vector to large values since the initial state may
% be very noisy given that it is derived from a single detection. The
% following figure demonstrates the effect of misconfiguring these
% parameters.

param = getDefaultParameters();  % get parameters that work well
param.initialLocation = [0, 0];  % location that's not based on an actual detection 
param.initialEstimateError = 100*ones(1,3); % use relatively small values

trackSingleObject(param); % visualize the results

%%
% With the misconfigured parameters, it took a few steps before the
% locations returned by the Kalman filter align with the actual trajectory
% of the object.

%%
% The values for *MeasurementNoise* should be selected based on the
% detector's accuracy. Set the measurement noise to larger values for a
% less accurate detector. The following example illustrates the noisy
% detections of a misconfigured segmentation threshold. Increasing the
% measurement noise causes the Kalman filter to rely more on its internal
% state rather than the incoming measurements, and thus compensates for the
% detection noise.

param = getDefaultParameters();
param.segmentationThreshold = 0.0005; % smaller value resulting in noisy detections
param.measurementNoise      = 12500;  % increase the value to compensate 
                                      % for the increase in measurement noise

trackSingleObject(param); % visualize the results





%%

%% Utility Functions Used in the Example

%%
% Get default parameters for creating Kalman filter and for segmenting the
% ball.
% function param = getDefaultParameters
%   param.motionModel           = 'ConstantAcceleration';
%   param.initialLocation       = 'Same as first detection';
%   param.initialEstimateError  = 1E5 * ones(1, 3);
%   param.motionNoise           = [25, 10, 1];
%   param.measurementNoise      = 25;
%   param.segmentationThreshold = 0.05;
% end

%%
% Detect and annotate the ball in the video.
% function showDetections(filename)
%   param = getDefaultParameters();
%   utilities = createUtilities(param,filename);
%   trackedLocation = [];
% 
%   idx = 0;
%   while hasFrame(utilities.videoReader)
%     frame = readFrame(utilities.videoReader);
% [detectedLocation, isObjectDetected,utilities] = detectObject(frame,utilities)
% 
%    % detectedLocation = detectObject(frame,utilities);
% 
% % Show the detection result for the current video frame.
% utilities=annotateTrackedObject(utilities,frame,trackedLocation,detectedLocation)    % To highlight the effects of the measurement noise, show the detection
%     % results for the 40th frame in a separate figure.
%     idx = idx + 1;
%     if idx == 40
%       combinedImage = max(repmat(utilities.foregroundMask, [1,1,3]), im2single(frame));
%       figure, imshow(combinedImage);
%     end
%   end % while
%   
%   % Close the window which was used to show individual video frame.
%   uiscopes.close('All'); 
% end
% 
%%
% Detect the ball in the current video frame.

%%
% Show the current detection and tracking results.


end

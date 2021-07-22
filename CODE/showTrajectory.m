function showTrajectory(utilities,handles)
  % Close the window which was used to show individual video frame.
  uiscopes.close('All'); 
  
  % Create a figure to show the processing results for all video frames.
  axes(handles.axes3); imshow(utilities.accumulatedImage/2+0.5); hold on;
  plot(utilities.accumulatedDetections(:,1), ...
    utilities.accumulatedDetections(:,2), 'k+');
  
  if ~isempty(utilities.accumulatedTrackings)
    plot(utilities.accumulatedTrackings(:,1), ...
      utilities.accumulatedTrackings(:,2), 'r-o');
    legend('Detection', 'Tracking');
  end
end
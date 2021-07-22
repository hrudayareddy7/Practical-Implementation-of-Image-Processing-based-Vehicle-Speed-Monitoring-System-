function utilities=annotateTrackedObject(utilities,frame,trackedLocation,detectedLocation,label,handles)

utilities=accumulateResults(utilities,frame,detectedLocation,trackedLocation)% Combine the foreground mask with the current video frame in order to
  % show the detection result.
  combinedImage = max(repmat(utilities.foregroundMask, [1,1,3]), im2single(frame));

  if ~isempty(trackedLocation)
    shape = 'circle';
    region = trackedLocation;
    region(:, 3) = 5;
    combinedImage = insertObjectAnnotation(combinedImage, shape, ...
      region, {label}, 'Color', 'red');
  end
%   axes(handles.axes2);
  imshow(combinedImage);
  %step(utilities.videoPlayer, combinedImage);
end
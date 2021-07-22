function utilities=accumulateResults(utilities,frame,detectedLocation,trackedLocation)
  utilities.accumulatedImage      = max(utilities.accumulatedImage, frame);
  utilities.accumulatedDetections ...
    = [utilities.accumulatedDetections; detectedLocation];
  utilities.accumulatedTrackings  ...
    = [utilities.accumulatedTrackings; trackedLocation];
end

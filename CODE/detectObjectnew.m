function [detection, isObjectDetected,utilities] = detectObjectnew(frame,utilities)
  grayImage = rgb2gray(im2single(frame));
 utilities.foregroundMask = step(utilities.foregroundDetector, grayImage);
  detection = step(utilities.blobAnalyzer, utilities.foregroundMask);
  if isempty(detection)
    isObjectDetected = false;
  else
    % To simplify the tracking process, only use the first detected object.
    detection = detection(1, :);
    isObjectDetected = true;
  end
end
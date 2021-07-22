function [detection,count,setstr,finalcount, isObjectDetected,utilities,precount] = detectObject(frame,utilities,count,setstr,precount,frame2)
  grayImage = rgb2gray(im2single(frame));
 utilities.foregroundMask = step(utilities.foregroundDetector, grayImage);
 
 foregroundmask=utilities.foregroundMask;
 
  detection = step(utilities.blobAnalyzer, utilities.foregroundMask);
  
  a=imread('mask11.bmp');
  a=im2bw(a);
  a=imcomplement(a);
  b=imread('mask22.bmp');
  b=im2bw(b);
  b=imcomplement(b);
  
  firstframe=foregroundmask;
  
  c=bitand(a,firstframe);
  d=sum(sum(c));
  e=bitand(b,firstframe);
  f=sum(sum(e));
  if d > 0
      setstr=1
  end
  
  if setstr >= 1 &&  f==0
  disp('firstframe detected');
  count=count+1;
    finalcount=0;
    precount=0;

  elseif f > 10 && precount==0
     disp('end detected');
     count=count+1; 
     finalcount=count;
     count=0;
            setstr=0;
            precount=1;
  else
  finalcount=0;
  end
  
  if isempty(detection)
    isObjectDetected = false;
  else
    % To simplify the tracking process, only use the first detected object.
    detection = detection(1, :);
    isObjectDetected = true;
  end
end
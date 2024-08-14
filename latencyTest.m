% Tests videos for camera latency by measuring sideslip stimuli luminence
% To run this in Linux, start matlab with this command:
% LD_PRELOAD=/lib/x86_64-linux-gnu/libstdc++.so.6 matlab
% Obtain our video we want to analyse
% How many frames do we want to check
nFrames = 300;
useAllFrames = true;
% Use array of all videos we want to check
videos = ["/home/hoverfly/Documents/RE-Color Fill_14-Aug-2024 13_24_46.mp4", ...
   "/home/hoverfly/Documents/RE-Color Fill_14-Aug-2024 13_24_54.mp4", ...
   "/home/hoverfly/Documents/RE-Color Fill_14-Aug-2024 13_25_01.mp4"];
% Threshold values to determine when stimuli changes
luminence1 = 18;
luminence2 = 25;
luminence3 = 20;

for currentVideo = 1:length(videos)
   disp("% %%%%%% %")
   disp("THE FOLLOWING INFO IS FOR VIDEO:")
   disp(videos(currentVideo))
   disp("% %%%%%% %")
   % Load the video and extract the frames from it
   video = VideoReader(videos(currentVideo));
   allFrames = read(video);
   if useAllFrames == true
        nFrames = size(allFrames, 4);
   end
   % Set up our main variable to check luminence
   avLuminence = zeros(1, nFrames);
  
   flag = 0;
   % Loop through first n frames of video
   for currentFrame = 1:nFrames
       % Extract RGB data from the frame and average it for luminence
       frame = allFrames(:,:,:,currentFrame);
       R = frame(1,320,1);
       G = frame(1,320,2);
       B = frame(1,320,3);
       avLuminence(currentFrame) = (R + G + B) / 3;
       % If the luminence has gone down, mark sideslip beginning
       if flag == 0 && avLuminence(currentFrame) < luminence1
           flag = 1;
           disp("The first frame where the stimulus starts is:")
           disp(currentFrame)
       end
       if flag == 1 && avLuminence(currentFrame) > luminence2
           flag = 2;
           disp("The first frame where the screen goes white is:")
           disp(currentFrame)
       end
       if flag == 2 && avLuminence(currentFrame) < luminence3
           flag = 3;
           disp("The screen goes black again at frame:")
           disp(currentFrame)
           finalSwitch = currentFrame;
       end
   end
   disp("The amount of frames for the last colour (including post-stim time):")
   disp(nFrames-finalSwitch)
end

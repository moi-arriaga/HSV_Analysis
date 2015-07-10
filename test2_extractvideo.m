clear; close all;

basedir = 'Y:\Studies\NORMAL\';
hadfile = 'haddata\s02p1.had';

avifile = 'test2_2000fps_src.avi';

S = hadload([basedir hadfile]);

range = S.StartFrame + [1000 1100];

extract_video(S.VideoFile,range,S.VideoReader.FrameRate/4,avifile);

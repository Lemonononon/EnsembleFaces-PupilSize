% subinfo=getSubInfo;
Screen('Preference', 'SkipSyncTests', 1);
    
HideCursor;

%打开窗口，设置参数
monitor.mon_width = Screen('DisplaySize',0)/10;   % horizontal dimension of viewable screen (cm)
monitor.v_dist = 60;   % viewing distance (cm)
screenNumber=max(Screen('Screens'));
%Screen('Resolution',screenNumber,1024,768,60);
[wptr, wRect]=Screen('OpenWindow',screenNumber, 128,[],32,2);
Screen(wptr,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
[cx,cy]=WindowCenter(wptr);

ppd = round(pi * (wRect(3)-wRect(1)) / atan(monitor.mon_width/monitor.v_dist/2) / 360); % pixel per degree

% 刺激宽、高的大小
sti_width = 4.03*ppd;
sti_height = 4.28*ppd;

sti_interval = 0.1*ppd; %刺激的间隙
cx
cy
sti_width
sti_height
sti_interval

rect_sti{1} = [cx-sti_interval/2-sti_width, cy-sti_interval*3/2-sti_height*2, cx-sti_interval/2, cy-sti_interval*3/2-sti_height];
rect_sti{2} = [cx+sti_interval/2, cy-sti_interval*3/2-sti_height*2, cx+sti_interval/2+sti_width, cy-sti_interval*3/2-sti_height];
rect_sti{3} = [cx+sti_interval*3/2+sti_width, cy-sti_interval/2-sti_height, cx+sti_interval*3/2+sti_width*2, cy-sti_interval/2];
rect_sti{4} = [cx+sti_interval*3/2+sti_width, cy+sti_height/2, cx+sti_interval*3/2+sti_width*2, cy+sti_height/2+sti_height];
rect_sti{5} = [cx+sti_interval/2, cy+sti_interval*3/2+sti_height, cx+sti_interval/2+sti_width, cy+sti_interval*3/2+sti_height*2];
rect_sti{6} = [cx-sti_interval/2-sti_width, cy+sti_interval*3/2+sti_height, cx-sti_interval/2, cy+sti_interval*3/2+sti_height*2];
rect_sti{7} = [cx-sti_interval*3/2-sti_width*2, cy+sti_height/2, cx-sti_interval*3/2-sti_width, cy+sti_height/2+sti_height];
rect_sti{8} = [cx-sti_interval*3/2-sti_width*2, cy-sti_interval/2-sti_height, cx-sti_interval*3/2-sti_width, cy-sti_interval/2];


sca;
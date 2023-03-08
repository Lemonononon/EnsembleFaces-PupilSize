
clear all;

    Screen('Preference', 'SkipSyncTests', 1);

    global subinfo;

    %% 输入被试信息 
    prompt = {'编号','姓名','年龄','性别 (1=男, 2=女) '};
    dlg_title = '被试信息';
    num_line = [1 45;1 45;1 45;1 45];
    def_answer = {'','','',''};
    options = 'off';
    subinfo = inputdlg(prompt,dlg_title,num_line,def_answer,options);
    subID = [subinfo{1}];
    global name;
    name = [subinfo{2}];
    global age;
    age = str2num ([subinfo{3}]);
    gender = str2num([subinfo{4}]);

    % global Gender;
    % if gender == 1
    %     Gender = 'Male';
    % else
    %     Gender = 'Female';
    % end

    % subinfo=getSubInfo;
    
    HideCursor;

    %打开窗口，设置参数
    screenNumber=max(Screen('Screens'));
    %Screen('Resolution',screenNumber,1024,768,60);
    [wptr, wRect]=Screen('OpenWindow',screenNumber, 128,[],32,2);
    Screen(wptr,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    [cx,cy]=WindowCenter(wptr);

    %设置按键
    KbName('UnifyKeyNames');                   %使用通用键位名称
    key.J = KbName('J');
    key.F = KbName('F');
    key.space =  KbName('Space');
    key.escape = KbName('escape');
    RestrictKeysForKbCheck([key.J,key.F,key.space,key.escape]); %KbCheck时检测4个按键

    % 数据保存
    filefind=strcat('results\','FacialMean_',char(subID),'_', name,'.csv');
    if exist(filefind,'file')==0
        fid=fopen(['results\','FacialMean_',char(subID),'_', name,'.csv'],'w');
    else
        filev=2;
        while true
            filefind=strcat('results\','FacialMean_',char(subID),'_', name,'(',num2str(filev),')','.csv');
            if exist(filefind,'file')==0
                fid=fopen(['results\','FacialMean_',char(subID),'_', name,'(',num2str(filev),')','.csv'],'w');
                break;
            else
                filev=filev+1;
            end
        end
    end    
    fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\r\n','Sub','Name','Gender','Group','Trial','Condition','Probecondition','Color1','Color2','Color3','Number1','Number2','Number3','ProbeColor','ProbeNumber','Appearornot','MainRT','MainACC','Subtaskcondition','Subfeature1','Subfeature2','SubRT1','SubACC1','SubRT2','SubACC2');
   

    % 颜色相关
    color.bkg=[0 0 0];
    color.fix=[255 255 255];
    fix = '+';

    % 读入50张图片
    for img_read_index = 1:50

        % [img, map, alpha] = imread( ['sti\P', num2str(img_read_index-1),'.png']);
        % img(:,:,4)=alpha;
        pic(img_read_index) = Screen('MakeTexture', wptr,  imread( ['sti\P', num2str(img_read_index-1),'.png']));
    end
    
    % 8个刺激的位置矩阵
    % rect_sti{1} = [cx-200-55, cy - 280-70, cx-200+55, cy - 280 + 70];
    % rect_sti{2} = [cx+200-55, cy - 280-70, cx+200+55, cy - 280 + 70];
    % rect_sti{3} = [cx+280-55, cy - 200-70, cx+280+55, cy - 200 + 70];
    % rect_sti{4} = [cx+280-55, cy + 200-70, cx+280+55, cy + 200 + 70];
    % rect_sti{5} = [cx+200-55, cy + 280-70, cx+200+55, cy + 280 + 70];
    % rect_sti{6} = [cx-200-55, cy + 280-70, cx-200+55, cy + 280 + 70];
    % rect_sti{7} = [cx-280-55, cy + 200-70, cx-280+55, cy + 200 + 70];
    % rect_sti{8} = [cx-280-55, cy - 200-70, cx-280+55, cy - 200 + 70];

    rect_sti{1} = [cx-130-55, cy - 280-70, cx-130+55, cy - 280 + 70];
    rect_sti{2} = [cx+130-55, cy - 280-70, cx+130+55, cy - 280 + 70];
    rect_sti{3} = [cx+280-55, cy - 130-70, cx+280+55, cy - 130 + 70];
    rect_sti{4} = [cx+280-55, cy + 130-70, cx+280+55, cy + 130 + 70];
    rect_sti{5} = [cx+130-55, cy + 280-70, cx+130+55, cy + 280 + 70];
    rect_sti{6} = [cx-130-55, cy + 280-70, cx-130+55, cy + 280 + 70];
    rect_sti{7} = [cx-280-55, cy + 130-70, cx-280+55, cy + 130 + 70];
    rect_sti{8} = [cx-280-55, cy - 130-70, cx-280+55, cy - 130 + 70];
    
    % 5*12*10
    para_mean = [15 20 25 30 35]; %5
    para_comp = [-2 2 -4 4 -6 6 -8 8 -10 10 -12 12]; % 12

    [x1, x2]=ndgrid( para_mean, para_comp );%生成参数组合矩阵

    para_tmp = [x1(:), x2(:)];
    
    sti_task = []
    for i = 1:8
        sti_task = [sti_task; para_tmp];
    end

    sti_task = Shuffle(sti_task);
    sti_mat = [3 3 -3 -3 9 9 -9 -9];
    sti_resting = [44, 41, 18, 12, 21, 9, 24, 6; 44, 6, 28, 22, 31, 19, 34, 16; 6, 9, 38, 32, 41, 29, 44, 26];  % 情绪强度
    

    Screen('TextSize',wptr,40);
    Screen('TextFont',wptr,'Simsun');
    DrawFormattedText(wptr,'指导语1','center','center',[0,0,0]);
    Screen('Flip',wptr);
    KbWait;

for i = 1:6
    for ii = 1:80
        index = (i-1)*80 + ii
        % 注视点0.5s
        Screen('TextSize',wptr,28);
        Screen('TextFont',wptr,'Times New Roman');
        DrawFormattedText(wptr, fix,'center','center',[0, 0, 0]);
        Screen('Flip',wptr);
        WaitSecs(0.5);
        
        % 刺激
        mean = sti_task( index, 1 );
        order = Shuffle([1 2 3 4 5 6 7 8]); % 8个刺激的位置随机

        % x1 = mean + sti_mat(order(1));
        % x2 = mean + sti_mat(order(2));
        % x3 = mean + sti_mat(order(3));
        % x4 = mean + sti_mat(order(4));
        % x5 = mean + sti_mat(order(5));
        % x6 = mean + sti_mat(order(6));
        % x7 = mean + sti_mat(order(7));
        % x8 = mean + sti_mat(order(8));

        for sti_idx = 1:8
            x = mean+sti_mat(order(sti_idx))
            Screen('DrawTexture', wptr, pic(mean+sti_mat(order(sti_idx))), [], rect_sti{sti_idx});
        end

        Screen('Flip', wptr);

        WaitSecs(1);

        % 0.5s fix
        Screen('TextFont',wptr,'Times New Roman');
        DrawFormattedText(wptr, fix,'center','center',[0, 0, 0]);
        Screen('Flip',wptr);
        WaitSecs(0.5);

        
        % 呈现第二屏刺激之后就可以反应

        % Screen('DrawTexture', wptr);
        Screen('DrawTexture', wptr, pic(mean+sti_task( index, 2 )));
        % DrawFormattedText(wptr, 'Second!!!','center','center',[0, 0, 0]);
        Screen('Flip',wptr);

        t=GetSecs;
        press = 100;
        while true
            if GetSecs-t >= 0.5
                %TODO：呈现提醒被试判断的页面
                DrawFormattedText(wptr, 'F or J','center','center',[0, 0, 0]);
                Screen('Flip',wptr); 
                % Screen('Flip', wptr);
                [secs, kc, deltaSecs] = KbWait;
                % [yy,secs,kc]=KbCheck;
                if kc(key.J)
                    reactiontime2=secs-t;
                    press=0;
                    break;
                elseif kc(key.F)
                    reactiontime2=secs-t;
                    press=1;
                    break;
                elseif kc(key.escape)
                    press=2;
                    fclose(fid);
                    ShowCursor;
                    sca;
                end
                break;
            end
            
            [yy,secs,kc]=KbCheck;
            if kc(key.J)
                reactiontime2=GetSecs-t;
                press=3;
                break;
            elseif kc(key.F)
                reactiontime2=GetSecs-t;
                press=4;
                break;
            elseif kc(key.escape) 
                press = 5;
                fclose(fid);
                ShowCursor;
                sca;
            end
        end

        % 0.5s注视点
        Screen('TextSize',wptr,28);
        Screen('TextFont',wptr,'Times New Roman');
        DrawFormattedText(wptr, fix,'center','center',[0, 0, 0]);
        Screen('Flip',wptr);
        WaitSecs(0.5);

        %记录 TODO
        % fprintf(fid, "%",  );
    end
end
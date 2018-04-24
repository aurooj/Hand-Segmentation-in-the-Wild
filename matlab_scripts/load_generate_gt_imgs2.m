%%%%%%%%%%this script produces masked images for hands only when hands
%%%%%%%%%%are annotated with details.%%%%%%%%%%%%%%%%%%%%
%%%%This script also visualizes the output
%%%%%%%%  images written to the output directory.  
%%%%%%%% Comment out all imshow() statements if you want to speedup the
%%%%%%%% execution of this script.%%%%%%%%%%%%%%%%%%%%

clear all; close all;

folders = {'cards_courtyard_h_s','cards_courtyard_s_h','chess_courtyard_h_s'...
    ,'chess_courtyard_s_h','jenga_courtyard_b_h','jenga_courtyard_h_b',...
    'puzzle_courtyard_b_s','puzzle_courtyard_s_b'};

DIR = 'path/to/output/directory';
SRC_DIR = 'path/to/folder/with/annotations/';


fileID = fopen('annotations.txt','w');%open a file for writing annotations to it.

for id = 1:length(folders)
HOMEANNOTATIONS = fullfile(SRC_DIR,folders(id));

D = LMdatabase(HOMEANNOTATIONS{1});

filters = strsplit(char(folders(id)),'_');%split folder name into components like cards,courtyard, s,h
activity = upper(char(filters(1))); loc = upper(char(filters(2))); actor1 = upper(char(filters(3))); actor2 = upper(char(filters(4)));
% vid = getMetaBy('Location',loc,'Activity',activity,'Viewer',actor1,'Partner',actor2);
% frames = vid.labelled_frames;

if ~exist(char(fullfile(DIR,folders(id))), 'dir')
  mkdir(char(fullfile(DIR,folders(id))));
end

for  idx = 1:length(D)
    try
    objects = D(idx).annotation.object;
    img_name = D(idx).annotation.filename;
    img = imread(fullfile(SRC_DIR,char(folders(id)),'\Images\users\shivengoyal',char(folders(id)),D(idx).annotation.filename));
    [row,col,ch]=size(img);
%     both = both + isBothHands(objects);
    for obj_id = 1:length(objects)
            if(~isempty(regexp(objects(obj_id).name,'hand','once')))
                attributes = objects(obj_id).attributes;
                    if(~isempty(regexp(attributes,'left','once')) && ~isempty(regexp(attributes,'other','once')))
                        poly = objects(obj_id).polygon;
                        BW = poly2mask(double(poly.x),double(poly.y), row, col);
                        ur_left_img = bsxfun(@times, img, cast(BW, 'like', img));
                        %ur_left_img =  getSegImageForEachHand(vid,idx,img,'your_left',[]);
                        imshow(ur_left_img);

                        if(~isempty(ur_left_img))
                            fn = strcat(img_name(1:end-4),'_ul.jpg');
                            imwrite(ur_left_img,char(fullfile(DIR,folders(id),fn)));
                        end
                    elseif(~isempty(regexp(attributes,'right','once')) && ~isempty(regexp(attributes,'other','once')))
                        poly = objects(obj_id).polygon;
                        BW = poly2mask(double(poly.x),double(poly.y), row, col);
                        ur_right_img = bsxfun(@times, img, cast(BW, 'like', img));
                        %ur_right_img = getSegImageForEachHand(vid,idx,img,'your_right',[]);
                        imshow(ur_right_img);
    
                        if(~isempty(ur_right_img))
                            fn = strcat(img_name(1:end-4),'_ur.jpg');
                            imwrite(ur_right_img,char(fullfile(DIR,folders(id),fn)));
                        end
                    elseif(~isempty(regexp(attributes,'left','once')) && ~isempty(regexp(attributes,'first_person','once')))
                            poly = objects(obj_id).polygon;
                            BW = poly2mask(double(poly.x),double(poly.y), row, col);
                            my_left_img = bsxfun(@times, img, cast(BW, 'like', img));
                            %my_left_img = getSegImageForEachHand(vid,idx,img,'my_left',[]);
                            imshow(my_left_img);
                            
                            if(~isempty(my_left_img))
                                fn = strcat(img_name(1:end-4),'_ml.jpg');
                                imwrite(my_left_img,char(fullfile(DIR,folders(id),fn)));
                            end
                    elseif(~isempty(regexp(attributes,'right','once')) && ~isempty(regexp(attributes,'first_person','once')))
                            poly = objects(obj_id).polygon;
                            BW = poly2mask(double(poly.x),double(poly.y), row, col);
                            my_right_img = bsxfun(@times, img, cast(BW, 'like', img));
                            %my_right_img =  getSegImageForEachHand(vid,idx,img,'my_right',[]);
                            imshow(my_right_img);
                            
                            if(~isempty(my_right_img))
                                fn = strcat(img_name(1:end-4),'_mr.jpg');
                                imwrite(my_right_img,char(fullfile(DIR,folders(id),fn)));
                            end
                    end
                            
                        
                attributes = strsplit(char(attributes),',');
                for i = 1:length(attributes)
                    n = char(attributes(i));
                    switch n
                        case 'holding'
                            str = char(strcat(fullfile(DIR,folders(id),fn),' 0'));
                            fprintf(fileID,'%s\n',str);
                        case 'picking'
                            str = char(strcat(fullfile(DIR,folders(id),fn),' 1'));
                            fprintf(fileID,'%s\n',str);
                        case 'placing'
                            str = char(strcat(fullfile(DIR,folders(id),fn),' 2'));
                            fprintf(fileID,'%s\n',str);
                        case 'resting'
                            str = char(strcat(fullfile(DIR,folders(id),fn),' 3'));
                            fprintf(fileID,'%s\n',str);
                        case 'moving'
                            str = char(strcat(fullfile(DIR,folders(id),fn),' 4'));
                            fprintf(fileID,'%s\n',str);
                        case 'replacing'
                            str = char(strcat(fullfile(DIR,folders(id),fn),' 5'));
                            fprintf(fileID,'%s\n',str);
                        case 'thinking'
                            str = char(strcat(fullfile(DIR,folders(id),fn),' 6'));
                            fprintf(fileID,'%s\n',str);
                        case 'pulling'
                            str = char(strcat(fullfile(DIR,folders(id),fn),' 7'));
                            fprintf(fileID,'%s\n',str);
                        case 'pushing'
                            str = char(strcat(fullfile(DIR,folders(id),fn),' 8'));
                            fprintf(fileID,'%s\n',str);
                        case 'stacking'
                            str = char(strcat(fullfile(DIR,folders(id),fn),' 9'));
                            fprintf(fileID,'%s\n',str);
                        case 'adjusting'
                            str = char(strcat(fullfile(DIR,folders(id),fn),' 10'));
                            fprintf(fileID,'%s\n',str);
                        case 'matching'
                            str = char(strcat(fullfile(DIR,folders(id),fn),' 11'));
                            fprintf(fileID,'%s\n',str);
                        case 'pressing'
                            str = char(strcat(fullfile(DIR,folders(id),fn),' 12'));
                            fprintf(fileID,'%s\n',str);
                        case 'highfive'
                            str = char(strcat(fullfile(DIR,folders(id),fn),' 13'));
                            fprintf(fileID,'%s\n',str);
                        case 'pointing'
                            str = char(strcat(fullfile(DIR,folders(id),fn),' 14'));
                            fprintf(fileID,'%s\n',str);
                        case 'catching'
                            str = char(strcat(fullfile(DIR,folders(id),fn),' 15'));
                            fprintf(fileID,'%s\n',str);
                        otherwise
                            disp(n)
                    end
                    
                end

            end
     end
    catch ME
        msg = ME.message
        continue;
    end
    
    
end

end
fclose(fileID);
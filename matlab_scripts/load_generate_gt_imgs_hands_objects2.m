%%%%%%%%%%this script produces masked images for hand_objects when hands
%%%%%%%%%%are annotated detailed. This script also visualizes the output
%%%%%%%%%%%%%%%%%%%%  images written to the output directory.  
%%%%%%%% Comment out all imshow() statements if you want to speedup the
%%%%%%%% execution of this script.

clear all; close all;

folders = {'cards_courtyard_h_s','cards_courtyard_s_h','chess_courtyard_h_s',...
    'chess_courtyard_s_h','jenga_courtyard_b_h','jenga_courtyard_h_b',...
    'puzzle_courtyard_b_s','puzzle_courtyard_s_b'};

%DIR to save your resulting images
DIR = 'path\to\save\output\images\';

fileID = fopen('inputfile_fineannotations.txt','w');%open a file for writing image paths along with annotations to it.

% iterating over each folder
for id = 1:length(folders)
    
HOMEANNOTATIONS = fullfile('path\to\egohands\fine\annotations\folders\',folders(id));

D = LMdatabase(HOMEANNOTATIONS{1});%read annotations for each video using Labelme library function

filters = strsplit(char(folders(id)),'_');%split folder name into components like cards,courtyard, s,h
activity = upper(char(filters(1))); loc = upper(char(filters(2))); actor1 = upper(char(filters(3))); actor2 = upper(char(filters(4)));

% if DIR for output images doesn't exist already, then create it.
if ~exist(char(fullfile(DIR,folders(id))), 'dir')
  mkdir(char(fullfile(DIR,folders(id))));
end

%for each image
for  idx = 1:length(D)
    
    %get all annotated objects in that image
    objects = D(idx).annotation.object; 
    img_name = D(idx).annotation.filename;
    img = imread(fullfile('C:\Users\Vision\Documents\MATLAB\EgoHands_FineAnnotations\labelme',char(folders(id)),'\Images\users\shivengoyal',char(folders(id)),D(idx).annotation.filename));
    [row,col,ch]=size(img);
   
    for obj_id = 1:length(objects)
        
    try
            %if the object is a hand
            if(~isempty(regexp(objects(obj_id).name,'hand','once')))
                
                %get the object in that hand
                obj = getObjectForHand(objects(obj_id),objects);
                
                %read the attributes for that hand object
                attributes = objects(obj_id).attributes;
                    %if the hand is left hand of third person
                    if(~isempty(regexp(attributes,'left','once')) && ~isempty(regexp(attributes,'other','once')))
                         if(~isempty(obj)) %if hand is manipulating some object
                            for i = 1:length(obj)
                                poly = objects(obj_id).polygon;
                                BW = poly2mask(double(poly.x),double(poly.y), row, col);
                                BW = BW+poly2mask(double(obj{i}(1:2:end)),double(obj{i}(2:2:end)),row,col);
                                ur_left_img = bsxfun(@times, img, cast(BW, 'like', img));
                                imshow(BW)
                                imshow(ur_left_img)                                                               
                                
                                if(~isempty(ur_left_img))
                                    %write image in destination folder
                                    fn = strcat(img_name(1:end-4),'_',num2str(i),'_ul.jpg');%filename for image
                                    imwrite(ur_left_img,char(fullfile(DIR,folders(id),fn)));
                                end
                            end
                         else %if hand is not manipulating any object
                              poly = objects(obj_id).polygon;
                              BW = poly2mask(double(poly.x),double(poly.y), row, col);
                              ur_left_img = bsxfun(@times, img, cast(BW, 'like', img));                                                          
                              imshow(ur_left_img);

                            if(~isempty(ur_left_img))
                                %write image in destination folder
                                fn = strcat(img_name(1:end-4),'_ul.jpg');%filename for image
                                imwrite(ur_left_img,char(fullfile(DIR,folders(id),fn)));
                            end
                         end
                    %if the hand is right hand of third person
                    elseif(~isempty(regexp(attributes,'right','once')) && ~isempty(regexp(attributes,'other','once')))
                         if(~isempty(obj))%if hand is manipulating some object
                            for i = 1:length(obj)
                                poly = objects(obj_id).polygon;
                                BW = poly2mask(double(poly.x),double(poly.y), row, col);
                                BW = BW+poly2mask(double(obj{i}(1:2:end)),double(obj{i}(2:2:end)),row,col);
                                ur_right_img = bsxfun(@times, img, cast(BW, 'like', img));                                

                                imshow(ur_right_img);

                                if(~isempty(ur_right_img))
                                    fn = strcat(img_name(1:end-4),'_',num2str(i),'_ur.jpg');
                                    imwrite(ur_right_img,char(fullfile(DIR,folders(id),fn)));
                                end
                            end
                         else %if hand does not have any object in it
                              poly = objects(obj_id).polygon;
                              BW = poly2mask(double(poly.x),double(poly.y), row, col);
                              ur_right_img = bsxfun(@times, img, cast(BW, 'like', img));                                                          
                              imshow(ur_right_img);

                                if(~isempty(ur_right_img))
                                    fn = strcat(img_name(1:end-4),'_ur.jpg');
                                    imwrite(ur_right_img,char(fullfile(DIR,folders(id),fn)));
                                end                      
                         end
                     %if the hand is left hand of first person
                    elseif(~isempty(regexp(attributes,'left','once')) && ~isempty(regexp(attributes,'first_person','once')))
                         if(~isempty(obj))%if hand is manipulating some object
                            for i = 1:length(obj) 
                                poly = objects(obj_id).polygon;
                                BW = poly2mask(double(poly.x),double(poly.y), row, col);
                                BW = BW+poly2mask(double(obj{i}(1:2:end)),double(obj{i}(2:2:end)),row,col);
                                my_left_img = bsxfun(@times, img, cast(BW, 'like', img));
                                
                                imshow(my_left_img);

                                if(~isempty(my_left_img))
                                    fn = strcat(img_name(1:end-4),'_',num2str(i),'_ml.jpg');
                                    imwrite(my_left_img,char(fullfile(DIR,folders(id),fn)));
                                end
                            end
                         else %if hand is not manipulating any object
                                poly = objects(obj_id).polygon;
                                BW = poly2mask(double(poly.x),double(poly.y), row, col);
                                my_left_img = bsxfun(@times, img, cast(BW, 'like', img));                                                    
                                imshow(my_left_img);

                                if(~isempty(my_left_img))
                                    fn = strcat(img_name(1:end-4),'_ml.jpg');
                                    imwrite(my_left_img,char(fullfile(DIR,folders(id),fn)));
                                end
                         end
                    %if the hand is "right" hand of first person
                    elseif(~isempty(regexp(attributes,'right','once')) && ~isempty(regexp(attributes,'first_person','once')))
                            if(~isempty(obj))%if hand is manipulating some object
                                for i = 1:length(obj)
                                    poly = objects(obj_id).polygon;
                                    BW = poly2mask(double(poly.x),double(poly.y), row, col);
                                    BW = BW+poly2mask(double(obj{i}(1:2:end)),double(obj{i}(2:2:end)),row,col);
                                    my_right_img = bsxfun(@times, img, cast(BW, 'like', img));                                    
%                                                                     
                                    imshow(my_right_img);

                                    if(~isempty(my_right_img))
                                        fn = strcat(img_name(1:end-4),'_',num2str(i),'_mr.jpg');
                                        imwrite(my_right_img,char(fullfile(DIR,folders(id),fn)));
                                    end
                                end
                            else %if hand is not manipulating any object
                                poly = objects(obj_id).polygon;
                                BW = poly2mask(double(poly.x),double(poly.y), row, col);
                                my_right_img = bsxfun(@times, img, cast(BW, 'like', img));                                                              
                                imshow(my_right_img);

                                 if(~isempty(my_right_img))
                                     fn = strcat(img_name(1:end-4),'_mr.jpg');
                                     imwrite(my_right_img,char(fullfile(DIR,folders(id),fn)));
                                 end
                            end
                    end
                            
                %write the path/to/img with its label in txt file which will be used
                %as an input to the caffe network for training and testing
                attributes = strsplit(char(attributes),',');
                
                % assign a label for corresponding action e.g., if
                % attributes of hand has action 'holding', then label is 0.
                for i = 1:length(attributes)
                    n = char(attributes(i));
                    switch n
                        case 'holding'
                            str = char(strcat(fullfile(DIR,folders(id),fn),' 0'));
                            fprintf(fileID,'%s\n',str);%write to file
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
                            disp(n)%displays non-actions attributes, useful for debugging
                    end
                    
                end

            end
        catch ME
        msg = ME.message
        ME.stack.name 
        ME.stack.line
        continue;
    end
    end
    
    
    
    
end

end
fclose(fileID);
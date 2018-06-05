close all; clear all;

gt_dir = '/path/to/refinenet/datasets/EgoHands/SegmentationClass/test';
pred_dir = '/path/to/refinenet/cache_data/EgoHands/';
im_dir = '/path/to/refinenet/datasets/EgoHands';

dir1 = dir(fullfile(gt_dir));
%remove '.' and '..' from directories
dir1=dir1(~ismember({dir1.name},{'.','..'}));

idx = 1;
 num_of_frames = 800; 

IOU = zeros(1,num_of_frames,'double');
Precision = zeros(1,num_of_frames,'double');
Recall = zeros(1,num_of_frames,'double');

for i = 1:length(dir1)
    vid_name=dir1(i).name  
     
    %read frames from folder
    img_files = dir(fullfile(gt_dir,vid_name));
    %remove '.' and '..' from directories
    img_files=img_files(~ismember({img_files.name},{'.','..'}));

   for j = 1:length(img_files)
        gt_fr_name = img_files(j).name;
     
        gt_map = imread(fullfile(gt_dir,dir1(i).name,gt_fr_name));

        %now get predicted output for the ground truth
         pred_frame_path = fullfile(pred_dir,vid_name,strcat(gt_fr_name(1:end-4),'.png'));     

    
        pred_im = double(imread(pred_frame_path)); 
        if(size(pred_im) ~= size(gt_map))
            gt_map = imresize(gt_map,size(pred_im));           
        end
   
        if(~islogical(gt_map))
            gt_map = imbinarize(gt_map);
        end

        pred_im = pred_im./255;
        
        pred_im = imbinarize(pred_im);

        [iou,prec,recall] = getIOU(pred_im, gt_map, 1);

   
        IOU(idx)=iou;
        Precision(idx)=prec;
        Recall(idx)=recall;  
        idx = idx+1;
   end 
end


mean_IOU = sum(IOU(:))/num_of_frames
mean_prec = sum(Precision(:))/num_of_frames
mean_recall = sum(Recall(:))/num_of_frames
fprintf(1, 'The mean Intersection_over_Union for all videos is %d\n',mean_IOU);



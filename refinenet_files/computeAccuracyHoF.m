close all; clear all;

gt_dir = '/home/zxi/refinenet/datasets/ADE20K_hand_images/SegmentationClass/test';
pred_dir = '/home/zxi/refinenet/cache_data/Multiscale_evaluation_refinenet/ade_on_ade/test/predict_result_mask';
im_dir = '/home/zxi/refinenet/datasets/ADE20K_hand_images/JPEGImages/test';


dir1 = dir(fullfile(pred_dir));
%remove '.' and '..' from directories
dir1=dir1(~ismember({dir1.name},{'.','..'}));

idx = 1;
 num_of_frames = length(dir1);


IOU = zeros(1,num_of_frames,'double');
Precision = zeros(1,num_of_frames,'double');
Recall = zeros(1,num_of_frames,'double');

for j = 1:length(dir1)
    gt_fr_name = dir1(j).name;
    im = imread(fullfile(im_dir,strcat(gt_fr_name(1:end-4),'.jpg')));
    gt_map = imread(fullfile(gt_dir,dir1(j).name));
    
    %now get predicted output for the ground truth
    pred_frame_path = fullfile(pred_dir,strcat(gt_fr_name(1:end-4),'.png'));   
       
    pred_im = imread(pred_frame_path);  
    
    if(~islogical(gt_map))
        gt_map = imbinarize(gt_map); %works in matlab 2017
        %gt_map = im2bw(gt_map,0.1); %use this line for matlab version < 2017
    end
    [iou,prec,recall,mcr] = getIOU(pred_im,gt_map,1);
        
    
    IOU(j)=iou;
    Precision(j)=prec;
    Recall(j)=recall;  
   
end 



mean_IOU = sum(IOU(:))/num_of_frames
mean_prec = sum(Precision(:))/num_of_frames
mean_recall = sum(Recall(:))/num_of_frames
fprintf(1, 'The mean Intersection_over_Union for all videos is %d\n',mean_IOU);



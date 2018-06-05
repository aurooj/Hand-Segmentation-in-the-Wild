close all; clear all;

gt_dir = '/home/zxi/refinenet/datasets/gtea/SegmentationClass/testset';

pred_dir = '/home/zxi/refinenet/cache_data/Multiscale_evaluation_refinenet/gtea/test/predict_result_mask';

im_dir = '/home/zxi/refinenet/datasets/gtea/JPEGImages/testset';


dir1 = dir(fullfile(pred_dir));

%remove '.' and '..' from directories
dir1=dir1(~ismember({dir1.name},{'.','..'}));

num_of_frames = length(dir1);

IOU = zeros(1,num_of_frames,'double');
Precision = zeros(1,num_of_frames,'double');
Recall = zeros(1,num_of_frames,'double');

for j = 1:length(dir1)
    gt_fr_name = dir1(j).name;
    im = imread(fullfile(im_dir,strcat(gt_fr_name(1:end-4),'.jpg')));
    gt_map = imread(fullfile(gt_dir,strcat(gt_fr_name(1:end-4),'.jpg')));
    
    %now get predicted output for the ground truth
    pred_frame_path = fullfile(pred_dir,strcat(gt_fr_name(1:end-4),'.png'));
       
       
    pred_im = imread(pred_frame_path);  
    
    %if(~(size(gt_map)~=size(pred_im)))
    gt_map = imresize(gt_map,size(pred_im));
   % end
    
    if(~islogical(gt_map))
        gt_map = imbinarize(gt_map);
    end
    [iou,prec,recall] = getIOU(pred_im,gt_map,1);    
    
   
    IOU(j)=iou;
    Precision(j)=prec;
    Recall(j)=recall;  
  
end 

mean_IOU = sum(IOU(:))/num_of_frames
mean_prec = sum(Precision(:))/num_of_frames
mean_recall = sum(Recall(:))/num_of_frames
fprintf(1, 'The mean Intersection_over_Union for all images is %d\n',mean_IOU);



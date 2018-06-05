close all; clear all;

gt_dir = '/home/zxi/refinenet/datasets/eyth/SegmentationClass/testset';
pred_dir = '/home/zxi/refinenet/cache_data/Multiscale_evaluation_refinenet/eyth_on_eyth';
im_dir = '/home/zxi/refinenet/datasets/eyth/JPEGImages/testset';

dir1 = dir(fullfile(gt_dir));
%remove '.' and '..' from directories
dir1=dir1(~ismember({dir1.name},{'.','..'}));

idx = 1;
num_of_frames = 258;

IOU = zeros(1,num_of_frames,'double');
Precision = zeros(1,num_of_frames,'double');
Recall = zeros(1,num_of_frames,'double');

for i = 1:length(dir1)
     vid_name=dir1(i).name;  
     
    %read frames from folder
    img_files = dir(fullfile(gt_dir,vid_name));
    %remove '.' and '..' from directories
    img_files=img_files(~ismember({img_files.name},{'.','..'}));

   for j = 1:length(img_files)
        gt_fr_name = img_files(j).name;
        im = imread(fullfile(im_dir,vid_name,strcat(gt_fr_name(1:end-4),'.jpg')));
        gt_map = imread(fullfile(gt_dir,dir1(i).name,gt_fr_name));

        %now get predicted output for the ground truth
         pred_frame_path = fullfile(pred_dir,vid_name, 'predict_result_mask',strcat(gt_fr_name(1:end-4),'.png'));    
        try
            pred_im = imread(pred_frame_path);  
            if(size(pred_im) ~= size(gt_map))
                pred_im = imresize(pred_im,size(gt_map));
            end
        catch
            continue;
        end
        [iou,prec,recall] = getIOU(pred_im,gt_map,1);
        if(iou==0)            
            num_of_frames = num_of_frames - 1;
        end
           
        IOU(idx)=iou;
        Precision(idx)=prec;
        Recall(idx)=recall;  
        idx = idx+1;
   end 
end


%fprintf(1, 'The mean Intersection_over_Union for cards videos is %d\n The mean Intersection_over_Union for chess videos is %d\n The mean Intersection_over_Union for jenga videos is %d\n The mean Intersection_over_Union for puzzle videos is %d\n '...
%    ,mean_cards_IOU,mean_chess_IOU,mean_jenga_IOU,mean_puzzle_IOU);

mean_IOU = sum(IOU(:))/num_of_frames
mean_prec = sum(Precision(:))/num_of_frames
mean_recall = sum(Recall(:))/num_of_frames
fprintf(1, 'The mean Intersection_over_Union for all videos is %d\n',mean_IOU);



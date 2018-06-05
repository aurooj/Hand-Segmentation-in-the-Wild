%this script generates final prediction maps after averaging the scoremaps
%across different scales. 
% This code assumes that the prediction scoremaps have already been 
% generated for the mentioned destination folder with following naming
% convention: <folder_name>_<scale> e.g. egohands_0.6, egohands_0.8 and
% egohands_1.0 provided that the scales are same as mentioned in this file.
% e.g. if scales = [0.8 1.0], then this script will only look for folders
% with <foldername>_0.8 and <foldername>_1.0 respectively.
close all; clear all;
src_dir = '/home/zxi/refinenet/cache_data/gtea_on_gtea/'
dest_dir = '/home/zxi/Desktop/research/densecrf_on_all_datasets/gtea-valset/'

scales = [0.6 0.8 1.0];

img_size = [216 384];% for Egohands
%img_size = [405 720]; % for GTEA


folder_name = 'val';

folders = dir(fullfile(src_dir,strcat(folder_name,'_',num2str(scales(1),1))));

%remove '.' and '..' from directories
folders=folders(~ismember({folders.name},{'.','..'}));

%folders = {};

for i = 1:length(folders)
    %for each file, read scoremap from its respective folder for all scales
    % take the average scoremap, and get prediction map for that.
    %write it back to destination folder
    folder = strcat(folder_name,'_',num2str(scales(1),1));
    path_to_sc_maps = fullfile(src_dir,folder,folders(i).name,'predict_result_full');
    
    files = dir(path_to_sc_maps)
    %remove '.' and '..' from directories
    files=files(~ismember({files.name},{'.','..'}));

    for j = 1:length(files)
        path_to_one_map = fullfile(path_to_sc_maps,files(j).name);
        sc_map1 = load(path_to_one_map);
        sc_map1 = double(sc_map1.data_obj.score_map);
        
        score_map_size=size(sc_map1);
        score_map_size=score_map_size(1:2);
        
        if any(img_size~=score_map_size)
             sc_map1=log(sc_map1);
             sc_map1=max(sc_map1, -20);
            sc_map1=my_resize(single(sc_map1), img_size);
             sc_map1=exp(sc_map1);
        end        
        
        sum_sc = double(sc_map1); %initialize with first score_map
        
        for k = 2:length(scales)            
            folder = strcat(folder_name,'_',num2str(scales(k),1));
            path_to_sc_maps = fullfile(src_dir,folder,folders(i).name,'predict_result_full');
            path_to_one_map = fullfile(path_to_sc_maps,files(j).name);
            
            sc_map = load(path_to_one_map);        
            sc_map = double(sc_map.data_obj.score_map);
            
            score_map_size=size(sc_map);
            score_map_size=score_map_size(1:2);
            
            if any(img_size~=score_map_size)
                 sc_map=log(sc_map);
                 sc_map=max(sc_map, -20);
                 sc_map=my_resize(single(sc_map), img_size);
                 sc_map=exp(sc_map);
            end
                      
            sum_sc = sum_sc + double(sc_map);
        end
        meansc_map = sum_sc/length(scales);%average scoremap over multiple scales
        imshow(meansc_map)
        
        file_name = files(j).name;
        file_name = strcat(file_name(1:end-4),'.png');
         
         %uncomment if want to save scoremaps
         path_to_dest_scmaps = fullfile(dest_dir,'score_maps',folders(i).name);
         if(~exist(path_to_dest_scmaps,'dir'))
            mkdir(path_to_dest_scmaps);
         end
         map_to_write = gather(meansc_map);
         save(fullfile(path_to_dest_scmaps,files(j).name),'map_to_write');
        
        [~, predict_mask]=max(meansc_map,[],3);
%         imshow(predict_mask,[])
        
        class_info = gen_class_info_ego();
        predict_mask_data=class_info.class_label_values(predict_mask);
        %%unique(predict_mask_data) %uncomment for debug only
        path_to_dest = fullfile(dest_dir,folders(i).name,'predict_result_mask');
        if(~exist(path_to_dest,'dir'))
            mkdir(path_to_dest)
        end
        
        imwrite(logical(predict_mask_data),fullfile(path_to_dest,file_name));
    end    
end





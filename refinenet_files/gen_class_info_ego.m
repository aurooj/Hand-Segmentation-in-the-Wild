
function class_info=gen_class_info_ego()

class_info=[];

class_info.class_names = { 'background', 'hand','void'}'; 
        

void_class_value=255;
class_info.class_label_values=uint8([0:1 void_class_value]);
class_info.background_label_value=uint8(0);
class_info.void_label_values=uint8(void_class_value);

% addpath ../libs/VOCdevkit_2012/VOCcode
class_info.mask_cmap = VOClabelcolormap(256);

class_info=process_class_info(class_info);

end
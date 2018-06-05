function [ IOU, Precision, Recall,MCR ] = getIOU( pred_map,gt_map,get_other_scores)
%this function computes IOU when given a prediction map and respective
%ground truth map. Both pred_map and gt_map should be 2D binary maps.

%   INPUT: pred_map: a binary image prediction map
%          gt_map: a binay image ground truth map
%          get_other_scores: An optional flag which by default is zero.
%          Returns Precision, Recall and MCR(miss classification rate) scores if set to 1.
%   OUTPUT: IOU: Intersection over Union score which should be a scalar
%   number between the range [0,1].
IOU=0; Precision=0; Recall=0;MCR=0;
if(nargin <2)
    error('input_example :  pred_map and gt_map are required inputs');
end
if(nargin == 2 && nargin < 3)
    get_other_scores = 0;
end
 %compute true_positives
 true_pos = (pred_map.*gt_map);
 
 num_pxls = size(pred_map,1)*size(pred_map,2);
 
 TP_count = sum(true_pos(:));
        
 %compute false_positives
 FP_count = sum(pred_map(:)) - TP_count;
        
 %compute false negatives
 FN_count = sum(gt_map(:)) - TP_count;   
 
 if(TP_count~=0 || (TP_count~=0 && FN_count~=0))
      IOU = (TP_count/(TP_count+FP_count+FN_count));
      if(get_other_scores)
          Precision = (TP_count/(TP_count+FP_count));
          Recall = (TP_count/(TP_count+FN_count));
          MCR = (FP_count+FN_count)/num_pxls;
      else
          Precision = 0;
          Recall = 0;
          MCR = 0;
      end
 end

end


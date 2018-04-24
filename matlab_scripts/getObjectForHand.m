function [ obj ] = getObjectForHand( hand_obj, all_obj )
% getObjectForHand this function returns object which is being handled by a
% specific hand.
% Input: hand_obj, all_obj
% Output: obj: Object being handled by hand_obj
is_both_hands = 0;
attributes = hand_obj.attributes;

hand_type = getHandType(attributes);

hand_idx = vec2ind(hand_type'); % get index for hand type from one-hot vector
obj_type = getObjectType(attributes);
object_exists = ~strcmp(obj_type,'_');
switch hand_idx
    case 1 % other_left hand
         %return object being handled by this hand, if any
            if(object_exists)
                datarow = getObject(all_obj, obj_type,'other','left');   
             
            end

    case 2 % other_right hand
         %return object being handled by this hand, if any
            if(object_exists)
                datarow = getObject(all_obj, obj_type, 'other', 'right');   

            end
         
    case 3 % my_left hand
         %return object being handled by this hand, if any
            if(object_exists)
                datarow = getObject(all_obj, obj_type,'first_person','left');            
            end
         
    case 4 % my_right hand
         %return object being handled by this hand, if any
            if(object_exists)
                datarow = getObject(all_obj, obj_type,'first_person','right');            
            end
         
    otherwise
        disp('Error: Invalid hand type.');
end
if(object_exists)
    
    for i = 1:size(datarow,2)
        poly = datarow(i).polygon;  
        poly = [poly.x poly.y];
        obj{i} = reshapeAreaCoords(poly);
    end
else
    obj = cell(0)
end

end

function [type] = getHandType(hand_attr)   
    % this function returns hand type based on hand attributes in one hot
    % encoding format. output will be of format [is_other_left is_other_right is_my_left is_my_right]
    % Sample: [0 0 0 1] means hand type is first person's right hand.
    is_other_left = ~isempty(regexp(hand_attr,'left','once')) && ~isempty(regexp(hand_attr,'other','once'));
    is_other_right = ~isempty(regexp(hand_attr,'right','once')) && ~isempty(regexp(hand_attr,'other','once'));
    is_my_left = ~isempty(regexp(hand_attr,'left','once')) && ~isempty(regexp(hand_attr,'first_person','once'));
    is_my_right = ~isempty(regexp(hand_attr,'right','once')) && ~isempty(regexp(hand_attr,'first_person','once'));
    
    type = [is_other_left is_other_right is_my_left is_my_right];
end

function [obj_type] = getObjectType(hand_attr)
% this function returns object type when input is hand attributes
% object type can be 'cards', 'puzzle_piece', 'chess_piece', 'jenga_block' or '_'
% where '_' means no object is being handled by this hand.
attr_parts = strsplit(hand_attr,',');
size_of_attributes_parts = size(attr_parts);
obj_type = attr_parts(end-1);

end

function [action] = getActionType(hand_attr)
%this function returns action type when input is hand attributes
% action type can be one of the 16 action classes
attr_parts = strsplit(hand_attr,',');
action = attr_parts(2:end-2);
end

function [out_rows] = getObject(objects, object_name,hand_type,hand_side)
%works for only string values    
    out_rows = struct();
    %fieldvalue
    for i=1:length(objects)
        %if object is same as object type and hand is also same as hand
        %type
        if(strcmp(objects(i).name,char(object_name)) && ~isempty(regexp(objects(i).attributes,hand_type,'once')) && ~isempty(regexp(objects(i).attributes,hand_side,'once')))

            out_rows = struct(objects(i));
            %% to do: check if the object is for the correct hand(may be check some common coordinates                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          )
        end
    end
    
end



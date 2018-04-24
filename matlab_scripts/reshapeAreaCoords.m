function shape2 = reshapeAreaCoords(shape)
	shape2 = zeros(1, 2*length(shape));
	shape2(1:2:end) = shape(:,1)';
	shape2(2:2:end) = shape(:,2)';
end
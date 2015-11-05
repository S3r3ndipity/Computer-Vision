function out = add_border(inp,type,width)
%
%  add border of given type and width to 
%  an image


if (nargin<3)
    width = 10;
end

if (nargin<2)
    type = 'zero';
end

s = size(inp);

switch type(1)
case 'z',
    s(2)=width;
    z = zeros(s);
    tmp = [z, inp, z];
    s = size(tmp);
    s(1)=width;
    z = zeros(s);
    out = [z;tmp;z];
case 'd',
    c = inp(:,1,:);
    left = repmat(c,1,width);
    c = inp(:,s(2),:);
    right = repmat(c,1,width);
    tmp = [left, inp, right];
    s = size(tmp);
    r = tmp(1,:,:);
    top = repmat(r,width,1);
    r = tmp(s(1),:,:);
    bot = repmat(r,width,1);
    out = [top;tmp;bot];
case 'c',
    left = inp(:,1:width,:);
    right = inp(:,(s(2)-width+1):s(2),:);
    tmp = [right,inp,left];
    s = size(tmp);
    top = tmp(1:width,:,:);
    bot = tmp((s(1)-width+1):s(1),:,:);
    out = [bot;tmp;top];
otherwise,
    error('Invalid input arguments.');
end
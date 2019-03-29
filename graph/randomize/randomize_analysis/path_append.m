function p = path_append(p, extend)
if ~iscell(extend)
    extend = {extend};
end
for i = 1:length(extend)
    p = sprintf('%s%s%s',p, filesep, extend{i});
end

end
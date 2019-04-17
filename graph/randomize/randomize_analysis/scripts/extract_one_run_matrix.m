d = dist_data.node_4.randomize_bct_D_low_attempts;
switches = zeros(length(d));
total_count = 10000;
names = {'Alpha', 'Bravo','Charlie', 'Delta','Echo','Foxtrot',...
    'Golf','Hotel','India','Juliet','Kilo','Lima','Mike','November',...
    'Oscar','Papa','Quebec','Romeo','Sierra','Tango',...
    'Uniform','Victor','Whiskey','X-ray','Yankee','Zulu'};

for i = 1:length(d)
    matched_names = extractfield(d(i).distribution, 'name');
    for ni = 1:length(matched_names)
         name = matched_names{ni};
         j = find(contains(names, name));
         switches(i, j) = d(i).distribution(ni).count/total_count;
    end
end
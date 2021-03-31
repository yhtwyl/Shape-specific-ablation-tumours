% loop = randi(1,1);
% switch loop
% case 1
%     disp(1);
% case 2
%     disp(2);
% case 3
%     disp(3);
% end
longitude = 90;latitude = 180; area = 400;
        fprintf('Area of ablation on slice covering max spread of tumour for trocar entry at: \n');
        formatSpec = '%3d%c N and %3d%c E is %4.2f mm\n';
        fprintf(formatSpec, longitude, char(176), latitude, char(176), area);
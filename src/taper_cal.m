clear all
% This code calculates the surface slope (alpha angles) and basal dip (beta angles) of accretionary wedges
% Written by Haobo Xu on 01/11/2023
%
% Two main steps:
% 1. Smoothing with a 15×15km mean filter to reduce extreme values
% 2. Use moving window (15km length) to measure seafloor slope α and basal dip β along N-S profiles
% 
% Input data:   dec_depth_raw.grd      = plate interface depth grid 
%               mak-topo_regird.grd    = seafloor topography grid
% 
% Parameters:   yscale       = 15000  (m) Smoothing length in y-direction
%               xscale       = 15000  (m) Smoothing length in x-direction
%               window_length= 5000/15000/25000 m (Moving window length)
%                              This study uses 15000 m
% Output:       alpha.grd     = Grid of alpha values

% ============================ Read Grid Data ===================================
[lat1,long1,depth] = grdread1('Makran_topo.grd');
% [lat1,long1,depth] = grdread1('dec_depth-r.grd');
[r,c] = size(depth);                                        % Matrix dimensions: r=latitude, c=longitude
slope1 = zeros(r,c);
slope2 = zeros(r,c);
slope3 = zeros(r,c);
dx = (long1(3)-long1(2)) * 111000 * cos(mean(long1));       % X-spacing in meters
dy = (lat1(3)-lat1(2)) * 111000;                            % Y-spacing in meters

% =============== Step 1: Smooth Topographic Profile ===========================
% =============== Calculate x/y scale parameters (xscale=a, yscale=b) =========
yscale = 15000;                                             % Y-direction smoothing window width (m)
xscale = 15000;                                             % X-direction smoothing window width (m)
ny = round(yscale/dy);                                      % Window size in y-direction (grid points)
nx = round(xscale/dx);                                      % Window size in x-direction (grid points)

Window_length = 5000;                                       % Moving window half-length for slope calculation
% Pad array boundaries for smoothing
h = padarray(depth, [nx ny], 'replicate');
% Apply 2D mean filter
h_add = nlfilter(h, [nx ny], @mean2);  
[m,n] = size(h_add);                                        % Get padded matrix size
depth_smooth = h_add(nx+1:m-nx, ny+1:n-ny);                 % Extract original grid area

% Calculate slope with azimuth=90° (N-S direction)
scale = round(Window_length/2/dx);                          % Convert window length to grid points
o = scale;                                                  % Half window size in grid points
% ============================ Calculate Slope =================================
for i = 1:c
    for j = o+1:1:r-o
        diff_dep = (depth_smooth(j+o,i) - depth_smooth(j-o,i));  % Depth difference
        slope1(j,i) = 180/pi * atan(diff_dep/(dx*2*o));          % Slope in degrees
    end
    slope1(r,i) = slope1(r-1,i);                                 % Fill last row with previous row data
end

% ================ Calculate Slope Statistics =================================
asd = find(slope1==0);
slope1(asd) = NaN;                                          % Replace zeros with NaN

% Plot histogram for 5km window
histogram(slope1, 'BinWidth',0.2, 'EdgeColor','b', 'EdgeAlpha',1,...
         'FaceAlpha',0.5, 'LineWidth',1.5)
xlabel('Alpha (°)');
ylabel('Frequency');
mean1 = mean(slope1,"all","omitnan");
std1 = std(slope1);
hold on 

% =============== Repeat process for 15km window ===============================

Window_length = 15000;                                      % Moving window half-length for slope calculation
scale = round(Window_length/2/dx);
o = scale;

for i = 1:c
    for j = o+1:1:r-o
        diff_dep = (depth_smooth(j+o,i) - depth_smooth(j-o,i));
        slope2(j,i) = 180/pi * atan(diff_dep/(dx*2*o));
    end
    slope2(r,i) = slope1(r-1,i);
end

asd = find(slope2==0);
slope2(asd) = NaN;

% Plot histogram for 15km window
histogram(slope2, 'BinWidth',0.2, 'EdgeColor','r', 'EdgeAlpha',1,...
         'FaceAlpha',0.5, 'LineWidth',1.5)
mean2 = mean(slope2,"all","omitnan");
std2 = std(slope2);

% =============== Repeat process for 25km window ===============================

Window_length = 25000;
scale = round(Window_length/2/dx);
o = scale;

for i = 1:c
    for j = o+1:1:r-o
        diff_dep = (depth_smooth(j+o,i) - depth_smooth(j-o,i));
        slope3(j,i) = 180/pi * atan(diff_dep/(dx*2*o));
    end
    slope1(r,i) = slope1(r-1,i);
end

asd = find(slope3==0);
slope3(asd) = NaN;

% Plot histogram for 25km window
histogram(slope3, 'BinWidth',0.2, 'EdgeColor','#4eb24d', 'EdgeAlpha',1,...
         'FaceAlpha',0.5, 'LineWidth',1.5)
% xlim([-6 10])
legend('5km','15km','25km');
mean3 = mean(slope3,"all","omitnan");
std3 = std(slope3);
hold on
%====================Write into grid=======================================
grd_write1(lat1,long1,slope2,'alpha.grd');%
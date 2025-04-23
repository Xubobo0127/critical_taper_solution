%%%%%%%%%%%%%%write lon lat z to GMT 5 (netcdf4) grd format;
%%%%%%%Tao Zhang, 14/Feb/2014;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function grd_write1(long,lat,z,fname)
delete(fname);
%%%%%%%%%%Creat grd file, value name and dimensions;
nccreate(fname,'x','Dimensions',{'x' length(long)},'Format','netcdf4');
nccreate(fname,'y','Dimensions',{'y' length(lat)},'Format','netcdf4');
nccreate(fname,'z','Dimensions',{'x' length(long) 'y' length(lat)},'Format','netcdf4');


%%%%%%%Write in the value;
ncwrite(fname,'x',long);
ncwrite(fname,'y',lat);
ncwrite(fname,'z',z');

%%%%%%%write in the attributes
ncwriteatt(fname,'/','creation_date',datestr(now));
ncwriteatt(fname,'/','history','Write with grd_write1.m from xu mingzhu');
ncwriteatt(fname,'/','Conventions','COARDS, CF-1.5');
ncwriteatt(fname,'/','GMT version','Fit 5.1');

ncdisp(fname);
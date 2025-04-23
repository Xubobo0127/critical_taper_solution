
function [varargout]=grdread1(filename)
% grdread1: read gmt grid file.
% 
% Similar to grdread.  See help file of grdread for more details.  No 
% netcdf calls are needed here.
%
% Oded Aharonson and Mark Behn.
unix(['grdreformat ',filename,' tmptmp.grd=1']);


fid=fopen('tmptmp.grd','r','native');
nx=fread(fid,1,'long')
ny=fread(fid,1,'long')
node_offset=fread(fid,1,'int');
%pad=fread(fid,1,'double');                 %Line Note needed on Mac OSX
lims=fread(fid,8,'double');
z_scale_factor=fread(fid,1,'double');
z_add_offset=fread(fid,1,'double');
x_units=char(fread(fid,80,'char')');
y_units=char(fread(fid,80,'char')');
z_units=char(fread(fid,80,'char')');
titles=char(fread(fid,80,'char')');
command=char(fread(fid,320,'char')');
remark=char(fread(fid,160,'char')');
z=flipud(fread(fid,[nx,ny],'float')');
fclose(fid);

if node_offset==1,
  x_inc=(lims(2)-lims(1))/nx;
  y_inc=(lims(4)-lims(3))/ny;
  x=linspace(lims(1),lims(2)-x_inc,nx)+x_inc./2;
  y=linspace(lims(3),lims(4)-y_inc,ny)+y_inc./2;
elseif node_offset==0,
  x_inc=(lims(2)-lims(1))/(nx-1);
  y_inc=(lims(4)-lims(3))/(ny-1);
  x=linspace(lims(1),lims(2),nx);
  y=linspace(lims(3),lims(4),ny);
else
  error('grdread1: bad node_offset!');
end

D=[lims(1:6)',node_offset,x_inc,y_inc];

switch nargout
  case 1,double
    varargout{1}=z;  
  case 2,
    varargout{1}=z;  
    varargout{2}=D;  
  case 3,
    varargout{1}=x;
    varargout{2}=y;
    varargout{3}=z;
  case 4,
    varargout{1}=x;
    varargout{2}=y;
    varargout{3}=z;
    varargout{4}=D;  
  otherwise
    error('grdread1: Incorrect # of output arguments!');
end
unix('/bin/rm tmptmp.grd');



end




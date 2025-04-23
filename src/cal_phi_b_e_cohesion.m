  
%=========Calculate the effective friction coefficient of the basement======
%
% This script uses an alternative graphical solution based on Lehner (1986) and
% Bauville et al. (2020) to calculate the effective friction coefficient of the basement.
% Written by Xu Haobo 09/11/2023
% 
% Importdata :          alf.grd         - Grid of surface slope angles (alpha) in degrees
%                       beta.grd        - Grid of basal slope angles (beta) in degrees
%
% Import parameter:     rho_w           = 1000.0  Water density kg/m^3
%                       rho             = 2500.0  Wedge density kg/m^3
%                       phi_int         = 23      Internal friction angle of wedge (degrees)
%                       Lambda          = 0.6;    Internal fluid pressure ratio (dimensionless)  
%                       k               = 0.3     Coefficient of cohesion gradient
%
% Outputdata:           pbef.grd        - Grid of effective friction coefficient of basement
%
% ==============================Importdata==========================
clear all 
deg                 = pi/180.0;                                                   % Degree to radian conversion factor
g                   = 9.8;                                                        % Gravitational acceleration (m/s²)
k                   = 0.3;                                                        % Cohesion gradient coefficient
miueffect           = 0.01;                                                       % Lambda coefficient

[lat1,long1,alf1]   = grdread1('alf.grd');                                        % Alpha grid  
[lat2,long2,beta1]  = grdread1('beta.grd');                                       % Beta  grid  
% Initialize variables
m_obs               = length(lat1);                                                          
lonstart            = 1;
lonend              = length(long1);
P_phi_b_p           = zeros(length(long1),length(lat1));
phbp                = [];
% ========================== Parameter Setup ==========================
% Material properties            
phi_b_p             =[];                                                           % Matrix of basal effective friction coefficient
%  ================================================
rho_w               = 1000.0   ;                                                   % Water density kg/m^3
rho                 = 2500.0   ;                                                   % Wedge density kg/m^3
% ======================== Main Computation Loop ========================          
phi_int             = linspace(23,23,1);                                           % Internal friction angle   
phi_int_length      = length(phi_int);
phi_basal           = linspace(1,23,50);                                           % Base friction angle
phi_basal_length    = length(phi_basal);
lambda_basal        = linspace(50,99,20);
lambda_basal_length = length(lambda_basal);                                        % Basal  fluid pressure
Lambda              = 0.6;                                                         % Internal fluid pressure 
for o               = 1:1:phi_int_length
    phi             = phi_int(o) * deg ;                                   
for p               = 1:1:phi_basal_length
    phi_b           = phi_basal(p) * deg ;        
for q               = 1:1:lambda_basal_length

    Lambda_b        = lambda_basal(q) * miueffect; 
   
%  =============Graphical Solution Implementation (reference Lehner, 1986; Bauville et al., 2020)=========================
hydro = rho_w/rho                              ;                                   % Hydrostatic fluid pressure ratio
wedge_overp = 1.0 - (1.0-Lambda  )/(1.0-hydro);                                    % Internal fluid overpressure raito
base_overp  = 1.0 - (1.0-Lambda_b)/(1.0-hydro);                                    % Basal fluid overpressure ratio

mu          = tan(phi)                               ;                             % Wedge friction coefficient
mu_b        = tan(phi_b)                             ;                             % Base  friction coefficient
phi_b_p     = atan(mu_b.*(1.0-Lambda_b)/(1.0-Lambda));                             % Base effective friction angle

alpha_m     = atan((1.0-base_overp).*mu_b)           ;                             % Left boundary
alpha_max   = atan((1.0-wedge_overp).*mu)               ;                          % Angle of max-repose

% 
%  ================================================
node_seg    = 1000 ;
num_seg     = 4 ;
alpha_all   = zeros(node_seg,num_seg);                                             % Surface angles of all segments
beta_all    = zeros(node_seg,num_seg);                                             % Basal   angles of all segments
alpha_list  = [alpha_m,alpha_max-1e-10,-alpha_m,-alpha_max+1e-10,alpha_m] ;


 % beta = f(alpha)
%================================================

beta        = zeros(node_seg,num_seg);
alpha       = zeros(node_seg,num_seg);
alpha_eff   = zeros(node_seg,num_seg);
psi_0       = zeros(node_seg,num_seg);
 

alpha_aux   = zeros(node_seg,num_seg); 

for i= 1:1:num_seg                                                                 % Loop through the 4 segments

    alpha(:,i)      = linspace(alpha_list(i),alpha_list(i+1),node_seg);            % Surface angle
    for j = 1:1:node_seg 


    alpha_eff(j,i)  = atan( (1-hydro)*sin(alpha(j,i))...
        /((k/rho*g*mu)+(1-Lambda)*cos(alpha(j,i))));                               % Effective surface angle
    alpha_aux(j,i)  = asin(sin(alpha_eff(j,i))/sin(phi))  ;                        % Auxiliary surface  angle


    if (i == 1 || i== 3)
                psi_0(j,i) = 0.5*(-alpha_aux(j,i) - alpha_eff(j,i) + pi) ;      
    else        psi_0(j,i) = 0.5*(+alpha_aux(j,i) - alpha_eff(j,i)) ;           
    end
    
    theta = asin(sin(phi_b_p)*(((k/rho*g*mu)*cos(2*psi_0(j,i))+(1-Lambda)* ...
        csc(mu)*cos(alpha(j,i)))/(k/rho*g*mu+(1-Lambda)*cos(alpha(j,i)))));        % Auxiliary friction angle

    if i<3      psi_b = 0.5*(-theta - phi_b_p + pi) ;                          
    else        psi_b = 0.5*(+theta - phi_b_p) ;                                
    end

    beta(j,i) =  psi_b-psi_0(j,i)-alpha(j,i);
    

    if beta(j,i) < -pi/4.0  
       beta(j,i) = beta(j,i)+pi;

     end
    end
end

    beta_all   = beta;
    alpha_all  = alpha ;

% ========== Observation Point Analysis ==========
        
% According Wang et al., 2006, it is difficult to determine lambda and basal friction angle,separately.
% But we only need to consider miub = (1-Lambda_b)*tan(basal friction angle).                                  %


alf_obs = alf1;                                                                    % Observed alpha
beta_obs = beta1;                                                                  % Observed beta
n_isnan =isnan(beta_obs);               
xq              =beta_obs;                                                         % Observed beta matrix
yq              =alf_obs;                                                          % Observed alpha matrix
xv              =[beta(:,1)/deg                                                    % All graph solutions
                         beta(:,2)/deg
                         beta(:,3)/deg 
                         beta(:,4)/deg];
yv              =[alpha(:,1)/deg                                                   % All graph solutions
                            alpha(:,2)/deg 
                            alpha(:,3)/deg 
                            alpha(:,4)/deg];
 % Check if observed points fall within envelopes     
[in,o]          = inpolygon(xq,yq,xv,yv);                                       
 for kk =1:1:length(lat1)
    for ii =1:1:length(long1)
         if isnan(beta_obs(ii,kk));
             P_phi_b_p(ii,kk) =  NaN;
         else
             if (in(ii,kk) ==1)
   
             phib =phi_basal(p);

             P_phi_b_p(ii,kk) = phib;

             continue
                  end
                  if (in(ii,kk) ==0)
             P_phi_b_p(ii,kk) = NaN;   
                  end 
         end
      
     end
 end
% Store effective friction coefficients, Using Wang and Hu (2006) form
phbp(:,:,q,p) =(1-Lambda_b)*tan(P_phi_b_p*deg); 
    

end
end


end

% ========== Determine Optimal Solution ==========
% Find maximum effective friction coefficient that satisfies constraints

for i =1:1:length(long1)
  for  j = 1:1:length(lat1)
%%%%
ef = phbp(i,j,:,:);                                                                 % Set of basal effective friction coefficient 
ref=reshape(ef,[lambda_basal_length phi_basal_length]);                             % Reshape matrix of basal effective friction coefficient 
% Assume that the critical wedge is in a compressed state,then 
% The fault strength should be maximum, 
% Finding the maximum of (1-Lambda_b)*tan(basal friction angle)

maxef = max(ref,[],2,"omitnan");                                                    % The maximum value in each row                            
maxmaxef = max(maxef,[],"omitnan");                                                 % Find the maximum  value at maxef


if (isnan(maxmaxef)==1)

pb_ef(i,j)= NaN;
end
if (isnan(maxmaxef)==0)
pb_ef(i,j) = maxmaxef;


end
  end
end

%%%%%%  Output reuslts%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
grd_write1(lat1,long1,pb_ef,'pbef.grd');                                            % Effective friction coefficient of basement



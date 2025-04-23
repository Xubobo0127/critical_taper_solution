#   Critical_Taper_solution
The code of Critical Taper Theory (Dahlen et al., 1984; Zhao et al., 1986; Dahlen, 1990; Suppe, 2007) is written in MATLAB to calculate the basal effective friction coefficient and yield stress. Here we use a moving window to calculate the local taper angle. Then these taper angles are used to calculate the basal effective friction coefficient in Critical Taper Theory (Lehner, 1986; Zhao et al., 1986; Bauville et al., 2020).

#   Code support
    The code is developed in MATLAB
    South China Sea Institute of Oceanography, CAS
    Contact me: xuhaobo23@mails.ucas.ac.cn

#   Directory structure description

/src/                        - Contains the source file

    [taper_cal.m]            - Calculate angles of the taper (seafloor or basal fault) 
    [cal_phi_b_e_cohesion.m] - Calculate the basal effective friction coefficient.
    [grd_write1.m]           - Write a grid.
    [grdread1.m]             - Read a grid.

/data/                       - Contains the data file

    [seabed.grd]             - Grid of the seafloor topography
    [dec_depth-r.grd]        - Grid of the plate interface depth
    [basement_depth-r.grd]   - Grid of the top of the oceanic crust
    [basement_depth-r.grd]   - Grid of the top of the oceanic crust
    [alpha.grd]              - Grid of seafloor slope angle
    [beta.grd]               - Grid of plate interface dip
    [pbef.grd]               - Grid of basal effective friction coefficient

README                       - Help file
LICENSE                      - License file

#   Usage
    
    Please have your MATLAB add the path that contains [grd_write1.m] and [grdread1.m].
    Please ensure relevant data is in the same file directory as the script.
    Then run [taper_cal.m] or [cal_phi_b_e_cohesion.m] directly.

#   Parameter description

    Relevant parameters are described in detail in the script.

#   Citation

This work has been submitted for publication in the Journal of Geophysical Research: Solid Earth. The citation should be updated if this work is accepted in JGR: SE or other places.

#   Data source
The plate interface depth and the top of the oceanic crust depth are interpreted from seismic profiles provided by the National Institute of Oceanography of Pakistan. These data were acquired by WesternGeco® in 1998-1999 (Smith et al., 2012; 2014).

The seafloor bathymetry is an integration of newly acquired multi-beam bathymetry and the GEBCO 15 arc-second grid. The multi-beam bathymetry was collected offshore Gwadar by the China-Pakistan joint oceanic expedition in 2017–2018 (Yang et al., 2022; Yu et al., 2024), led by the South China Sea Institute of Oceanology, Chinese Academy of Sciences, with a resolution of approximately 50 m.

#   Reference

Bauville, A., Furuichi, M., & Gerbault, M. (2020). Control of Fault Weakening on the Structural Styles of Underthrusting-Dominated Non-Cohesive Accretionary Wedges. Journal of Geophysical Research-Solid Earth, 125(3).

DAHLEN, F. A. (1984). Noncohesive Critical Coulomb Wedges - an Exact Solution. Journal of Geophysical Research, 89(Nb12), 125-133.
Lehner, F. K. (1986). Comments on “Noncohesive critical Coulomb wedges: An exact solution” by F. A. Dahlen. Journal of Geophysical Research: Solid Earth, 91(B1), 793-796.

Smith, G., McNeill, L., Henstock, T. J., & Bull, J. (2012). The structure and fault activity of the Makran accretionary prism. Journal of Geophysical Research-Solid Earth, 117(B7).

Smith, G. L., McNeill, L. C., Henstock, T. J., Arraiz, D., & Spiess, V. (2014). Fluid generation and distribution in the highest sediment input accretionary margin, the Makran. Earth and Planetary Science Letters, 403, 131-143.

Yu, C., Xu, M., Lin, J., Yang, H., Zhao, X., Zeng, X., He, E., Zhang, F., & Sun, Z. (2024). Atypical crustal structure of the Makran subduction zone and seismotectonic implications. Earth and Planetary Science Letters, 643.

Yang, X., Qiu, Q., Feng, W., Lin, J., Zhang, J., Zhou, Z., & Zhang, F. (2022). Mechanism of the 2017 Mw 6.3 Pasni earthquake and its significance for future major earthquakes in the eastern Makran. Geophysical Journal International, 231(2), 1434-1445.

Zhao, W. L., Davis, D. M., Dahlen, F. A., & Suppe, J. (1986). Origin of Convex Accretionary Wedges - Evidence from Barbados. Journal of Geophysical Research-Solid Earth and Planets, 91(B10), 246-258.

begin

    fileName = "$HOME/WRF/wrfout_d01_2018-03-30_00:00:00.nc"
    data = addfile(fileName,"r")
    wks = gsn_open_wks("pdf", "tempPonto")

    surfaceTemperature = wrf_user_getvar(data, "T2", -1) - 273.15
    rhSurface = wrf_user_getvar(data, "rh2", -1)
    loc  = wrf_user_latlon_to_ij(data, -31.15, -52.45)


    plotY = new((/dimsizes(surfaceTemperature(:,0,0)), 2 /), "float")

    plotY(:,0) = surfaceTemperature(:,loc(0),loc(1))
    plotY(:,1) = rhSurface(:,loc(0),loc(1))

    res = True
    res@gsnMaximize = True
    
    plot = gsn_csm_xy2(wks,ispan(0,24,1), plotY(:,0), plotY(:,1), res,res)

end 
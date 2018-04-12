begin
    
    fileName = "$HOME/WRF/wrfout_d01_2018-03-30_00:00:00.nc"
    data = addfile(fileName,"r")
    wks = gsn_open_wks("pdf", "geop")

    terrain = wrf_user_getvar(data, "ter", 0) * 1.0
    times = wrf_user_getvar(data, "Times", -1)
    lat2D = wrf_user_getvar(data, "XLAT",  0)
    lon2D = wrf_user_getvar(data, "XLONG", 0)
    geop = wrf_user_getvar(data, "geopt", -1)  * 1.0
    wrf_smooth_2d( geop, 3 )            ; smooth geop
    
    geop!0 = "Time"
    geop!2 = "lat"
    geop!3 = "lon"
    geop&lat = lat2D(:,0)
    geop&lon = lon2D(0,:)
    geop@lat2d = lat2D
    geop@lon2d = lon2D
    geop&lat@units = "degrees_north"
    geop&lon@units = "degrees_east"

    terrain!0 = "lat"
    terrain!1 = "lon"
    terrain&lat = lat2D(:,0)
    terrain&lon = lon2D(0,:)
    terrain@lat2d = lat2D
    terrain@lon2d = lon2D
    terrain&lat@units = "degrees_north"
    terrain&lon@units = "degrees_east"

    cfg = True
    cfg@gsnMaximize = True
    cfg@cnFillOn = True
    cfg@gsnFrame = False
    cfg@gsnDraw = False
    cfg@cnLinesOn             = False    ; turn off contour lines
    cfg@cnLineLabelsOn        = False    ; turn off contour line labels
    cfg@cnInfoLabelOn         = False    ; turn off info label
    cfg@mpOutlineBoundarySets = "National"
    cfg@mpDataSetName = "Earth..4"
    cfg@mpDataBaseVersion     = "MediumRes"
    cfg@mpOutlineOn           = True
    cfg@mpGeophysicalLineColor = "black"
    cfg@mpNationalLineColor = "black"
    cfg@mpOutlineSpecifiers   = (/"Brazil:states"/)
    cfg@mpMinLatF   = min(lat2D(:,0))+1
    cfg@mpMinLonF   = min(lon2D(0,:))+1
    cfg@mpMaxLatF   = max(lat2D(:,0))-1
    cfg@mpMaxLonF   = max(lon2D(0,:))-1
    cfg@mpOutlineBoundarySets = "AllBoundaries"
    cfg@mpGeophysicalLineThicknessF = 2
    cfg@mpNationalLineThicknessF = 2

    tRes = cfg
    tRes = wrf_map_resources(data,tRes)    ; Use first file in list for map proj info
    tRes@cnLevelSelectionMode  = "ExplicitLevels"
    tRes@cnLevels              = ispan(1,2200,200)
    tRes@cnFillPalette         = "OceanLakeLandSnow"
    tRes@cnFillOpacityF        = 0.5                 ; make contours partially transparent
    tRes@tiMainString = "Oficina WRF"
    tRes@lbLabelBarOn             = False    ; will add to panel plot

    geoptRes = True
    geoptRes@gsnFrame = False
    geoptRes@gsnDraw = False
    geoptRes@cnFillOn = False
    geoptRes@cnLinesOn = True
    geoptRes@cnLineLabelsOn = True

    do i = 0, 1 ;dimsizes(times(:,0))-1
        ; write loop content
        

        tRes@gsnLeftString = times(i,:)
        plot = gsn_csm_contour_map(wks, terrain, tRes)
        plotVector = gsn_csm_contour(wks, geop(i,5,:,:),geoptRes)
        overlay(plot, plotVector)
        draw(plot)
        frame(wks)

    end do
end
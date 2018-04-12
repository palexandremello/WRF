begin
    
    fileName = "$HOME/WRF/wrfout_d01_2018-03-30_00:00:00.nc"
    data = addfile(fileName,"r")
    wks = gsn_open_wks("pdf", "slp")

    terrain = wrf_user_getvar(data, "ter", 0) * 1.0
    times = wrf_user_getvar(data, "Times", -1)
    lat2D = wrf_user_getvar(data, "XLAT",  0)
    lon2D = wrf_user_getvar(data, "XLONG", 0)
    slp = wrf_user_getvar(data, "slp", -1) * 1.0
    wrf_smooth_2d( slp, 3 )            ; smooth slp
    
    slp!0 = "Time"
    slp!1 = "lat"
    slp!2 = "lon"
    slp&lat = lat2D(:,0)
    slp&lon = lon2D(0,:)
    slp@lat2d = lat2D
    slp@lon2d = lon2D
    slp&lat@units = "degrees_north"
    slp&lon@units = "degrees_east"

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

    ;cfg@mpMinLatF   = min(lat2D(:,0))+1
    ;cfg@mpMinLonF   = min(lon2D(0,:))+1
    ;cfg@mpMaxLatF   = max(lat2D(:,0))-1
    ;cfg@mpMaxLonF   = max(lon2D(0,:))-1
    
    tRes = cfg
    tRes = wrf_map_resources(data,tRes)    ; Use first file in list for map proj info
    tRes@cnLevelSelectionMode  = "ExplicitLevels"
    tRes@cnLevels              = ispan(1,2200,200)
    tRes@cnFillPalette         = "OceanLakeLandSnow"
    tRes@cnFillOpacityF        = 0.5                 ; make contours partially transparent
    tRes@tiMainString = "Oficina WRF"
    tRes@lbLabelBarOn             = False    ; will add to panel plot
    
    
    ;tRes@mpFillDrawOrder      = "PostDraw"

;    tRes@cnFillPalette      = cmap(2:,:)  ; set color map

    slptRes = True
    slptRes@gsnFrame = False
    slptRes@gsnDraw = False
    slptRes@cnFillOn = False
    slptRes@cnLinesOn = True
    slptRes@cnLineLabelsOn = True

    do i = 0, 1 ;dimsizes(times(:,0))-1
        ; write loop content
        

        tRes@gsnLeftString = times(i,:)
        plot = gsn_csm_contour_map(wks, terrain, tRes)
        plotVector = gsn_csm_contour(wks, slp(i,:,:),slptRes)
        overlay(plot, plotVector)
        draw(plot)
        frame(wks)

    end do
end
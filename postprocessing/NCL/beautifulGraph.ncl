begin
    
    fileName = "$HOME/WRF/wrfout_d01_2018-03-30_00:00:00.nc"
    data = addfile(fileName,"r")
    wks = gsn_open_wks("pdf", "bG")

    terrain = wrf_user_getvar(data, "ter", 0) * 1.0
    times = wrf_user_getvar(data, "Times", -1)
    lat2D = wrf_user_getvar(data, "XLAT",  0)
    lon2D = wrf_user_getvar(data, "XLONG", 0)
    u10 = wrf_user_getvar(data, "U10", -1) * 1.0
    v10 = wrf_user_getvar(data, "V10", -1) * 1.0
    
    u10!0 = "Time"
    u10!1 = "lat"
    u10!2 = "lon"
    u10&lat = lat2D(:,0)
    u10&lon = lon2D(0,:)
    u10@lat2d = lat2D
    u10@lon2d = lon2D
    u10&lat@units = "degrees_north"
    u10&lon@units = "degrees_east"

    copy_VarCoords(u10, v10)
    
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
    
    vecres                  = True            ; vector only resources
    vecres@gsnDraw          = False           ; don't draw
    vecres@gsnFrame         = False           ; don't advance frame
    vecres@vcRefMagnitudeF       = 30.0                 ; define vector ref mag
    vecres@vcRefLengthF          = 0.1                ; define length of vec ref
    vecres@vcMinDistanceF        = 0.019                ; thin out vectors
    vecres@vcGlyphStyle          = "CurlyVector"        ; turn on curly vectors
    vecres@gsnRightString   = " "             ; turn off right string
    vecres@gsnLeftString    = " "             ; turn off left string
    vecres@tiXAxisString    = " "             ; turn off axis label 
    vecres@vcRefAnnoOrthogonalPosF = .635    ; move ref vector into plot

    do i = 0, dimsizes(times(:,0))-1
        ; write loop content
        if (i .eq. 0) then
        tRes@gsnLeftString = times(i,:)
        plot = gsn_csm_contour_map(wks, terrain, tRes)
        plotVector = gsn_csm_vector(wks, u10(i,:,:), v10(i,:,:), vecres)
        overlay(plot, plotVector)
        draw(plot)
        frame(wks)
    end if

    end do
end
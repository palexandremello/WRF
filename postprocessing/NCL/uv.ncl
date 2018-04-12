begin
    fileName = "$HOME/WRF/wrfout_d01_2018-03-30_00:00:00.nc"
    data = addfile(fileName,"r")
    
    wks = gsn_open_wks("pdf", "uv")

    u10 = wrf_user_getvar(data, "U10", -1) * 1.0
    v10 = wrf_user_getvar(data, "V10", -1) * 1.0
    times = wrf_user_getvar(data, "Times", -1)
    lat2D = wrf_user_getvar(data, "XLAT",  0)
    lon2D = wrf_user_getvar(data, "XLONG", 0)
    

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
    windMag = sqrt( u10^2.0 + v10^2.0 )
    copy_VarCoords(u10, windMag)


    windMag!0 = "Time"
    windMag!1 = "lat"
    windMag!2 = "lon"
    windMag&lat = lat2D(:,0)
    windMag&lon = lon2D(0,:)
    windMag@lat2d = lat2D
    windMag@lon2d = lon2D
    windMag&lat@units = "degrees_north"
    windMag&lon@units = "degrees_east"

    cfg = True
    
    cfg@gsnMaximize = True
    cfg@mpOutlineBoundarySets = "National"
    cfg@mpDataSetName = "Earth..4"
    cfg@mpDataBaseVersion     = "MediumRes"
    cfg@mpOutlineOn           = True
    cfg@mpOutlineSpecifiers   = (/"Brazil:states"/)
    cfg@mpMinLatF   = min(lat2D(:,0))+1
    cfg@mpMinLonF   = min(lon2D(0,:))+1
    cfg@mpMaxLatF   = max(lat2D(:,0))-1
    cfg@mpMaxLonF   = max(lon2D(0,:))-1
    
     
    option = cfg
    
  option@cnFillOn = True

  option@cnLinesOn = False
  option@tiMainString = "Oficina WRF"
  res = option  
  res@gsnAddCyclic             = False            ; regional data 
  res@vcRefMagnitudeF          = 10.0             ; define vector ref mag
  res@vcRefLengthF             = 0.045            ; define length of vec ref
  res@vcGlyphStyle             = "CurlyVector"    ; turn on curly vectors
  res@vcMinDistanceF           = 0.017            ; thin vectors
  res@vcRefAnnoOrthogonalPosF  = .1               ; move ref vector down

  res@gsnScalarContour        = True
  res@mpLandFillColor = "transparent"

    do i = 0, dimsizes(windMag(:,0,0))-1

        if ( i .eq. 0 ) then
          plot = gsn_csm_vector_scalar_map(wks,u10(i,:,:) \
                                           ,v10(i,:,:) \ 
                                           ,windMag(i,:,:),res)
        end if 
    end do
end
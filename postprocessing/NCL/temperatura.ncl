begin

    fileName = "$HOME/WRF/wrfout_d01_2018-03-30_00:00:00.nc"
    data = addfile(fileName,"r")

    surfaceTemperature = wrf_user_getvar(data, "T2", -1) - 273.15
    cloudTopCloud = wrf_user_getvar(data, "ctt", -1) * 1.0
    times = wrf_user_getvar(data, "Times", -1)
    lat2D = wrf_user_getvar(data, "XLAT",  0)
    lon2D = wrf_user_getvar(data, "XLONG", 0)


    surfaceTemperature!0 = "Time"
    surfaceTemperature!1 = "lat"
    surfaceTemperature!2 = "lon"
    surfaceTemperature&lat = lat2D(:,0)
    surfaceTemperature&lon = lon2D(0,:)
    surfaceTemperature@lat2d = lat2D
    surfaceTemperature@lon2d = lon2D
    cloudTopCloud!0 = "Time"
    cloudTopCloud!1 = "lat"
    cloudTopCloud!2 = "lon"
    cloudTopCloud&lat = lat2D(:,0)
    cloudTopCloud&lon = lon2D(0,:)
    cloudTopCloud@lat2d = lat2D
    cloudTopCloud@lon2d = lon2D

    wks = gsn_open_wks("pdf","teste")

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
    
    cloudOption = option


                    do i = 0, dimsizes(times(:,0))-1
                        
                        
                        if (times(i,:) .eq. "2018-03-30_21:00:48") then
                            option@gsnLeftString = times(i,:)
                            option@gsnRightString = "Temperatura 2M"
                            print("Plotando = "+times(i,:))
                            cmap := read_colormap_file("BlueYellowRed")
                            option@cnFillPalette = cmap
                            plot = gsn_csm_contour_map(wks, surfaceTemperature(i,:,:),option)
                            
                            cloudOption@gsnRightString = "CCT(sat C13(10.3um))"
                            cloudOption@gsnLeftString  = times(i,:)
                            cloudMap := read_colormap_file("MPL_YlGn")
                            cloudOption@cnFillPalette = cloudMap
                            plot = gsn_csm_contour_map(wks, cloudTopCloud(i,:,:),cloudOption)


                        else
                            print("Time = "+ times(i,:)+" Não Será plotado")
                            
                        end if
                        
                    end do

end
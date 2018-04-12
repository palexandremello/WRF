begin

    fileName = "$HOME/WRF/wrfout_d01_2018-03-30_00:00:00.nc"
    data = addfile(fileName,"r")
    wks = gsn_open_wks("pdf", "rain")

    times = wrf_user_getvar(data, "Times", -1)
    ntimes = dimsizes(times(:,0))
    lat2D = wrf_user_getvar(data, "XLAT",  0)
    lon2D = wrf_user_getvar(data, "XLONG", 0)

    rain_exp = wrf_user_getvar(data,"RAINNC",-1)
    rain_con = wrf_user_getvar(data,"RAINC",-1)
    rain_tot = rain_exp + rain_con
    rain_tot@description = "Total precipitado"


    inst = new( (/dimsizes(rain_tot(:,0,0)), dimsizes(rain_tot(0,:,0)),dimsizes(rain_tot(0,0,:)) /),"float")

    acum24 = new( (/dimsizes(rain_tot(:,0,0))/24, dimsizes(rain_tot(0,:,0)),dimsizes(rain_tot(0,0,:)) /),"float")

    acum12 = new( (/dimsizes(rain_tot(:,0,0))/12, dimsizes(rain_tot(0,:,0)),dimsizes(rain_tot(0,0,:)) /),"float")

    acum06 = new( (/dimsizes(rain_tot(:,0,0))/06, dimsizes(rain_tot(0,:,0)),dimsizes(rain_tot(0,0,:)) /),"float")

    acum24 = 0
    acum12 = 0
    acum06 = 0
    j=0

    ; Chuva sem peso acumulativo 
    do i = 0,dimsizes(inst(:,0,0))-1  ; do -> 1 até NTEMPO       
        
        if (i .gt. 0) then

                
                inst(j,:,:) = rain_tot(i,:,:) - rain_tot(i-1,:,:) 
                j=j+1           
            else
                
                inst(j,:,:) = rain_tot(i,:,:)
                j=j+1


            end if

    
    end do


    j=0
    do i = 0,dimsizes(inst(:,0,0))-1,24  ; do -> 1 até NTEMPO       


        if (i .ge. 0) then

                print("acumulado 24h = "+times(i,:)+" "+times(i+24,:))
                
                acum24(j,:,:) = dim_sum_n(inst(i:dimsizes( times(:,0) )-1,:,:),0) 
                break
    
  
        end if

    
    end do


    do i = 3,ntimes-1,12


        if ( i .eq. 15 )
                
                print("acumulados 12h= "+times(i,:)+" "+times(ntimes-1,:))
                acum12(j,:,:) = dim_sum_n(inst(15:ntimes-1,:,:),0)

                break
        else
                print("acumulados 12h= "+times(i,:)+" "+times(i+11,:))
                acum12(j,:,:) = dim_sum_n(inst(i:i+11,:,:),0)             
                j=j+1      
                
        end if

    end do

        j=0
 
        do i = 3,ntimes-1,6

        
        if ( i .eq. 21 )
                
                print("acumulados 6h= "+times(i,:)+" "+times(ntimes-1,:))
                acum06(j,:,:) = dim_sum_n(inst(21:ntimes-1,:,:),0)

                break
        else
                print("acumulados 6h= "+times(i,:)+" "+times(i+5,:))
                acum06(j,:,:) = dim_sum_n(inst(i:i+5,:,:),0)
                j=j+1      
                
        end if

    end do





acum24!0 = "time"
acum24!2 = "lon"
acum24!1 = "lat"
acum24&lon = lon2D(0,:)
acum24&lat = lat2D(:,0)
acum24@lat2d = lat2D
acum24@lon2d = lon2D
acum24&lat@units = "degrees_north"
acum24&lon@units = "degrees_east"


acum12!0 = "time"
acum12!2 = "lon"
acum12!1 = "lat"
acum12&lon = lon2D(0,:)
acum12&lat = lat2D(:,0)
acum12@lat2d = lat2D
acum12@lon2d = lon2D
acum12&lat@units = "degrees_north"
acum24&lon@units = "degrees_east"


acum06!0 = "time"
acum06!2 = "lon"
acum06!1 = "lat"
acum06&lon = lon2D(0,:)
acum06&lat = lat2D(:,0)
acum06@lat2d = lat2D
acum06@lon2d = lon2D
acum06&lat@units = "degrees_north"
acum06&lon@units = "degrees_east"



print("Maximo 24h = "+max(acum24)+" mm")
print("Maximo 12h = "+max(acum12)+" mm")
print("Maximo 06h = "+max(acum06)+" mm")



 
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
  cmap     := read_colormap_file("BlAqGrYeOrReVi200")
  cmap(0,:) = (/0,0,0,0/)    ; make first color fully transparent
  cfg@cnFillOn             = True
  cfg@cnFillPalette        = cmap
  cfg@cnLineLabelsOn       = False            ; turn off contour labels
  cfg@cnFillOpacityF = 1. ; .85 
  
    cfgion = cfg
    
    cfgion@cnFillOn = True
    cfgion@cnLinesOn = False
    cfgion@tiMainString = "Oficina WRF"
    

    ;plot = gsn_csm_contour_map(wks, acum24(0,:,:), cfgion)


    do i = 0, dimsizes(acum06(:,0,0))-1

        cfgion@cnLevelSelectionMode = "ManualLevels"
        cfgion@cnMaxLevelValF       = 75
        cfgion@cnMinLevelValF       =  1
        cfgion@cnLevelSpacingF = 10
        
        plot = gsn_csm_contour_map(wks, acum06(i,:,:), cfgion)

    end do
end
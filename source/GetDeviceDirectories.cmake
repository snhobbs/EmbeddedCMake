function(GetDeviceDirectories DEVICE cortex_libs EmbeddedCMake)
  message(${DEVICE} " " ${CORTEX_LIBS} " " ${EmbeddedCMake})
  if (${DEVICE} STREQUAL "LPC84x")
    set(DEVICE_DIRECTORY ${cortex_libs}/Devices/LPC845)
    set(VendorCodeBaseDirectory ${DEVICE_DIRECTORY}/VendorSdks/SDK_2.7.0_LPC845)
    set(DeviceCmake ${EmbeddedCMake}/devices/lpc845/LPC845.cmake)
    include(${DeviceCmake})
  elseif (${DEVICE} STREQUAL "LPC84xTEST")
    set(DEVICE_DIRECTORY ${CMAKE_SOURCE_DIR}/Devices/TestDevice)
  elseif (${DEVICE} STREQUAL "LPC80x")
  elseif (${DEVICE} STREQUAL "LPC80xTEST")
  elseif (${DEVICE} STREQUAL "LPC175x_6x")
  elseif (${DEVICE} STREQUAL "LPC175x_6xTEST")
  else()
    message(SEND_ERROR "No device set")
  endif()

  GetVendorDirectories("${VendorCodeBaseDirectory}")# Sets VendorDirectories
  GetVendorSources("${VendorCodeBaseDirectory}") # Sets VendorSources
endfunction()

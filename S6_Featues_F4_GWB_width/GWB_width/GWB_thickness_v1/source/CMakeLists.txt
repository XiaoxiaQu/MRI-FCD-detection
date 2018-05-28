

cmake_minimum_required( VERSION 2.8 )
project(GWB_thickness_v1)

find_package (ITK)
if (ITK_FOUND)
  include ( ${ITK_USE_FILE} )
else (ITK_FOUND)
  message (FATAL_ERROR "Cannot build without ITK, Please set ITK_DIR.")
endif (ITK_FOUND)

add_executable(thickness_calculation thickness_calculation.cxx )

target_link_libraries(thickness_calculation
  ${ITK_LIBRARIES}
 
 )



cmake_minimum_required( VERSION 2.8 )
project(GWB_Potential_Map)

find_package (ITK)
if (ITK_FOUND)
  include ( ${ITK_USE_FILE} )
else (ITK_FOUND)
  message (FATAL_ERROR "Cannot build without ITK, Please set ITK_DIR.")
endif (ITK_FOUND)

add_executable(GWB_Potential_Map   GWB_Potential_Map.cxx )

target_link_libraries(GWB_Potential_Map
  ${ITK_LIBRARIES}
 
 )

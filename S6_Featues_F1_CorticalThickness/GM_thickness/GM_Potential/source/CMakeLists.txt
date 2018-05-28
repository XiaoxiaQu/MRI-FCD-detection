

cmake_minimum_required( VERSION 2.8 )
project(GM_Potential)

find_package (ITK)
if (ITK_FOUND)
  include ( ${ITK_USE_FILE} )
else (ITK_FOUND)
  message (FATAL_ERROR "Cannot build without ITK, Please set ITK_DIR.")
endif (ITK_FOUND)

add_executable(GM_Potential   GM_Potential.cxx )

target_link_libraries(GM_Potential
  ${ITK_LIBRARIES}
 
 )

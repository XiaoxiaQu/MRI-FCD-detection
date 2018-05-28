cmake_minimum_required( VERSION 2.8 )
project(source)

find_package (ITK)
if (ITK_FOUND)
  include ( ${ITK_USE_FILE} )
else (ITK_FOUND)
  message (FATAL_ERROR "Cannot build without ITK, Please set ITK_DIR.")
endif (ITK_FOUND)

add_executable(z_score z_score.cxx )

target_link_libraries(z_score
  ${ITK_LIBRARIES}
 
 )

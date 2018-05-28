cmake_minimum_required( VERSION 2.8 )
project(Relative_intensity_map)
include_regular_expression("^.*$")

find_package (ITK)
if (ITK_FOUND)
  include ( ${ITK_USE_FILE} )
else (ITK_FOUND)
  message (FATAL_ERROR "Cannot build without ITK, Please set ITK_DIR.")
endif (ITK_FOUND)

add_executable(Relative_intensity_map Relative_intensity_map.cxx )
target_link_libraries(Relative_intensity_map ${ITK_LIBRARIES})



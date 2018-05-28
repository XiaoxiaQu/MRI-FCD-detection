cmake_minimum_required( VERSION 2.8 )
project(GWB_extract)
include_regular_expression("^.*$")

find_package (ITK)
if (ITK_FOUND)
  include ( ${ITK_USE_FILE} )
else (ITK_FOUND)
  message (FATAL_ERROR "Cannot build without ITK, Please set ITK_DIR.")
endif (ITK_FOUND)

add_executable(GWB_extract GWB_extract.cxx )
target_link_libraries(GWB_extract ${ITK_LIBRARIES})



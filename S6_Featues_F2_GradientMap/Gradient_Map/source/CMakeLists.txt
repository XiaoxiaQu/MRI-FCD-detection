cmake_minimum_required( VERSION 2.8 )
project(source)
include_regular_expression("^.*$")

find_package (ITK)
if (ITK_FOUND)
  include ( ${ITK_USE_FILE} )
else (ITK_FOUND)
  message (FATAL_ERROR "Cannot build without ITK, Please set ITK_DIR.")
endif (ITK_FOUND)

add_executable(Gradient_Map  Gradient_Map.cxx )
target_link_libraries(Gradient_Map ${ITK_LIBRARIES})



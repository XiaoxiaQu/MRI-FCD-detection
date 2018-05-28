

cmake_minimum_required( VERSION 2.8 )

#-------------------------------
SET(ITK_DIR "/home/xiaoxiaqu/My_Tools/ITK_VTK_cmake/InsightToolkit-4.4.1-bin" CACHE PATH "ITK directory override" FORCE)
#---------------------------------

project(Generate_Samples)

find_package (ITK)
if (ITK_FOUND)
  include ( ${ITK_USE_FILE} )
else (ITK_FOUND)
  message (FATAL_ERROR "Cannot build without ITK, Please set ITK_DIR.")
endif (ITK_FOUND)

add_executable(Generate_Samples  Generate_Samples.cxx )

target_link_libraries(Generate_Samples
  ${ITK_LIBRARIES}
 
 )

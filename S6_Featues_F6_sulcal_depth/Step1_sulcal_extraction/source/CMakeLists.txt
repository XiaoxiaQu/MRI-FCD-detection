cmake_minimum_required(VERSION 2.8.5 FATAL_ERROR)
if(POLICY CMP0025)
  cmake_policy(SET CMP0025 NEW) # CMake 3.0
endif()
if(POLICY CMP0053)
  cmake_policy(SET CMP0053 NEW) # CMake 3.1
endif()
#-------------------------------
SET(ITK_DIR "/media/xiaqu/HardDisk/scratch/MRI_tools_Install/InsightToolkit-4.7.1-bin" CACHE PATH "ITK directory override" FORCE)
#---------------------------------
project(source)
include_regular_expression("^.*$")

find_package (ITK)
if (ITK_FOUND)
  include ( ${ITK_USE_FILE} )
else (ITK_FOUND)
  message (FATAL_ERROR "Cannot build without ITK, Please set ITK_DIR.")
endif (ITK_FOUND)

add_executable(${PROJECT_NAME} 
               sulcal_extraction.cxx )
target_link_libraries(${PROJECT_NAME} 
                     ${ITK_LIBRARIES})



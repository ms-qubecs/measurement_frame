cmake_minimum_required(VERSION 3.16)
project(measurement_proj C CXX)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

# ========== Shared options ==========
add_compile_options($<$<COMPILE_LANGUAGE:C>:-Wall>)
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
endif()
add_compile_options($<$<AND:$<COMPILE_LANGUAGE:C>,$<CONFIG:Release,RelWithDebInfo>>:-O3>)

# ========== Core ==========
add_library(core_obj OBJECT
  sources/raw_socket.c
  sources/ethernet_util.c
  sources/measurement_frame_format.c
)
target_include_directories(core_obj PUBLIC ${CMAKE_SOURCE_DIR}/sources)

# ========== Targets ==========
add_executable(ethernet_receiver
  sources/ethernet_receiver.c
  $<TARGET_OBJECTS:core_obj>
)
target_include_directories(ethernet_receiver PRIVATE ${CMAKE_SOURCE_DIR}/sources)

add_executable(ethernet_sender
  sources/ethernet_sender.c
  $<TARGET_OBJECTS:core_obj>
)
target_include_directories(ethernet_sender PRIVATE ${CMAKE_SOURCE_DIR}/sources)

add_executable(measurement_frame_sender
  sources/measurement_frame_sender.c
  $<TARGET_OBJECTS:core_obj>
)
target_include_directories(measurement_frame_sender PRIVATE ${CMAKE_SOURCE_DIR}/sources)

# ========== Tests ==========
include(FetchContent)
FetchContent_Declare(
  googletest
  URL https://github.com/google/googletest/archive/refs/tags/v1.15.2.zip
)
FetchContent_MakeAvailable(googletest)

enable_testing()

add_executable(test_measurement
  tests/test_measurement_frame_format.cc
  $<TARGET_OBJECTS:core_obj>
)
target_include_directories(test_measurement PRIVATE ${CMAKE_SOURCE_DIR}/sources)
target_link_libraries(test_measurement GTest::gtest GTest::gtest_main)
add_test(NAME measurement_test COMMAND test_measurement)


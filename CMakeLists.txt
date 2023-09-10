cmake_minimum_required(VERSION 3.10)

project(aurutilsinstaller)

set(CMAKE_C_STANDARD 11)

file(GLOB_RECURSE SRC_FILES "src/*.c")

add_library(mylib STATIC ${SRC_FILES})

add_executable(setup ${SRC_FILES})
target_include_directories(setup PRIVATE src/include)

target_link_libraries(setup PRIVATE mylib)

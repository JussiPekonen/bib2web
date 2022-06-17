cmake_minimum_required(VERSION 3.17.0)
project(bib2web)

include(cmake/versioning-tools.cmake)
include(cmake/shell-tools.cmake)

add_custom_target(test)
add_custom_target(lint)

add_subdirectory(bash)

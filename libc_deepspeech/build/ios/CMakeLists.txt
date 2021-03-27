cmake_minimum_required(VERSION 3.4.1)

# Library source files.
FILE(GLOB SRC ../../*.c)

add_library(deepspeechlibc STATIC ${SRC})
include_directories(../../)

# Find DeepSpeech 0.9.3 framework
find_library(DEEPSPEECH_LIB NAMES deepspeech_ios HINTS "../../../libdeepspeech_0.9.3")

# Link our library with DeepSpeech 0.9.3 framework
target_link_libraries(deepspeechlibc ${DEEPSPEECH_LIB})

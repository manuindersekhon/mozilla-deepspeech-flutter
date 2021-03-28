# cmake -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake -G Ninja -DANDROID_NDK=$ANDROID_NDK -DANDROID_ABI=arm64-v8a -DANDROID_PLATFORM=android-29 -Sandroid -Bbin/android/arm64-v8a
# cmake --build bin/android/arm64-v8a

# cmake -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake -G Ninja -DANDROID_NDK=$ANDROID_NDK -DANDROID_ABI=armeabi-v7a -DANDROID_PLATFORM=android-29 -Sandroid -Bbin/android/armeabi-v7a
# cmake --build bin/android/armeabi-v7a

cmake_minimum_required(VERSION 3.4.1)

# Library source files.
FILE(GLOB SRC ../../*.cpp)

# Add our own library, we will call it libcdeepspeech
add_library(deepspeechlibc SHARED ${SRC})
include_directories(../../)

# Include DeepSpeech 0.9.3
add_library(libdeepspeech SHARED IMPORTED)

# Get absolute path for desired architecture
get_filename_component(ABI_LIB_PATH ../../../libdeepspeech_0.9.3/android/${ANDROID_ABI}/libdeepspeech.so ABSOLUTE)

set_target_properties( libdeepspeech PROPERTIES IMPORTED_LOCATION ${ABI_LIB_PATH} )
include_directories( ../../../libdeepspeech_0.9.3/ )

# Link our library with deepspeech 0.9.3 library
target_link_libraries( deepspeechlibc libdeepspeech )

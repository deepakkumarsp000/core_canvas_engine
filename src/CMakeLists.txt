# FILE: src/CMakeLists.txt
# PURPOSE: Modular Build System with LTO, Dead-Code Stripping & Feature Toggles
cmake_minimum_required(VERSION 3.12)
project(core_canvas_engine)

# ============================================================================
# STEP 1: C++20 STANDARD & FEATURE TOGGLES
# Default ON for Zero-Config builds; Gradle/platform scripts pass OFF to strip.
# ============================================================================
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

option(ENABLE_PDF          "Enable PDF Exporter (pdfgen)"                    ON)
option(ENABLE_SVG          "Enable NanoSVG Vector Engine"                    ON)
option(ENABLE_SHADOWS      "Enable Drop Shadow & Mirror Reflection Engine"   ON)
option(ENABLE_IMAGE_EXPORT "Enable PNG/JPG/WebP Framebuffer Exporter"        ON)
option(ENABLE_WEBP         "Enable LibWebP Decoder & Encoder"                ON)
option(ENABLE_LOTTIE       "Enable RLottie Vector Animations"                ON)
option(ENABLE_GIF          "Enable Animated GIF & Tweeny Easing Engine"      ON)
option(ENABLE_HTML         "Enable HTML5/CSS3 DOM Exporter"                  ON)

# Smart Dependency Resolution: Animated GIF requires ImageCanvas to render frames
if(ENABLE_GIF AND NOT ENABLE_IMAGE_EXPORT)
    set(ENABLE_IMAGE_EXPORT ON CACHE BOOL "Auto-enabled by ENABLE_GIF" FORCE)
endif()

# ============================================================================
# STEP 2: COMPILER & LINKER SIZE OPTIMIZATION (-Oz + LTO + GC-Sections)
# ============================================================================
if(MSVC)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /O1 /Gy /Gw")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /O1 /Gy /Gw")
else()
    set(SIZE_OPT_FLAGS "-Oz -flto -ffunction-sections -fdata-sections -fvisibility=hidden")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${SIZE_OPT_FLAGS} -fvisibility-inlines-hidden -Wno-deprecated-volatile -Wno-#pragma-messages")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${SIZE_OPT_FLAGS}")

    if(APPLE)
        set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -flto -Wl,-dead_strip -Wl,-x")
    else()
        set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -flto -Wl,--gc-sections -Wl,--strip-all -Wl,--exclude-libs,ALL")
    endif()
endif()

# ============================================================================
# STEP 3: SMART CONDITIONAL SOURCE COLLECTION
# ============================================================================
# 1. Core Engine Sources (src/*.cpp, *.c)
file(GLOB_RECURSE ENGINE_SOURCES CONFIGURE_DEPENDS
        "${CMAKE_CURRENT_SOURCE_DIR}/*.cpp"
        "${CMAKE_CURRENT_SOURCE_DIR}/*.c"
        "${CMAKE_CURRENT_SOURCE_DIR}/*.cc"
)

# 2. Third-party root files (yyjson.c, pdfgen.c)
file(GLOB THIRD_PARTY_ROOT_SOURCES CONFIGURE_DEPENDS
        "${CMAKE_CURRENT_SOURCE_DIR}/../third_party/*.c"
        "${CMAKE_CURRENT_SOURCE_DIR}/../third_party/*.cpp"
)
if(NOT ENABLE_PDF)
    list(FILTER THIRD_PARTY_ROOT_SOURCES EXCLUDE REGEX ".*pdfgen\\.c$")
endif()

# 3. Meta Yoga Flexbox Layout Engine (Always active)
file(GLOB_RECURSE YOGA_SOURCES CONFIGURE_DEPENDS
        "${CMAKE_CURRENT_SOURCE_DIR}/../third_party/yoga/*.cpp"
        "${CMAKE_CURRENT_SOURCE_DIR}/../third_party/yoga/*.c"
)

list(APPEND ALL_SOURCES ${ENGINE_SOURCES} ${THIRD_PARTY_ROOT_SOURCES} ${YOGA_SOURCES})

# 4. Conditional LibWebP Sources (Saves ~600 KB when OFF)
if(ENABLE_WEBP)
    file(GLOB_RECURSE WEBP_SOURCES CONFIGURE_DEPENDS
            "${CMAKE_CURRENT_SOURCE_DIR}/../third_party/libwebp/*.c"
    )
    list(APPEND ALL_SOURCES ${WEBP_SOURCES})
endif()

# 5. Conditional RLottie Sources (Saves ~1.5 MB when OFF)
if(ENABLE_LOTTIE)
    file(GLOB_RECURSE RLOTTIE_SOURCES CONFIGURE_DEPENDS
            "${CMAKE_CURRENT_SOURCE_DIR}/../third_party/rlottie/src/lottie/*.cpp"
            "${CMAKE_CURRENT_SOURCE_DIR}/../third_party/rlottie/src/vector/*.cpp"
            "${CMAKE_CURRENT_SOURCE_DIR}/../third_party/rlottie/src/binding/c/*.cpp"
    )
    list(FILTER RLOTTIE_SOURCES EXCLUDE REGEX ".*stb_image\\.cpp$")
    list(APPEND ALL_SOURCES ${RLOTTIE_SOURCES})
endif()

# ============================================================================
# STEP 4: CREATE SHARED LIBRARY & BIND FEATURE MACROS
# ============================================================================
add_library(${PROJECT_NAME} SHARED ${ALL_SOURCES})

if(ENABLE_PDF)
    target_compile_definitions(${PROJECT_NAME} PRIVATE CANVAS_ENABLE_PDF=1)
endif()
if(ENABLE_SVG)
    target_compile_definitions(${PROJECT_NAME} PRIVATE CANVAS_ENABLE_SVG=1)
endif()
if(ENABLE_SHADOWS)
    target_compile_definitions(${PROJECT_NAME} PRIVATE CANVAS_ENABLE_SHADOWS=1)
endif()
if(ENABLE_IMAGE_EXPORT)
    target_compile_definitions(${PROJECT_NAME} PRIVATE CANVAS_ENABLE_IMAGE_EXPORT=1)
endif()
if(ENABLE_WEBP)
    target_compile_definitions(${PROJECT_NAME} PRIVATE CANVAS_ENABLE_WEBP=1)
endif()
if(ENABLE_LOTTIE)
    target_compile_definitions(${PROJECT_NAME} PRIVATE CANVAS_ENABLE_LOTTIE=1)
endif()
if(ENABLE_GIF)
    target_compile_definitions(${PROJECT_NAME} PRIVATE CANVAS_ENABLE_GIF=1)
endif()
if(ENABLE_HTML)
    target_compile_definitions(${PROJECT_NAME} PRIVATE CANVAS_ENABLE_HTML=1)
endif()

# ============================================================================
# STEP 5: INCLUDE DIRECTORIES
# ============================================================================
target_include_directories(${PROJECT_NAME} PRIVATE
        "${CMAKE_CURRENT_SOURCE_DIR}"
        "${CMAKE_CURRENT_SOURCE_DIR}/../third_party"
        "${CMAKE_CURRENT_SOURCE_DIR}/../third_party/yoga"
        "${CMAKE_CURRENT_SOURCE_DIR}/../third_party/libwebp"
        "${CMAKE_CURRENT_SOURCE_DIR}/../third_party/libwebp/src"
        "${CMAKE_CURRENT_SOURCE_DIR}/../third_party/tweeny"
        "${CMAKE_CURRENT_SOURCE_DIR}/../third_party/tweeny/include"
        "${CMAKE_CURRENT_SOURCE_DIR}/../third_party/rlottie"
        "${CMAKE_CURRENT_SOURCE_DIR}/../third_party/rlottie/inc"
        "${CMAKE_CURRENT_SOURCE_DIR}/../third_party/rlottie/src"
        "${CMAKE_CURRENT_SOURCE_DIR}/../third_party/rlottie/src/vector"
        "${CMAKE_CURRENT_SOURCE_DIR}/../third_party/rlottie/src/vector/freetype"
        "${CMAKE_CURRENT_SOURCE_DIR}/../third_party/rlottie/src/vector/pixman"
        "${CMAKE_CURRENT_SOURCE_DIR}/../third_party/rlottie/src/vector/stb"
        "${CMAKE_CURRENT_SOURCE_DIR}/../third_party/rlottie/src/lottie"
        "${CMAKE_CURRENT_SOURCE_DIR}/../third_party/rlottie/src/lottie/zip"
        "${CMAKE_CURRENT_SOURCE_DIR}/../third_party/rlottie/src/binding/c"
)

# ============================================================================
# STEP 6: OS SPECIFIC FIXES & NATIVE LIBS
# ============================================================================
if(WIN32)
    target_compile_definitions(${PROJECT_NAME} PRIVATE _WINDOWS)
elseif(APPLE)
    set_target_properties(${PROJECT_NAME} PROPERTIES FRAMEWORK TRUE)
endif()

if(ANDROID)
    find_library(log-lib log)
    target_link_libraries(${PROJECT_NAME} ${log-lib})
endif()
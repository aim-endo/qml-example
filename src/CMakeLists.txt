add_executable(${PROJECT_NAME})

target_sources(${PROJECT_NAME} PRIVATE
    main.cpp
)

target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_23)

target_compile_options(${PROJECT_NAME} PRIVATE
    -Wall -Wextra -pedantic -Werror
    $<$<CONFIG:Debug>:-O0 -g>
    $<$<CONFIG:Release>:-O3>
)

find_package(Qt6 REQUIRED)

add_dependencies(${PROJECT_NAME} Qt6::Core Qt6::Gui Qt6::Quick)

target_include_directories(${PROJECT_NAME}
    SYSTEM BEFORE PRIVATE ${QT6_INCLUDE_DIRS}
)

target_link_directories(${PROJECT_NAME}
    PRIVATE ${QT6_LIBRARY_DIR}
)

target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Quick
    Qt6::Qml
)

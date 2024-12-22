include(ExternalProject)

set(QT_INSTALL_DIR "${CMAKE_SOURCE_DIR}/lib/qt")

ExternalProject_Add(qtbase
    GIT_REPOSITORY https://github.com/qt/qtbase.git
    GIT_TAG 6.8.1
    PREFIX ${CMAKE_BINARY_DIR}/qtbase
    CONFIGURE_COMMAND
        <SOURCE_DIR>/configure -prefix ${QT_INSTALL_DIR} -release -opensource -confirm-license -sbom -nomake examples -nomake tests -no-pch -no-opengl -no-openssl -no-widgets -no-unity-build -no-feature-androiddeployqt -no-feature-macdeployqt -no-feature-windeployqt -no-feature-network -no-feature-printsupport -no-feature-sql -no-feature-testlib -no-feature-xml -no-feature-appstore-compliant
    BUILD_COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR> --parallel
    INSTALL_COMMAND ${CMAKE_COMMAND} --install <BINARY_DIR>
    BUILD_BYPRODUCTS ${QT_INSTALL_DIR}/lib/cmake/Qt6/Qt6Config.cmake
    UPDATE_DISCONNECTED TRUE
    BUILD_ALWAYS FALSE
)

ExternalProject_Add(qtdeclarative
    GIT_REPOSITORY https://github.com/qt/qtdeclarative.git
    GIT_TAG 6.8.1
    PREFIX ${CMAKE_BINARY_DIR}/qtdeclarative
    DEPENDS qtbase
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=$<CONFIG>
        -DCMAKE_PREFIX_PATH=${QT_INSTALL_DIR}
        -DCMAKE_INSTALL_PREFIX=${QT_INSTALL_DIR}
    BUILD_COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR> --parallel
    INSTALL_COMMAND cmake --install <BINARY_DIR>
    UPDATE_DISCONNECTED TRUE
    BUILD_ALWAYS FALSE
)

set(CMAKE_PREFIX_PATH "${QT_INSTALL_DIR}" CACHE PATH "Path to Qt6 installation" FORCE)
set(Qt6_DIR ${QT_INSTALL_DIR}/lib/cmake/Qt6)
set(QT6_INCLUDE_DIR ${QT_INSTALL_DIR}/include)
set(QT6_LIBRARY_DIR} ${QT_INSTALL_DIR}/lib)

add_library(Qt6::Core INTERFACE IMPORTED)
set_target_properties(Qt6::Core PROPERTIES
    IMPORTED_LOCATION "${QT_INSTALL_DIR}/lib/libQt6Core.so"
)

add_library(Qt6::Gui INTERFACE IMPORTED)
set_target_properties(Qt6::Gui PROPERTIES
    IMPORTED_LOCATION "${QT_INSTALL_DIR}/lib/libQt6Gui.so"
)

add_library(Qt6::Quick INTERFACE IMPORTED)
set_target_properties(Qt6::Quick PROPERTIES
    IMPORTED_LOCATION "${QT_INSTALL_DIR}/lib/libQt6Quick.so"
)

add_dependencies(Qt6::Core qtbase)
add_dependencies(Qt6::Gui qtbase)
add_dependencies(Qt6::Quick qtdeclarative)

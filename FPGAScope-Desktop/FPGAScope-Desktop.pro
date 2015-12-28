#-------------------------------------------------
#
# Project created by QtCreator 2015-11-09T14:52:41
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = FPGAScope-Desktop
TEMPLATE = app

CONFIG += c++14 \
    static \
    staticlib \
    qwt

QMAKE_CXXFLAGS += -std=c++14

QMAKE_LFLAGS += -static-libstdc++ \
    -static-libgcc
    #-Bstatic \
    #-static

SOURCES +=\
    frontpanel.cxx \
    main.cpp \
    model/uartreceiver.cxx \
    utils/uartviewer.cxx \
    utils/uartcontroller.cxx \
    model/coreunit.cxx \
    controller/controller.cxx \
    model/cyclicbuffer.cxx

HEADERS  += frontpanel.hpp \
    model/uartreceiver.hpp \
    utils/uartviewer.hpp \
    utils/uartcontroller.hpp \
    model/coreunit.hpp \
    controller/controller.hpp \
    model/cyclicbuffer.hpp

FORMS    += frontpanel.ui \
    utils/uartviewer.ui

LIBS +=\
    -lboost_system

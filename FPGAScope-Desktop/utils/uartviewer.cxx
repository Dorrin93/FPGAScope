#include "uartviewer.hpp"
#include "ui_uartviewer.h"

UARTViewer::UARTViewer(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::UARTViewer)
{
    ui->setupUi(this);
}

UARTViewer::~UARTViewer()
{
    delete ui;
}

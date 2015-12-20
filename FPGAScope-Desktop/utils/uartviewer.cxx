#include "uartviewer.hpp"
#include "ui_uartviewer.h"

FPGAScope::UARTViewer::UARTViewer(QWidget *parent) :
    QMainWindow(parent)
{
    ui = new Ui::UARTViewer();
    ui->setupUi(this);

    QPalette *p = new QPalette();
    p->setColor(QPalette::Base, Qt::black);
    ui->textBrowser->setPalette(*p);
    delete p;
    ui->textBrowser->setTextColor(Qt::green);
    ui->textBrowser->setText("  Ready to read.  ");
}

FPGAScope::UARTViewer::~UARTViewer()
{
    delete ui;
}

void FPGAScope::UARTViewer::addText(QString text)
{
    ui->textBrowser->append(text);
}

void FPGAScope::UARTViewer::readRawSamples()
{
   ui->textBrowser->append("");
   emit sampleRawCount(ui->spinBox->value());
}

void FPGAScope::UARTViewer::readDecodedSamples()
{
   ui->textBrowser->append("");
   emit sampleDecodedCount(ui->spinBox->value());
}

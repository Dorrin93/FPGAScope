#include "uartcontroller.hpp"
#include "QDebug"

FPGAScope::UARTController::UARTController(UARTViewer *v, FPGAScope::CoreUnit *r, QObject *parent):
    QObject(parent), view_(v), cunit_(r)
{
    //QObject::connect(this, &UARTController::package, view_, &UARTViewer::addText);
    QObject::connect(this, SIGNAL(package(QString)), view_, SLOT(addText(QString)));
    //QObject::connect(view_, &UARTViewer::sampleRawCount, this, &UARTController::readRawSamples);
    QObject::connect(view_, SIGNAL(sampleRawCount(uint)), this, SLOT(readRawSamples(uint)));
    //QObject::connect(view_, &UARTViewer::sampleDecodedCount, this, &UARTController::readDecodedSamples);
    QObject::connect(view_, SIGNAL(sampleDecodedCount(uint)), this, SLOT(readDecodedSamples(uint)));
}

void FPGAScope::UARTController::readRawPackage()
{
    unsigned char buffer[4] = {'\0'};

    cunit_->rawPackage(buffer);
    QString bits("  ");
    for(auto i = 0; i < 4; ++i){
        bits += QString("%1").arg(buffer[i], 8, 2, QChar('0'));
        bits.append(' ');
    }
    qDebug() << bits;

    emit package(bits);
}

void FPGAScope::UARTController::readDecodedPackage()
{
    double a, b;
    QString message("channel A: ");
    cunit_->decode(a, b);
    message += QString::number(a);
    message += " , channel B: ";
    message += QString::number(b);

    emit package(message);
}

void FPGAScope::UARTController::readRawSamples(unsigned samples)
{
    for(auto i = 0u; i < samples; ++i) {
        readRawPackage();
    }
}

void FPGAScope::UARTController::readDecodedSamples(unsigned samples)
{
    for(auto i = 0u; i < samples; ++i) {
        readDecodedPackage();
    }
}


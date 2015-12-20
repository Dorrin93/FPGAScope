#include "coreunit.hpp"
#include <QDebug>
#include <QString>

FPGAScope::CoreUnit::CoreUnit()
{
    _buffer = std::make_unique<CyclicBuffer>();
}

FPGAScope::CoreUnit::~CoreUnit()
{}

void FPGAScope::CoreUnit::doubleChannelTransmission()
{
    double a, b;
    decode(a, b);
    _buffer.get()->addToChannelA(a);
    _buffer.get()->addToChannelB(b);
}

void FPGAScope::CoreUnit::initUART(std::string portName, unsigned baudRate)
{
    _receiver = std::make_unique<UARTReceiver>(portName, baudRate);
}

void FPGAScope::CoreUnit::rawPackage(unsigned char pack[])
{
    //_receiver->readPackageAsync(pack);
    _receiver.get()->readPackageAsync(pack);
}

void FPGAScope::CoreUnit::decode(double &channelA, double &channelB)
{
    int mask = 0b0011111111111111;
    int signMask = 0b0010000000000000;
    int mask2 = 0b0001111111111111;

    unsigned char package[4];
    //_receiver->readPackageAsync(package);
    _receiver.get()->readPackageAsync(package);
    // DEBUG
    /*
    package[0] = 32;
    package[1] = 0;
    package[2] = 63;
    package[3] = 255;
    */
    int reads[2] = {0};
    reads[0] = (package[0] << 8) | (package[1] & 0xff);
    reads[1] = (package[2] << 8) | (package[3] & 0xff);
    reads[0] &= mask;
    reads[1] &= mask;

    if(reads[0] & signMask)
        reads[0] = (reads[0]&mask2)-8192;

    if(reads[1] & signMask)
        reads[1] = (reads[1]&mask2)-8192;


    qDebug() << transform(reads[0]);
    qDebug() << transform(reads[1]);
    qDebug() << QString::number(reads[0], 2);
    qDebug() << QString::number(reads[1], 2);
    //qDebug() << transform(0b10000000000000);
    channelA = transform(reads[0]);
    channelB = transform(reads[1]);

}

double *FPGAScope::CoreUnit::dataBase() const
{
    return _buffer.get()->baseData();
}

double *FPGAScope::CoreUnit::dataA() const
{
    return _buffer.get()->channelAData();
}

double *FPGAScope::CoreUnit::dataB() const
{
   return _buffer.get()->channelBData();
}


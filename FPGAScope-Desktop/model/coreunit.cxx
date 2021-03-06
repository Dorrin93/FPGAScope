#include "coreunit.hpp"
#include <QDebug>
#include <QString>

FPGAScope::CoreUnit::CoreUnit() : _triggeredA(_triggeredSize, 0), _triggeredB(_triggeredSize, 0), _buffer(400)
{}

FPGAScope::CoreUnit::~CoreUnit()
{}

void FPGAScope::CoreUnit::doubleChannelTransmission()
{
    double a, b;
    decode(a, b);
    emulate(a, b);
    _buffer.addToChannelA(a);
    _buffer.addToChannelB(b);
    if(!_forceA)
        setDataA();
    if(!_forceB)
        setDataB();
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
    _receiver.get()->readPackageAsync(package);
    //_receiver.get()->readPackage(package);

    int reads[2] = {0};
    reads[0] = (package[0] << 8) | (package[1] & 0xff);
    reads[1] = (package[2] << 8) | (package[3] & 0xff);
    reads[0] &= mask;
    reads[1] &= mask;

    if(reads[0] & signMask)
        reads[0] = (reads[0]&mask2)-8192;

    if(reads[1] & signMask)
        reads[1] = (reads[1]&mask2)-8192;

    /*
    qDebug() << transform(reads[0]);
    qDebug() << transform(reads[1]);
    qDebug() << QString::number(reads[0], 2);
    qDebug() << QString::number(reads[1], 2);
    */

    //qDebug() << transform(0b10000000000000);
    channelA = transform(reads[0]);
    channelB = transform(reads[1]);

}

void FPGAScope::CoreUnit::setDataA()
{
    _triggeredA.clear();
    auto iterA = _buffer.beginA();
    for(auto i = iterA; i != _buffer.endA()-1; ++i){
        if( (_triggerAVal >= *i && _triggerAVal <= *(i+1) && _risingSlope) ||
                (_triggerAVal <= *i && _triggerAVal >= *(i+1) && !_risingSlope) ){
            iterA = i+1;
            break;
        }
    }

    if(iterA+_triggeredSize <= _buffer.endA())
        std::copy(iterA, iterA+_triggeredSize, _triggeredA.begin());
    else
        std::copy(iterA, _buffer.endA(), _triggeredA.begin());

}

void FPGAScope::CoreUnit::setDataB()
{
    _triggeredB.clear();
    auto iterB = _buffer.beginB();

    for(auto i = iterB; i != _buffer.endB()-1; ++i){
        if( (_triggerBVal >= *i && _triggerBVal <= *(i+1) && _risingSlope) ||
                (_triggerBVal <= *i && _triggerBVal >= *(i+1) && !_risingSlope) ){
            iterB = i+1;
            break;
        }
    }


    //auto iterB = std::lower_bound(_buffer.beginB(), _buffer.endB(), _triggerBVal);
    //if(iterB == _buffer.endB()) iterB = _buffer.beginB();

    if(iterB+_triggeredSize <= _buffer.endB())
        std::copy(iterB, iterB+_triggeredSize, _triggeredB.begin());
    else
        std::copy(iterB, _buffer.endB(), _triggeredB.begin());
}

FPGAScope::dPair FPGAScope::CoreUnit::propertiesA() const
{
    auto res = std::minmax_element(_buffer.beginA(), _buffer.beginA()+_samplesA);
    return std::make_pair(fabs(*(res.second) - *(res.first)), (*(res.second) + *(res.first)) / 2.);
}

FPGAScope::dPair FPGAScope::CoreUnit::propertiesB() const
{
    auto res = std::minmax_element(_buffer.beginB(), _buffer.beginB()+_samplesB);
    return std::make_pair(fabs(*(res.second) - *(res.first)), (*(res.second) + *(res.first)) / 2.);
}

void FPGAScope::CoreUnit::emulate(double &a, double &b) const
{
    static long step = 0;
    static bool swt = false;

    swt ? a = 1.5 : a = 0.5;
    if(!(step % 6)) swt = !swt;
    b = sin(step*M_PI/2)*0.5 + 2.25;
    ++step;

}


#include "cyclicbuffer.hpp"
#include <QDebug>
#include <QString>

FPGAScope::CyclicBuffer::CyclicBuffer()
{
    _base = std::make_unique<dVec>(10000);
    _channelA = std::make_unique<dVec>(10000, 1.4);
    _channelB = std::make_unique<dVec>(10000, 1.8);
    std::iota(std::begin(*_base.get()), std::end(*_base.get()), 0);

}

double *FPGAScope::CyclicBuffer::baseData() const
{
    return _base.get()->data();
}

double *FPGAScope::CyclicBuffer::channelAData() const
{
    return _channelA.get()->data();
}

double *FPGAScope::CyclicBuffer::channelBData() const
{
   return _channelB.get()->data();
}

void FPGAScope::CyclicBuffer::addToChannelA(double val)
{
    if(_channelA.get()->size() == 10000)
        _channelA.get()->erase(_channelA.get()->begin());

    _channelA.get()->push_back(val);

}

void FPGAScope::CyclicBuffer::addToChannelB(double val)
{
    if(_channelB.get()->size() == 10000)
        _channelB.get()->erase(_channelB.get()->begin());

    _channelB.get()->push_back(val);
}


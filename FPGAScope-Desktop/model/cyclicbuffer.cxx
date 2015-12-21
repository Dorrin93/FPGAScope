#include "cyclicbuffer.hpp"
#include <QDebug>

FPGAScope::CyclicBuffer::CyclicBuffer(size_t bufferSize) : _buffersSize(bufferSize)
{
    _base = std::make_unique<dVec>(_buffersSize);
    _channelA = std::make_unique<dVec>(_buffersSize, 0);
    _channelB = std::make_unique<dVec>(_buffersSize, 0);
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
    //qDebug() << val;
    if(_channelA.get()->size() == _buffersSize)
        _channelA.get()->erase(_channelA.get()->begin());

    _channelA.get()->push_back(val);

}

void FPGAScope::CyclicBuffer::addToChannelB(double val)
{
    if(_channelB.get()->size() == _buffersSize)
        _channelB.get()->erase(_channelB.get()->begin());

    _channelB.get()->push_back(val);
}

#include "cyclicbuffer.hpp"
#include <QDebug>

FPGAScope::CyclicBuffer::CyclicBuffer(size_t bufferSize) : _buffersSize(bufferSize)
{
    _timebase = std::make_unique<dVec>(_buffersSize);
    _channelA = std::make_unique<dVec>(_buffersSize, 0);
    _channelB = std::make_unique<dVec>(_buffersSize, 0);
    std::iota(std::begin(*_timebase.get()), std::end(*_timebase.get()), 0);

}

double *FPGAScope::CyclicBuffer::timebaseData() const
{
    return _timebase.get()->data();
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
    /*
    qDebug() << "A:";
    qDebug() << val;
    */
    if(_channelA.get()->size() == _buffersSize)
        _channelA.get()->erase(_channelA.get()->begin());

    _channelA.get()->push_back(val);

}

void FPGAScope::CyclicBuffer::addToChannelB(double val)
{
    /*
    qDebug() << "B:";
    qDebug() << val;
    */
    if(_channelB.get()->size() == _buffersSize)
        _channelB.get()->erase(_channelB.get()->begin());

    _channelB.get()->push_back(val);
}

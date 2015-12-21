#ifndef COREUNIT_HPP
#define COREUNIT_HPP
#include "uartreceiver.hpp"
#include "cyclicbuffer.hpp"
#include <functional>
#include <memory>
#include <cmath>

namespace FPGAScope{

class CoreUnit
{
public:
    CoreUnit();
    ~CoreUnit();

    void doubleChannelTransmission();

    void initUART(std::string portName, unsigned baudRate);
    void rawPackage(unsigned char pack[]);
    void decode(double &channelA, double &channelB);
    void setDataA();
    void setDataB();

    const double *dataBase() const { return _buffer.baseData(); }
    const double *dataA()    const { return _triggeredA.data(); }
    const double *dataB()    const { return _triggeredB.data(); }

    void setTriggerA(double val) { _triggerAVal = val; }
    void setTriggerB(double val) { _triggerBVal = val; }
    void setSlope(bool state)    { _risingSlope = state; }
    double getTriggerA() const {return _triggerAVal; }
    double getTriggerB() const {return _triggerBVal; }

private:
    double _triggerAVal = 3;
    double _triggerBVal = 3;
    bool _risingSlope = true;
    dVec _triggeredA;
    dVec _triggeredB;

    CyclicBuffer _buffer;
    std::unique_ptr<UARTReceiver> _receiver;

    double transform(int read){ return -read * 1.25 / 8192 + 1.65; }

};
}

#endif // COREUNIT_HPP

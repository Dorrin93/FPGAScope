#ifndef COREUNIT_HPP
#define COREUNIT_HPP
#include "uartreceiver.hpp"
#include "cyclicbuffer.hpp"
#include <functional>
#include <memory>

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
    double *dataBase() const;
    double *dataA() const;
    double *dataB() const;

private:
    std::unique_ptr<UARTReceiver> _receiver;
    std::unique_ptr<CyclicBuffer> _buffer;
    double transform(int read){ return -read * 1.25 / 8192 + 1.65; }


};
}

#endif // COREUNIT_HPP

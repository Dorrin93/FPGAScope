#ifndef COREUNIT_HPP
#define COREUNIT_HPP
#include "uartreceiver.hpp"
#include "cyclicbuffer.hpp"
#include <functional>
#include <memory>
#include <cmath>
#include <tuple>
#include <utility>


/**
 * @addtogroup FPGAScope
 * @{
 */

//* FPGA and C++ Oscilloscope implementation
namespace FPGAScope{

using dPair = std::pair<double, double>;

/**
 * @class CoreUnit
 * @brief The main oscillocope unit class.
 *
 * CoreUnit represents Model in MVC pattern. It governs data flow,
 * from UART all the way to graphical buffers. This includes such
 * things as trigger, slope, calculating signal properties etc.
 */
class CoreUnit
{
public:
    /**
     * @brief Constructor.
     */
    CoreUnit();
    /**
     * @brief Destructor.
     */
    ~CoreUnit();

    /**
     * @brief Full cycle of gathering and processing one sample.
     *
     * Method takes one package from serial port, decodes values from
     * binary to double, puts them to cyclic buffer and refreshes graphical
     * buffer with samples from cyclic buffer, corresponding to trigger value.
     * It should be called from outside with short time intervals.
     */
    void doubleChannelTransmission();
    /**
     * @brief Getter for channel A signal properties.
     * @return Pair of double, containing amplitude and offset.
     */
    dPair propertiesA() const;
    /**
     * @brief Getter for channel B signal properties.
     * @return Pair of double, containing amplitude and offset.
     */
    dPair propertiesB() const;

    /**
     * @brief Method creating instance of UARTReceiver.
     * @param portName Path to port, from which samples will be read.
     * @param baudRate Transfer speed, in bauds.
     *
     * This method should be called only once, just after creating
     * instance of CoreUnit. It initializes
     * UART connection with given port path and speed.
     */
    void initUART(std::string portName, unsigned baudRate);
    /**
     * @brief Wrapper for async read from UARTReceiver.
     * @param pack Array, which will hold read data.
     *
     * Not realy needed, usefull for debug.
     */
    void rawPackage(unsigned char pack[]);
    /**
     * @brief Read from UARTReceiver and decode.
     * @param channelA Variable to hold decoded channel A sample value.
     * @param channelB Variable to hold decoded channel B sample value.
     *
     * Method synchronously reads one package, decode values from binary
     * to double and writes them to passed variables.
     * Included in doubleChannelTransmission().
     */
    void decode(double &channelA, double &channelB);
    /**
     * @brief Graphic buffer A filling.
     *
     * Method fills gaphical buffer A from cyclic buffer.
     * Inital sample from cyclic buffer is calculated using trigger value.
     * Included in doubleChannelTransmission().
     */
    void setDataA();
    /**
     * @brief Graphic buffer B filling.
     *
     * Method fills gaphical buffer B from cyclic buffer.
     * Inital sample from cyclic buffer is calculated using trigger value.
     * Included in doubleChannelTransmission().
     */
    void setDataB();

    /**
     * @brief Wrapper for timebaseData() from CyclicBuffer.
     * @return Pointer to timebase vector internal array.
     */
    const double *dataTimebase() const { return _buffer.timebaseData(); }
    /**
     * @brief Getter for low level grapical buffer A access.
     * @return Pointer to graphical buffer A internal array.
     */
    const double *dataA()        const { return _triggeredA.data(); }
    /**
     * @brief Getter for low level grapical buffer B access.
     * @return Pointer to graphical buffer B internal array.
     */
    const double *dataB()        const { return _triggeredB.data(); }

    /**
     * @brief Trigger A value setter.
     * @param val Value to set.
     */
    void setTriggerA(double val)  { _triggerAVal = val; }
    /**
     * @brief Trigger B value setter.
     * @param val Value to set.
     */
    void setTriggerB(double val)  { _triggerBVal = val; }
    /**
     * @brief Force trigger A state setter.
     * @param state Force trigger state.
     */
    void setForceA(bool state)    { _forceA = state; }
    /**
     * @brief Force trigger B state setter.
     * @param state Force trigger state.
     */
    void setForceB(bool state)    { _forceB = state; }
    /**
     * @brief Trigger slope type setter.
     * @param state Rising if true, falling if false.
     */
    void setSlope(bool state)     { _risingSlope = state; }
    /**
     * @brief Triggered samples A count setter.
     * @param samples Sample count.
     */
    void setSamplesA(int samples) { _samplesA = samples; }
    /**
     * @brief Triggered samples B count setter.
     * @param samples Sample count.
     */
    void setSamplesB(int samples) { _samplesB = samples; }
    /**
     * @brief Trigger A value getter.
     * @return Channel A trigger value.
     */
    double getTriggerA() const    { return _triggerAVal; }
    /**
     * @brief Trigger B value getter.
     * @return Channel B trigger value.
     */
    double getTriggerB() const    { return _triggerBVal; }

private:
    size_t _triggeredSize = 260;
    double _triggerAVal = 3;
    double _triggerBVal = 3;
    int _samplesA = 32;
    int _samplesB = 32;
    bool _risingSlope = true;
    bool _forceA = false;
    bool _forceB = false;
    dVec _triggeredA;
    dVec _triggeredB;

    CyclicBuffer _buffer;
    std::unique_ptr<UARTReceiver> _receiver;

    double transform(int read) const { return -read * 1.25 / 8192 + 1.65; }
    void emulate(double &a, double &b) const;

};
}

/** @} End of group */

#endif // COREUNIT_HPP

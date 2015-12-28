#ifndef CYCLICBUFFER_HPP
#define CYCLICBUFFER_HPP
#include <memory>
#include <vector>


/**
 * @addtogroup FPGAScope
 * @{
 */

//* FPGA and C++ Oscilloscope implementation
namespace FPGAScope {

using dVec = std::vector<double>;

/**
 * @class CyclicBuffer
 * @brief The Cyclic Buffer class.
 *
 * Class implements concept of cyclic buffer. Implementation is
 * based on std::vector, so it's not fastets solution, but it
 * allows to hold data in one, long memory segment.
 * CyclicBuffer contains two buffers - one for each channel, and
 * third vector for timebase.
 */
class CyclicBuffer
{
public:
    /**
     * @brief Constructor.
     * @param bufferSize Lenght of vectors. Default to 1000 samples.
     */
    CyclicBuffer(size_t bufferSize = 1000);
    /**
     * @brief Getter for low level timebase access.
     * @return Pointer to timebase vector internal array.
     */
    double *timebaseData() const;
    /**
     * @brief Getter for low level channel A samples access.
     * @return Pointer to channel A vector internal array.
     */
    double *channelAData() const;
    /**
     * @brief Getter for low level channel B samples access.
     * @return Pointer to channel B vector internal array.
     */
    double *channelBData() const;
    /**
     * @brief Method for adding new sample to channel A.
     * @param val Sample to add.
     *
     * Method "rotates" buffer one position forward, and
     * adds sample on last postion.
     */
    void addToChannelA(double val);
    /**
     * @brief Method for adding new sample to channel B.
     * @param val Sample to add.
     *
     * Method "rotates" buffer one position forward, and
     * adds sample on last postion.
     */
    void addToChannelB(double val);

    /**
     * @brief Buffer size getter.
     * @return Buffer size.
     */
    size_t bufferSize() const { return _buffersSize; }

    /**
     * @brief Getter for the begin of channel A buffer.
     * @return Begin iterator of channel A vector.
     */
    auto beginA() const { return std::begin(*_channelA.get()); }
    /**
     * @brief Getter for the end of channel A buffer.
     * @return End iterator of channel A vector.
     */
    auto endA() const { return std::end(*_channelA.get()); }


    /**
     * @brief Getter for the begin of channel B buffer.
     * @return Begin iterator of channel B vector.
     */
    auto beginB() const { return std::begin(*_channelB.get()); }
    /**
     * @brief Getter for the end of channel B buffer.
     * @return End iterator of channel B vector.
     */
    auto endB() const { return std::end(*_channelB.get()); }



private:
    const size_t _buffersSize;
    std::unique_ptr<dVec> _timebase;
    std::unique_ptr<dVec> _channelA;
    std::unique_ptr<dVec> _channelB;

};
}

/** @} End of group */

#endif // CYCLICBUFFER_HPP

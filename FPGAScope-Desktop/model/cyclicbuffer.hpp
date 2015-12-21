#ifndef CYCLICBUFFER_HPP
#define CYCLICBUFFER_HPP
#include <memory>
#include <vector>

namespace FPGAScope {

using dVec = std::vector<double>;

class CyclicBuffer
{
public:
    CyclicBuffer(size_t bufferSize = 1000);
    double *baseData() const;
    double *channelAData() const;
    double *channelBData() const;
    void addToChannelA(double val);
    void addToChannelB(double val);

    size_t bufferSize() const { return _buffersSize; }

    auto beginA() const { return std::begin(*_channelA.get()); }
    auto endA() const { return std::end(*_channelA.get()); }

    auto beginB() const { return std::begin(*_channelB.get()); }
    auto endB() const { return std::end(*_channelB.get()); }



private:
    const size_t _buffersSize;
    std::unique_ptr<dVec> _base;
    std::unique_ptr<dVec> _channelA;
    std::unique_ptr<dVec> _channelB;

};
}

#endif // CYCLICBUFFER_HPP

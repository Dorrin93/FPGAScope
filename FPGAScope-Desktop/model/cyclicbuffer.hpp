#ifndef CYCLICBUFFER_HPP
#define CYCLICBUFFER_HPP
#include <memory>
#include <vector>

namespace FPGAScope {

using dVec = std::vector<double>;

class CyclicBuffer
{
public:
    CyclicBuffer();
    double *baseData() const;
    double *channelAData() const;
    double *channelBData() const;
    void addToChannelA(double val);
    void addToChannelB(double val);



private:
    std::unique_ptr<dVec> _base;
    std::unique_ptr<dVec> _channelA;
    std::unique_ptr<dVec> _channelB;

};
}

#endif // CYCLICBUFFER_HPP

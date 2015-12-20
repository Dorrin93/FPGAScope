#ifndef UARTRECEIVER_HPP
#define UARTRECEIVER_HPP
#include <string>
#include <boost/asio/serial_port.hpp>
#include <boost/asio.hpp>
#include <boost/asio/read.hpp>
#include <boost/bind.hpp>

namespace FPGAScope{

using namespace boost;

void read_callback(bool &data_available, asio::deadline_timer &timeout,
                       const system::error_code &error,
                       std::size_t bytes_transfered);
void wait_callback(asio::serial_port &port, const system::error_code &error);


class UARTReceiver
{
public:
    UARTReceiver();
    UARTReceiver(std::string portName, unsigned baudRate);
    ~UARTReceiver();
    void readPackage(unsigned char pack[]);
    void readPackageAsync(unsigned char pack[]);

    UARTReceiver(const UARTReceiver &) = delete;

private:
    asio::io_service io_;
    asio::serial_port port_;

    asio::deadline_timer timeout_;
};

}

#endif // UARTRECEIVER_HPP

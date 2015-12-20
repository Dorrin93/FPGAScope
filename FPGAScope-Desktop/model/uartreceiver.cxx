#include "uartreceiver.hpp"
#include <QDebug>

FPGAScope::UARTReceiver::UARTReceiver():io_(), port_(io_), timeout_(io_)
{
    port_.open("/dev/ttyS2");
    port_.set_option(asio::serial_port_base::baud_rate(115200));
}

FPGAScope::UARTReceiver::UARTReceiver(std::string portName, unsigned baudRate):io_(), port_(io_), timeout_(io_)
{
    port_.open(portName.c_str());
    port_.set_option(asio::serial_port_base::baud_rate(baudRate));
}

FPGAScope::UARTReceiver::~UARTReceiver()
{
    port_.close();
}

void FPGAScope::UARTReceiver::readPackage(unsigned char pack[])
{
    asio::read(port_, asio::buffer(pack, 4));
}

void FPGAScope::UARTReceiver::readPackageAsync(unsigned char pack[])
{
    bool data_available = false;
    port_.async_read_some(asio::buffer(pack, 4),
                          bind(&read_callback, ref(data_available), ref(timeout_),
                               asio::placeholders::error,
                               asio::placeholders::bytes_transferred));
    timeout_.expires_from_now(posix_time::milliseconds(1));
    timeout_.async_wait(bind(&wait_callback, ref(port_), asio::placeholders::error));

    io_.run();
    if(!data_available){
        for(auto i = 0; i < 4; ++i)
            pack[i] = 0;
    }
    io_.reset();

}

void FPGAScope::read_callback(bool &data_available, boost::asio::deadline_timer &timeout,
                                            const boost::system::error_code &error,
                                            std::size_t bytes_transfered)
{
    if(error || bytes_transfered < 4){
        data_available = false;
        return;
    }
    timeout.cancel();
    data_available = true;
}

void FPGAScope::wait_callback(asio::serial_port &port, const boost::system::error_code &error)
{
    if(error) return;
    port.cancel();
}

#ifndef UARTRECEIVER_HPP
#define UARTRECEIVER_HPP
#include <string>
#include <boost/asio/serial_port.hpp>
#include <boost/asio.hpp>
#include <boost/asio/read.hpp>
#include <boost/bind.hpp>

/**
 * @addtogroup FPGAScope
 * @{
 */

//* FPGA and C++ Oscilloscope implementation
namespace FPGAScope{

using namespace boost;

/**
 * @brief Callback handler for read in async data reception.
 * @param data_available Bool to change depending on data availability.
 * @param timeout Timer to stop if data are available.
 * @param error Error to check. If not null, data are not available.
 * @param bytes_transfered Amount of bytes to transfer in one package.
 */
void read_callback(bool &data_available, asio::deadline_timer &timeout,
                       const system::error_code &error,
                       std::size_t bytes_transfered);
/**
 * @brief Callback handler for waiting in async data reception.
 * @param port Port to cancel reception if there are no errors.
 * @param error Error to check. If not null, data reception from port is not cancelled.
 */
void wait_callback(asio::serial_port &port, const system::error_code &error);


/**
 * @class UARTReceiver
 * @brief The UART Receiver class.
 *
 * Class provides interface for synchronous and asynchronous
 * read from serial port, using Boost::Asio library.
 * As it is created for FPGAScope, it always reads 4 bytes of data.
 */
class UARTReceiver
{
public:
    /**
     * @brief Default constructor.
     * If no arguments provided, class tries to open port
     * on /dev/ttyS2 path, with 115200 baud rate.
     * If failed, exception is thrown.
     */
    UARTReceiver();
    /**
     * @brief Constructor.
     * @param portName Path to port, from which samples will be read.
     * @param baudRate Transfer speed, in bauds.
     *
     * If opening fails, exception is thrown.
     */
    UARTReceiver(std::string portName, unsigned baudRate);
    /**
      * @brief Destructor. Used for closing port.
      */
    ~UARTReceiver();
    /**
     * @brief Blocking, synchronous read from opened port.
     * @param pack Array, which will hold read data.
     */
    void readPackage(unsigned char pack[]);
    /**
     * @brief Async, non-blocking read from opened port.
     * @param pack Array, which will hold read data.
     *
     * Method will wait for data transfer in 5 ms. If data
     * provided, it will be written to pack. If not,
     * metod will write zeroes.
     */
    void readPackageAsync(unsigned char pack[]);

    UARTReceiver(const UARTReceiver &) = delete;

private:
    asio::io_service io_;
    asio::serial_port port_;

    asio::deadline_timer timeout_;
};

}

/** @} End of group */

#endif // UARTRECEIVER_HPP

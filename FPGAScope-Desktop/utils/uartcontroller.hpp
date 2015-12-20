#ifndef UARTCONTROLLER_HPP
#define UARTCONTROLLER_HPP

#include "uartviewer.hpp"
#include "uartcontroller.hpp"
#include "model/coreunit.hpp"

namespace FPGAScope{

class UARTController : public QObject
{
    Q_OBJECT
public:
    UARTController(UARTViewer *v, FPGAScope::CoreUnit *r, QObject *parent = 0);


signals:
    void package(QString);

public slots:
    void readRawSamples(unsigned samples);
    void readDecodedSamples(unsigned samples);

private:
    void readRawPackage();
    void readDecodedPackage();

    UARTViewer *view_;
    CoreUnit *cunit_;

};

}

#endif // UARTCONTROLLER_HPP

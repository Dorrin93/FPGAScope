#ifndef CONTROLLER_HPP
#define CONTROLLER_HPP
#include "../frontpanel.hpp"
#include "../model/coreunit.hpp"
#include "../utils/uartcontroller.hpp"
#include <memory>
#include <QThread>
#include <QTimer>

namespace FPGAScope{

class Controller : public QThread
{
    Q_OBJECT
public:
    Controller(FrontPanel *panel, CoreUnit *unit, QObject *parent = 0);
    ~Controller();

private slots:
    void transmit();

signals:
    void updater();


private:
    void run();
    FrontPanel *_panel;
    CoreUnit *_unit;

    //DEBUG
    std::unique_ptr<UARTController> _ucontrol;

};
}

#endif // CONTROLLER_HPP

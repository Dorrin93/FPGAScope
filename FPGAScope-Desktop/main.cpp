#include "frontpanel.hpp"
#include <QApplication>
#include <QDebug>
#include "controller/controller.hpp"
#include "model/coreunit.hpp"
#include <thread>


int main(int argc, char *argv[])
{
    qDebug() << "start";
    QApplication a(argc, argv);
    FPGAScope::FrontPanel w;
    FPGAScope::CoreUnit cu;
    cu.initUART("/dev/pts/2", 115200);
    // /dev/ttyS2
    FPGAScope::Controller c(&w, &cu);

    c.start();
    w.show();
    a.exec();
    c.quit();
    c.wait();
    return 0;
}

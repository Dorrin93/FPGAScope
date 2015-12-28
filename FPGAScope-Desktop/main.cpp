#include "frontpanel.hpp"
#include <QApplication>
#include <QDebug>
#include "controller/controller.hpp"
#include "model/coreunit.hpp"
#include <thread>
#include <QInputDialog>
#include <QMessageBox>


int main(int argc, char *argv[])
{
    qDebug() << "start";
    QApplication a(argc, argv);

    bool ok;
    QString channel = QInputDialog::getText(nullptr, QString::fromUtf8("Ścieżka do portu szeregowego"),
                                            QString::fromUtf8("Podaj ścieżkę portu szeregowego:"),
                                            QLineEdit::Normal, QString("/dev/pts/1"), &ok);
    if(!ok) return 0;

    FPGAScope::CoreUnit cu;
    try{
        cu.initUART(channel.toStdString(), 115200);
    }
    catch(boost::system::system_error &e){
        qDebug() << e.what();
        QMessageBox m;
        m.critical(nullptr, QString::fromUtf8("Błąd"),
                   channel + "\n" + QString(e.what()));
        m.setFixedSize(500, 200);
    }

    FPGAScope::FrontPanel w;
    FPGAScope::Controller c(&w, &cu);

    c.start();
    w.show();
    a.exec();
    c.quit();
    c.wait();
    return 0;
}

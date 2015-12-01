#ifndef UARTVIEWER_HPP
#define UARTVIEWER_HPP

#include <QMainWindow>

namespace Ui {
class UARTViewer;
}

class UARTViewer : public QMainWindow
{
    Q_OBJECT

public:
    explicit UARTViewer(QWidget *parent = 0);
    ~UARTViewer();

private:
    Ui::UARTViewer *ui;
};

#endif // UARTVIEWER_HPP

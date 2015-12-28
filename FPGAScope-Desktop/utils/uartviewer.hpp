#ifndef UARTVIEWER_HPP
#define UARTVIEWER_HPP

#include <QMainWindow>

namespace Ui {
    class UARTViewer;
}

namespace FPGAScope{

class UARTViewer : public QMainWindow
{
    Q_OBJECT

public:
    explicit UARTViewer(QWidget *parent = 0);
    ~UARTViewer();

public slots:
    void addText(QString text);

signals:
    void sampleRawCount(unsigned);
    void sampleDecodedCount(unsigned);

private slots:
    void readRawSamples();
    void readDecodedSamples();

private:
    Ui::UARTViewer *ui;

};

}
#endif // UARTVIEWER_HPP

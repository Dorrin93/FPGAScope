#ifndef FRONTPANEL_HPP
#define FRONTPANEL_HPP

#include <QMainWindow>
#include <QMessageBox>
#include <memory>
#include <qwt_plot_curve.h>
#include <qwt_plot_grid.h>
#include "utils/uartviewer.hpp"

namespace Ui {
class FrontPanel;
}

/**
 * @addtogroup FPGAScope
 * @{
 */

//* FPGA and C++ Oscilloscope implementation
namespace FPGAScope{

/**
 * @class FrontPanel
 * @brief Front panel of the digital oscilloscope
 *
 * This class represents front panel of C++ digital oscilloscope implementation.
 * Panel includes Qwt plot, two channel controls and trigger control.
 * FrontPanel class also represents View in Model-View-Controller pattern.
 */
class FrontPanel : public QMainWindow
{
    Q_OBJECT

public:
    /**
     * @brief FrontPanel constructor.
     * @param parent Parental widget.
     */
    explicit FrontPanel(QWidget *parent = 0);
    /**
     * @brief FrontPanel desctructor
     */
    ~FrontPanel();

    /**
     * @brief Debug window getter.
     * @return UARTViewer* Pointer to debug window.
     */
    UARTViewer *uviewer() { return _uview.get(); }

    /**
     * @brief Connector for channel A graphical buffer.
     * @param basePtr Pointer to timebase data.
     * @param dataPtr Pointer to channel A triggered samples.
     * @param samples Samples count.
     *
     * Method passes raw data pointers to timebase and samples to QwtPlotCurve object.
     * Based on this data, proper curve is created, and attached to plot.
     * Curve object doesn't manage the data. It doesn't know when data is
     * changed, so each time when it happends, explicit replot is needed.
     */
    void connectChannelA(const double *basePtr, const double *dataPtr, int samples);

    /**
     * @brief Connector for channel B graphical buffer.
     * @param basePtr Pointer to timebase data.
     * @param dataPtr Pointer to channel B triggered samples.
     * @param samples Samples count.
     *
     * Method passes raw data pointers of timebase and samples to QwtPlotCurve object.
     * Based on this data, proper curve is created, and attached to plot.
     * Curve object doesn't manage the data. It doesn't know when data is
     * changed, so each time when it happends, explicit replot is needed.
     */
    void connectChannelB(const double *basePtr, const double *dataPtr, int samples);

signals:
    /**
     * @brief Trigger A Value emitter.
     */
    void triggerAChanged(double);
    /**
     * @brief Trigger B Value emitter.
     */
    void triggerBChanged(double);
    /**
     * @brief Current trigger channel emitter.
     */
    void switchedTrigger(char);
    /**
     * @brief Slope state emitter.
     */
    void switchedSlope(bool);
    /**
     * @brief Force trigger state with channel indicator emitter.
     */
    void switchedForce(bool, char);
    /**
     * @brief Current samples count with channel indicator emitter.
     */
    void changedFreq(int, char);

public slots:
    /**
     * @brief Plot refresher.
     *
     * When this slot receives appropriate signal, main view is replotted.
     */
    void refreshPlot();
    /**
     * @brief Trigger knob value setter.
     * @param val Value which needs to be set.
     *
     * Trigger is two-state, and View does not remember its values.
     * When trigger is switched to another channel, signal with
     * that channels trigger value is send and View can set proper value.
     */
    void setTriggerVal(double val);
    /**
     * @brief Amplitude viewer value setter.
     * @param val Current amplitude value.
     * @param channel Channel to set value on.
     *
     * There are two small lcd screens which shows current
     * amplitude values. When signal is send, this slot sets
     * value on proper screen; there are two options: 'A' and 'B'.
     */
    void setAmplitude(double val, char channel);
    /**
     * @brief Offset viewer value setter.
     * @param val Current offset value.
     * @param channel Channel to set value on.
     *
     * There are two small lcd screens which shows current
     * offset values. When signal is send, this slot sets
     * value on proper screen; there are two options: 'A' and 'B'.
     */
    void setOffset(double val, char channel);

private slots:
    void triggerValChanged(double val);
    void execUARTViewer();
    void switchChannelA(bool state);
    void switchChannelB(bool state);
    void switchTriggerA(bool state);
    void switchTriggerB(bool state);
    void switchSlope(bool state);
    void switchInterpA(bool state);
    void switchInterpB(bool state);
    void switchForce(bool state);
    void changeFreqA(int val);
    void changeFreqB(int val);
    void showInfo();

private:
    Ui::FrontPanel *ui;
    QwtPlotCurve *_crvA;
    QwtPlotCurve *_crvB;
    QwtPlotCurve *_cursA;
    QwtPlotCurve *_cursB;
    QwtPlotGrid *_grd;
    bool _triggerA;
    bool _forceA;
    bool _forceB;
    double _cursBaseTab[2];
    double _cursATab[2];
    double _cursBTab[2];

    //DEBUG
    std::unique_ptr<UARTViewer> _uview;

};

}

/** @} End of group */

#endif // FRONTPANEL_HPP

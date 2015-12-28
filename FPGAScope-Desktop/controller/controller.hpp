#ifndef CONTROLLER_HPP
#define CONTROLLER_HPP
#include "../frontpanel.hpp"
#include "../model/coreunit.hpp"
#include "../utils/uartcontroller.hpp"
#include <memory>
#include <QThread>
#include <QTimer>

/**
 * @addtogroup FPGAScope
 * @{
 */

//* FPGA and C++ Oscilloscope implementation
namespace FPGAScope{

/**
 * @class Controller
 * @brief The Controller class
 *
 * Controller creates a bridge between the View and the Model in MVC pattern.
 * It connects itself with the View using signals and slots, and calls methods from
 * model using public interface. Controller also extends QThread class, what makes
 * it a special worker thread, for gathering and processing data outside GUI thread.
 */
class Controller : public QThread
{
    Q_OBJECT
public:
    /**
     * @brief Constructor.
     * @param panel Pointer to FrontPanel (View) instance.
     * @param unit Pointer to CoreUnit (Model) instance.
     * @param parent Parent widget. Default to nullptr.
     */
    Controller(FrontPanel *panel, CoreUnit *unit, QObject *parent = nullptr);
    /**
     * @brief Destructor
     */
    ~Controller();

public slots:
    /**
     * @brief Channels A trigger setter.
     * @param val Trigger value.
     *
     * Slot receives trigger A value from user interface,
     * and forwards it to the Model.
     */
    void setTriggerAVal(double val);
    /**
     * @brief Channels B trigger setter.
     * @param val Trigger value.
     *
     * Slot receives trigger B value from user interface,
     * and forwards it to the Model.
     */
    void setTriggerBVal(double val);
    /**
     * @brief Slot for getting current trigger value.
     * @param channel Channel from which trigger values should be taken.
     *
     * When this slot receives channel letter, it takes its trigger
     * value from the Model, and passes it back to the View.
     */
    void triggerSwitched(char channel);
    /**
     * @brief Slope switching slot.
     * @param state Current slope state.
     *
     * Slot sets slope state. If true, Model uses rising slope, if false
     * falling slope.
     */
    void slopeSwitched(bool state);
    /**
     * @brief Force trigger indicator setter.
     * @param state Current force trigger state.
     * @param channel Channel to force or unforce trigger.
     *
     * Slot receives force trigger state and channel letter,
     * and forwards state using proper Model method.
     */
    void forceSwitched(bool state, char channel);
    /**
     * @brief Frequency value changer.
     * @param val Sample count and frequency marker.
     * @param channel Channel to change sample count.
     *
     * Slot calculate sample count from received marker. Then, it
     * forward this count to the Model, and reconnect data in the View,
     * to fit it to current sample count.
     */
    void freqChanged(int val, char channel);

private slots:
    void transmit();

signals:
    /**
     * @brief Grapfic buffer change notyfication emitter.
     */
    void updater();
    /**
     * @brief Currently chosen trigger value emitter.
     */
    void triggerVal(double);
    /**
     * @brief Emitter of current amplitude value with proper channel.
     */
    void ampVal(double, char);
    /**
     * @brief Emitter of current offset value with proper channel.
     */
    void offsetVal(double, char);


private:
    void run();
    FrontPanel *_panel;
    CoreUnit *_unit;

    //DEBUG
    std::unique_ptr<UARTController> _ucontrol;

};
}

/** @} End of group */

#endif // CONTROLLER_HPP

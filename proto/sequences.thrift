namespace java com.rbkmoney.damsel.sequences
namespace erlang sequences

/**
 * Идентификатор сиквенса
 */
typedef string SequenceId

/**
 * Значение счетчика
 */
typedef i64 Value

service Sequences {

	/**
     * Получить текущее значение счетчика
     */
    Value GetCurrent (1: SequenceId sequence_id)

    /**
     * Получить следующее значение счетчика
     */
    Value GetNext (1: SequenceId sequence_id, 2: Value current_value, 3: Value max_value)

}
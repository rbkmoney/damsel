namespace java com.rbkmoney.damsel.sequence_service
namespace erlang sequence_service

typedef string Sequence
typedef i64 Id

service SeqService {

	/**
     * Получить текущий id
     */
    Id GetCurrent (1: Sequence sequence)

    /**
     * Установить текущий id, возвращается следующий id
     */
    Id SetCurrent (1: Sequence sequence, 2: Id id)

    /**
     * Получить следующий id
     */
    Id GetNext (1: Sequence sequence)

}
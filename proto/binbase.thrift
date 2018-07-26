include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.binbase
namespace erlang binbase

/**
* Данные о БИН
* payment_system - платежная система
* bank_name - наименование банка
* country - страна эмитента
* card_type - тип карты
*/
struct BinData {
    1: required CardPaymentSystem payment_system
    2: optional string bank_name
    3: optional domain.Residence country
    4: optional CardType card_type
    //TODO нужно ли вообще?
    5: optional string url
    6: optional string phone_number
}

enum CardType {
    charge_card
    credit
    debit
    credit_or_debit
}

/**
* Платежные системы, где:
* available - платежные системы, описанные в домене
* other - платежные системы, которых нет в домене (пр. SBERCARD, TROY и т.д.)
*/
union CardPaymentSystem {
    1: domain.BankCardPaymentSystem available
    2: string other
}

struct Last {}

typedef i64 Version

/**
* Версия данных БИН
* version - указание версии
* last - последняя версия
*/
union Reference {
    1: Version version
    2: Last last
}

exception BinNotFound {}

service Binbase {

    /**
    * Получить данные по БИН
    * bin - бизнес-идентификационный номер (6 знаков)
    * reference - версия данных БИН
    * возращает данные БИН
    * кидает BinNotFound, если данных о БИН нет
    */
    BinData Lookup (1: string bin, 2: Reference reference) throws (1: BinNotFound not_found)

}
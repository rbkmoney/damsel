/**
 * Определения и сервисы процессинга.
 */

include "domain.thrift"

/** Платёж, состоящий из суммы и валюты. */
struct Payment {
    1: required domain.Amount amount
    2: required domain.CurrencyRef currency
}

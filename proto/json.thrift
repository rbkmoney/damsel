namespace erlang json
namespace java com.rbkmoney.damsel.json

/**
 * Значение в JSON, согласно [RFC7159](https://tools.ietf.org/html/rfc7159).
 */
union Value {
    1: Null nl
    2: bool bl
    3: i32 int      // от -(2^31) до (2^31 - 1)
    4: double flt
    5: string str   // UTF-8
    6: Object obj   // Ключи свойств закодированы в UTF-8
    7: Array arr
}

struct Null {}
typedef list<Value> Array
typedef map<string, Value> Object

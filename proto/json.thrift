/**
 * Значение в JSON, согласно [RFC7159](https://tools.ietf.org/html/rfc7159).
 */
union Value {
    1: Null n
    2: bool b
    3: i64 i
    4: double f
    5: string s
    6: Object o
    7: Array a
}

struct Null {}
typedef list<Value> Array
typedef map<string, Value> Object
